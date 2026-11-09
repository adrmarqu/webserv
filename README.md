# Webserv - 42 Barcelona HTTP/1.1 Web Server

Webserv is an advanced systems and network programming project from the 42 Barcelona curriculum. The goal is to build a high-performance, fully non-blocking HTTP/1.1 web server in C++98 modeled after NGINX. The server implements an event-driven I/O multiplexing architecture using Linux epoll with cross-platform POSIX poll fallback for macOS. It handles concurrent client connections, parses RFC-compliant HTTP/1.1 requests, serves static content, generates dynamic directory listings (autoindex), processes file uploads with configurable client_max_body_size limits, executes dynamic scripts via Common Gateway Interface (CGI), and manages virtual hosts and routing rules defined in an NGINX-inspired configuration file.

# Prerequisites

To build and run Webserv, ensure you have:

- A C++ compiler supporting the C++98 standard: clang++ or g++
- GNU Make
- Python 3 (optional, for executing Python CGI scripts)
- Supported Operating System: macOS or Linux (Ubuntu, Debian, Fedora, Arch)

### Ubuntu / Debian Package Installation

```bash
sudo apt update
sudo apt install build-essential clang python3
```

### macOS Package Installation

```bash
xcode-select --install
```

# Configuration

1. Clone the repository:
```bash
git clone https://github.com/adrmarqu/webserv.git
cd webserv
```

2. Configuration File (files/default.conf):
Configuration files use an NGINX-inspired block syntax:

```nginx
server {
    listen 127.0.0.1:8080;
    server_name localhost;

    root html;
    index index.html index.htm;
    error_page 404 html/error/404.html;

    client_max_body_size 10M;

    location / {
        root html;
        index index.html;
        methods GET;
        autoindex on;
    }

    location /cgi-bin/ {
        root html/;
        cgi_extension .py;
        cgi_enable on;
        cgi_path /usr/bin/python3;
        methods GET POST;
    }

    location /media {
        root html;
        return 404 html/error/404.html;
    }
}
```

### Directives Reference

- listen [ip]:[port]: Defines the IP address and port to bind and listen on.
- server_name [names...]: Defines virtual host domain names for the server block.
- root [path]: Sets the base filesystem directory for resolving file requests.
- index [files...]: Sets default fallback files when a directory is requested.
- error_page [code] [path]: Configures custom HTML pages for specific HTTP status codes.
- client_max_body_size [size]: Restricts the maximum allowable client request body size (e.g. 10M).
- location [path] { ... }: Defines specific routing rules for matching URI prefixes:
  - methods [GET] [POST] [DELETE]: Whitelist of accepted HTTP methods for the route.
  - autoindex on | off: Enables or disables automated directory listing when no index file exists.
  - return [code] [url/path]: Configures an immediate HTTP redirect or response.
  - cgi_extension [ext]: Supported file extensions for CGI processing (e.g. .py).
  - cgi_path [path]: Absolute path to the CGI script interpreter (e.g. /usr/bin/python3).
  - cgi_enable on | off: Enables or disables CGI script execution for this route.

# Execution

### Compilation

Compile the executable using Make:
```bash
make
```

### Running the Server

Launch Webserv with the default configuration (files/default.conf):
```bash
./webserv
```

Or pass a custom configuration file as an argument:
```bash
./webserv files/default.conf
```

To stop the server cleanly, press Ctrl + C (triggers SIGINT handler and closes all listening and active sockets).

# Testing and Verification

Once the server is running on port 8080, perform verification tests:

### 1. Browser Navigation

Open your web browser and navigate to:
http://localhost:8080/

### 2. cURL Verification Commands

- Static GET Request:
  ```bash
  curl -i http://127.0.0.1:8080/
  ```

- Custom 404 Error Page:
  ```bash
  curl -i http://127.0.0.1:8080/nonexistent.html
  ```

- CGI Script Execution:
  ```bash
  curl -i http://127.0.0.1:8080/cgi-bin/hello.py
  ```

- POST Request with Form Data:
  ```bash
  curl -i -X POST -d "param1=value1&param2=value2" http://127.0.0.1:8080/
  ```

- DELETE Request:
  ```bash
  curl -i -X DELETE http://127.0.0.1:8080/files/test.txt
  ```

# Project Structure

```
webserv/
├── Makefile                 # C++98 build automation
├── files/                   # Server configuration files (.conf)
│   └── default.conf         # Standard multi-host server configuration
├── html/                    # Default web root directory
│   ├── index.html           # Landing page
│   ├── error/               # Custom HTTP error pages (400, 403, 404, 500)
│   └── cgi-bin/             # Dynamic CGI scripts (Python, etc.)
├── includes/                # Header files (.hpp)
│   ├── Server.hpp           # Core server cluster and event loop
│   ├── Socket.hpp           # Socket creation, non-blocking fcntl, and binding
│   ├── Epoll.hpp            # Linux epoll multiplexing wrapper
│   ├── Poll.hpp             # macOS POSIX poll multiplexing wrapper
│   ├── Config.hpp           # Configuration file parser and tokenizer
│   ├── Location.hpp         # Route-specific directive definitions
│   ├── HttpRequest.hpp      # HTTP/1.1 request parser and header extractor
│   ├── HttpResponse.hpp     # HTTP response generator and status codes
│   ├── CGI.hpp              # Common Gateway Interface process handler
│   └── Client.hpp           # Per-client state buffer and I/O tracking
└── sources/                 # C++ implementation files (.cpp)
```

# Commands and Makefile Targets

- make or make all: Compiles the source files with -Wall -Wextra -Werror -std=c++98 and produces the webserv binary
- make clean: Removes compiled object files (.o) and dependency files (.d)
- make fclean: Removes object files, dependencies, and the webserv binary
- make re: Completely rebuilds the server executable from scratch

# Technical Highlights

- Non-Blocking Architecture: Operates on a single-threaded event loop using non-blocking file descriptors (fcntl O_NONBLOCK) with epoll (Linux) or poll (macOS), ensuring uninterrupted service even with heavy concurrent traffic.
- Full HTTP/1.1 Compliance: Supports keep-alive connections, chunked transfer encoding, accurate status responses, and MIME type resolution.
- Dynamic CGI Execution: Executes CGI scripts in child processes via fork and execve, communicating over bidirectional pipes with timeout guards against infinite loops.

# Author Details

Author: Adrià Márquez Nebot
Github: https://github.com/adrmarqu
LinkedIn: https://www.linkedin.com/in/adria-marquez
Portfolio: https://adrmarqu.github.io
