# Step 1: 基於官方 WordPress 映像檔，選擇適合的 PHP 和 Apache 版本
FROM wordpress:php8.2-apache

# Step 2: 更新並安裝必需的 PHP 擴展
# 為了能夠和 Planetscale 進行資料庫連線，我們需要安裝 mysqli 或其他相關擴展
RUN docker-php-ext-install mysqli \
    && apt-get update \
    && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Step 3: 設定 WordPress 目錄的擁有權
# Apache 會在 /var/www/html 中啟動，所以我們需要設定目錄的擁有權
RUN chown -R www-data:www-data /var/www/html

# Step 4: 開放端口 8080，Cloud Run 會使用此端口
EXPOSE 8080

# Step 5: 設定環境變數（這些環境變數會在 Cloud Run 部署時設置）
# 設定 DB 連接資訊（這些可以在 Cloud Run 配置時傳遞）
ENV WORDPRESS_DB_HOST=${DB_HOST}
ENV WORDPRESS_DB_NAME=${DB_NAME}
ENV WORDPRESS_DB_USER=${DB_USER}
ENV WORDPRESS_DB_PASSWORD=${DB_PASS}

# Step 6: 進入 WordPress 頁面時，Apache 將啟動並運行
CMD ["apache2-foreground"]