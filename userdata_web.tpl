#!/bin/bash

# Update package list and install Nginx
sudo yum update
sudo yum install -y nginx

# Define the HTML content
HTML_CONTENT='<!DOCTYPE html>
<html>
<head>
<title>Welcome to Falcon IT Training!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to Falcon IT Training!</h1>
<p>Congratulations! You have successfully created an EC2 instance with nginx installed. </p>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>
<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>
You can contact us at
<a href="mailto:support@falconit.com">support@falconit.com</a>.
<p><em>Thank you!</em></p>
</body>
</html>'

# Create the HTML file
echo "$HTML_CONTENT" | sudo tee /usr/share/nginx/html/index.html > /dev/null

# Ensure correct permissions
sudo chmod 644 /usr/share/nginx/html/index.html

# Restart Nginx to apply changes
sudo systemctl restart nginx
