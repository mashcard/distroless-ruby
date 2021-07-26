# "Distroless" Ruby Docker Images

This is Ruby 3 Distroless Image.

"Distroless" images contain only your application and its runtime dependencies. They do not contain package managers, shells or any other programs you would expect to find in a standard Linux distribution.

For more information, see [GoogleContainerTools/distroless](https://github.com/GoogleContainerTools/distroless)

## Pre-installed Libs

- jemalloc
- libpq
- libxml
- libxslt
- libffi

## Usage

```Dockerfile
FROM ruby:3-buster  as builder
WORKDIR /app
ADD . /app
RUn bundle install

# copy it into wrapdrive container
FROM ghcr.io/brickdoc/distroless-ruby:latest
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/ /app/
CMD ["/app/bin/rails s"]
```

## License

Copyight (c) 2021 Brickdoc (Ningbo) Cloud Computing Technology LTD

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
