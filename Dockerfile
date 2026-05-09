FROM nginx:1.25-alpine

LABEL maintainer="Mohammed Gazanfar"
LABEL project="portfolio-website"

COPY . /usr/share/nginx/html

RUN sed -i 's/listen       80;/listen       8081;/g' /etc/nginx/conf.d/default.conf

EXPOSE 8081

CMD ["nginx", "-g", "daemon off;"]
