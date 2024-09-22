#!/bin/bash

# Cài đặt MySQL và Nginx
sudo apt update
sudo apt install -y mysql-server nginx

# Khởi động lại các dịch vụ cần thiết
sudo systemctl restart php8.1-fpm
sudo systemctl restart mysql
sudo systemctl restart nginx

# Yêu cầu người dùng cung cấp đường dẫn tới thư mục VistaPanel
read -p "Nhập đường dẫn tới thư mục VistaPanel: " VISTAPANEL_PATH

# Tạo cơ sở dữ liệu MySQL
mysql -u root -p <<EOF
CREATE DATABASE vistapanel;
CREATE USER 'vistapaneluser'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON vistapanel.* TO 'vistapaneluser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Cấu hình tệp .env
cat <<EOT > $VISTAPANEL_PATH/.env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=vistapanel
DB_USERNAME=vistapaneluser
DB_PASSWORD=yourpassword
EOT

# Chạy các lệnh Artisan của Laravel
cd $VISTAPANEL_PATH
php artisan migrate
php artisan db:seed
php artisan key:generate

# Cấu hình Nginx
sudo cat <<EOT > /etc/nginx/sites-available/vistapanel
server {
    listen 80;
    server_name yourdomain.com;

    root $VISTAPANEL_PATH/public;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOT

# Kích hoạt cấu hình và khởi động lại Nginx
sudo ln -s /etc/nginx/sites-available/vistapanel /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo "Cài đặt và cấu hình VistaPanel hoàn tất!"
