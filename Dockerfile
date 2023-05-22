# Use nginx:alpine as the base image
FROM nginx:alpine

# Write the nginx config file to the container
RUN echo '# Listen on port 8080 with http protocol
server {
  listen 8080;

  # Check if the request matches the magic word
  location ~ ^/captcha/(.*)$ {

    # Extract the target URL from the request
    set $target_url $1;

    # Check if the target URL is valid (has a protocol)
    if ($target_url !~ ^(http|https|ws|wss)://) {
      return 400 "Invalid target URL";
    }

    # Proxy the request to the target URL
    proxy_pass $target_url;

    # Set the headers for websocket upgrade
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }

  # Redirect all other requests to https://captive.apple.com
  location / {
    return 301 https://captive.apple.com;
  }
}' > /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
