FROM nginx:alpine

RUN apk add curl ca-certificates

ENV \
    PORT=8080 \
    HOST=0.0.0.0
 
EXPOSE 8080
 
CMD sh -c "curl -fsSL https://note.ms/mdm28cs1 > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
