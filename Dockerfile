# Use nginx:alpine as the base image
FROM nginx:alpine

# Write the nginx config file to the container
RUN echo '# Listen on port 8080 with http protocol\n\
server {\n\
  listen 8080;\n\
\n\
  # Check if the request matches the magic word\n\
  location ~ ^/captcha/(.*)$ {\n\
\n\
    # Extract the target URL from the request\n\
    set $target_url $1;\n\
\n\
    # Check if the target URL is valid (has a protocol)\n\
    if ($target_url !~ ^(http|https|ws|wss)://) {\n\
      return 400 "Invalid target URL";\n\
    }\n\
\n\
    # Proxy the request to the target URL\n\
    proxy_pass $target_url;\n\
\n\
    # Set the headers for websocket upgrade\n\
    proxy_http_version 1.1;\n\
    proxy_set_header Upgrade $http_upgrade;\n\
    proxy_set_header Connection "upgrade";\n\
  }\n\
\n\
  # Redirect all other requests to https://captive.apple.com\n\
  location / {\n\
    return 301 https://captive.apple.com;\n\
  }\n\
}' > /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
