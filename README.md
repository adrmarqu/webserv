# Webserv

A high-performance, non-blocking HTTP/1.1 web server implemented in C++98.

---

## Features

- Non-blocking I/O multiplexing (native Linux `epoll` and cross-platform POSIX `poll` fallback for macOS).
- Full HTTP/1.1 request parsing and response generation.
- HTTP methods supported: `GET`, `POST`, and `DELETE`.
- Static file serving (HTML, CSS, images, text).
- Directory listing (`autoindex`).
- Custom HTTP error pages (e.g. 400, 403, 404, 405, 500).
- HTTP Redirections (e.g. 301 Moved Permanently).
- File upload handling with configurable `client_max_body_size`.
- Common Gateway Interface (CGI) execution for dynamic scripts (Python, etc.).
- Multi-server support: listen on multiple ports and hostnames from a single configuration file.

---

## Prerequisites

To build and run this project, ensure you have the following installed:

- **Operating System:** macOS or Linux (Ubuntu, Debian, Fedora, Arch, etc.)
- **C++ Compiler:** `clang++` or `g++` supporting `-std=c++98`
- **Build Tool:** GNU `make`
- **CGI Runtime (Optional):** `python3` (for running Python CGI scripts)

### Installation on Ubuntu / Debian:

```bash
sudo apt update
sudo apt install build-essential clang python3
```

### Installation on macOS:

```bash
xcode-select --install
```

---

## Compilation

Build the project using the Makefile:

```bash
make
```

Available Makefile targets:

- `make`: Compiles the server binary (`webserv`).
- `make clean`: Removes all compiled object (`.o`) and dependency (`.d`) files.
- `make fclean`: Removes object files, dependencies, and the `webserv` binary.
- `make re`: Performs a complete rebuild (`fclean` + `all`).

---

## Usage

Run the executable with a configuration file:

```bash
./webserv [path_to_config.conf]
```

If no configuration file is provided, `webserv` automatically loads `files/default.conf`:

```bash
./webserv
```

To stop the server safely, press `Ctrl + C` (sends `SIGINT`).

---

## Configuration File Guide

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

- `listen [ip]:[port]`: Defines the IP address and port to bind and listen on.
- `server_name [names...]`: Defines virtual host domain names for this server block.
- `root [path]`: Sets the base directory for resolving file requests.
- `index [files...]`: Sets default index files to serve when a directory is requested.
- `error_page [code] [path]`: Configures custom HTML pages for specific HTTP status codes.
- `client_max_body_size [size]`: Limits the maximum acceptable client request body size (e.g. `10M`, `100M`).
- `location [path] { ... }`: Configures routing rules for specific URI prefixes:
  - `methods [GET] [POST] [DELETE]`: Whitelist of accepted HTTP methods for the route.
  - `autoindex on | off`: Enables or disables directory listings when no index file is found.
  - `return [code] [url/path]`: Configures an immediate HTTP redirect or response.
  - `cgi_extension [ext]`: Supported file extensions for CGI processing (e.g. `.py`).
  - `cgi_path [path]`: Absolute path to the CGI script interpreter (e.g. `/usr/bin/python3`).
  - `cgi_enable on | off`: Enables or disables CGI execution for this route.

---

## Testing

Once the server is running on port 8080:

### 1. Web Browser
Navigate to:
```
http://localhost:8080/
```

### 2. cURL Commands

- **Static GET Request:**
  ```bash
  curl -i http://127.0.0.1:8080/
  ```

- **404 Error Page:**
  ```bash
  curl -i http://127.0.0.1:8080/nonexistent.html
  ```

- **CGI Script Execution:**
  ```bash
  curl -i http://127.0.0.1:8080/cgi-bin/hello.py
  ```

- **POST Request:**
  ```bash
  curl -i -X POST -d "param1=value1&param2=value2" http://127.0.0.1:8080/
  ```

- **DELETE Request:**
  ```bash
  curl -i -X DELETE http://127.0.0.1:8080/delete-me/target.txt
  ```
