# /etc/nginx/sites-available/exampledomain.com

server {
        listen 80;
        listen [::]:80;

        root /var/www/exampledomain/html;
        index index.html index.htm index.nginx-debian.html;

        server_name exampledomain.com www.exampledomain.com;

        location / {
                try_files $uri $uri/ =404;
        }
        return 301 https://$server_name$request_uri;

}
