# Setting up and running the Mini Program Ruby Proxy

This guide will explain how to set up, run and use the proxy. Any tools needed will be linked to and left as an exercise to the reader to install. The readme will also only focus on Ubuntu and other platforms will not be discussed.

## 1. Install Ruby and Bundler

1.1 See the [Installation Guide](https://www.ruby-lang.org/en/documentation/installation/) on the official ruby page.

1.2 Install the bundler gem by running `gem install bundler`

## 2. Setting up the server

### 2.1 Installing Dependencies
To install dependencies run the following command in the project root.
```bash
bundle install
```

### 2.2 Starting up the server
To start the server run the following command:
```bash
PROXY_HOST=https://hostname ./start.sh
```
The `PROXY_HOST` environment variable refers to the location where any requests will be proxied to. For example, if the server is started with `PROXY_HOST=https://www.google.com ./start.sh` all requests to the proxy will be forwarded to `https://www.google.com`. The server starts up on port `6000`.

## 3. Using the proxy
The proxy is intended to be used for proxy-ing some `GET` calls to `DELETE` calls and some `POST` calls to `PUT` calls since the mini program system does not currently support the `DELETE` and `PUT` HTTP verbs. All headers sent will also be forwarded. All headers returned by the `PROXY_HOST` will also be returned to the client.

### 3.1 Making a PUT call
Simply prepend the put parameter in the api query for a `POST` request. For example, say you want to do the call `PUT /profile/:id` you would call the proxy with `POST /put/profile/:id`. The proxy will then do a `PUT` call to the `PROXY_HOST` on your behalf. 

### 3.2 Making a DELETE call
Simply prepend the delete parameter in the api query for a `GET` request. For example, say you want to do the call `DELETE /posts/:id` you would call the proxy with `GET /delete/posts/:id`. The proxy will then do a `DELETE` call to the `PROXY_HOST` on your behalf. 

All calls not prepended by either of these verbs will be forwarded without as-is to the `PROXY_HOST`.


## 4. Building into Docker container
A Dockerfile has already been included. It can be built with `docker build -t tag:version .`.

Afterwords it can be run like this:
```bash
docker run -it -p 6000:6000 -e PROXY_HOST=https://hostname tag:version
```