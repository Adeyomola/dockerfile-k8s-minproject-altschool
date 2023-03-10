FROM nginx:stable

EXPOSE 80

COPY default.conf /etc/nginx/conf.d/default.conf

ARG webroot=/usr/share/nginx/html/app
ARG repo_url=https://github.com/Adeyomola/adeyomola.github.io
ARG cert=/etc/ssl/certs/ca-certificates.crt
ARG vhost=/etc/nginx/sites-available/default

WORKDIR cert
RUN ["/bin/bash", "-c", "apt-get update && apt-get install git -y && git clone -b master $repo_url $webroot \
&& curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
&& apt-get install -y nodejs && npm config set cafile $cert \
&& npm install -g serve"]

WORKDIR $webroot
RUN ["/bin/bash", "-c", "npm i && npm run build && chown -R www-data:www-data $webroot && chmod -R 755 $webroot \
&& service nginx restart"]

ENTRYPOINT serve -s build -l 80
