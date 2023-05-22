FROM nginx:alpine

ARG VAR
ENV VAR=${VAR}

RUN apk add curl ca-certificates

ENV \
    PORT=8080 \
    HOST=0.0.0.0
 
EXPOSE 8080
 
CMD sh -c "eval curl -fsSL ${VAR} > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
