FROM ruby:latest as builder
WORKDIR /usr/src/app
COPY ./ /usr/src/app
ARG BUILD_NUMBER
RUN apt-get update && apt-get install -y nodejs
CMD bundle install && bundle exec middleman build --clean

FROM nginx:stable-alpine
MAINTAINER FoxDen Team <george.nixon@readytalk.com>

COPY --from=builder /usr/src/app/build /etc/nginx/html/
COPY docker/conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN ls /etc/nginx/html

HEALTHCHECK --interval=10s \
  CMD wget -s http://localhost/index.html || exit 1

EXPOSE 4567
