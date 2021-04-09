#! /bin/bash
# Install apache
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>This is the day the Lord has made</h1>" >> /var/www/html/index.html