#ifndef EPOLLCOMPAT_HPP
# define EPOLLCOMPAT_HPP

# if defined(__linux__)
#  include <sys/epoll.h>
# else
#  include <poll.h>
#  include <vector>
#  include <map>
#  include <cerrno>
#  include <unistd.h>
#  include <stdint.h>
#  include <fcntl.h>

#  define EPOLLIN      0x001
#  define EPOLLPRI     0x002
#  define EPOLLOUT     0x004
#  define EPOLLERR     0x008
#  define EPOLLHUP     0x010
#  define EPOLLRDHUP   0x2000
#  define EPOLLET      (1u << 31)

#  define EPOLL_CTL_ADD 1
#  define EPOLL_CTL_DEL 2
#  define EPOLL_CTL_MOD 3

typedef union epoll_data {
    void    *ptr;
    int      fd;
    uint32_t u32;
    uint64_t u64;
} epoll_data_t;

struct epoll_event {
    uint32_t     events;
    epoll_data_t data;
};

inline std::map<int, std::map<int, uint32_t> >& get_epoll_instances() {
    static std::map<int, std::map<int, uint32_t> > instances;
    return instances;
}

inline int epoll_create1(int flags) {
    (void)flags;
    int p[2];
    if (pipe(p) == -1)
        return -1;
    ::close(p[1]);
    get_epoll_instances()[p[0]] = std::map<int, uint32_t>();
    return p[0];
}

inline int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event) {
    std::map<int, std::map<int, uint32_t> >& inst = get_epoll_instances();
    std::map<int, std::map<int, uint32_t> >::iterator it = inst.find(epfd);
    if (it == inst.end()) {
        errno = EBADF;
        return -1;
    }
    if (op == EPOLL_CTL_ADD || op == EPOLL_CTL_MOD) {
        if (!event) {
            errno = EINVAL;
            return -1;
        }
        it->second[fd] = event->events;
        return 0;
    } else if (op == EPOLL_CTL_DEL) {
        it->second.erase(fd);
        return 0;
    }
    errno = EINVAL;
    return -1;
}

inline int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout) {
    std::map<int, std::map<int, uint32_t> >& inst = get_epoll_instances();
    std::map<int, std::map<int, uint32_t> >::iterator it = inst.find(epfd);
    if (it == inst.end()) {
        errno = EBADF;
        return -1;
    }
    std::vector<struct pollfd> pfds;
    pfds.reserve(it->second.size());
    for (std::map<int, uint32_t>::const_iterator fd_it = it->second.begin(); fd_it != it->second.end(); ++fd_it) {
        struct pollfd pfd;
        pfd.fd = fd_it->first;
        pfd.events = 0;
        pfd.revents = 0;
        if (fd_it->second & EPOLLIN) pfd.events |= POLLIN;
        if (fd_it->second & EPOLLOUT) pfd.events |= POLLOUT;
        if (fd_it->second & EPOLLPRI) pfd.events |= POLLPRI;
        pfds.push_back(pfd);
    }
    if (pfds.empty()) {
        if (timeout > 0)
            usleep(timeout * 1000);
        return 0;
    }
    int ret = poll(&pfds[0], pfds.size(), timeout);
    if (ret <= 0)
        return ret;
    int count = 0;
    for (size_t i = 0; i < pfds.size() && count < maxevents; ++i) {
        if (pfds[i].revents != 0) {
            events[count].data.fd = pfds[i].fd;
            events[count].events = 0;
            if (pfds[i].revents & POLLIN) events[count].events |= EPOLLIN;
            if (pfds[i].revents & POLLOUT) events[count].events |= EPOLLOUT;
            if (pfds[i].revents & POLLERR) events[count].events |= EPOLLERR;
            if (pfds[i].revents & POLLHUP) events[count].events |= (EPOLLHUP | EPOLLRDHUP);
            if (pfds[i].revents & POLLNVAL) events[count].events |= EPOLLERR;
            count++;
        }
    }
    return count;
}

# endif

#endif
