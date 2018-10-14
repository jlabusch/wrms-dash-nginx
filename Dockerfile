FROM nginx:latest

RUN mkdir -p /usr/share/nginx/html/static

COPY ./static/staticserve/ /usr/share/nginx/html/static/

COPY ./nginx-default.conf /etc/nginx/conf.d/default.conf


