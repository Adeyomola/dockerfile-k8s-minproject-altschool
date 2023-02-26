FROM nginx:stable

COPY default.conf /etc/nginx/conf.d/default.conf
COPY openssl.cnf /cert/openssl.cnf

ARG webroot=/usr/share/nginx/html/app
ARG repo_url=https://github.com/Adeyomola/adeyomola.github.io.git
ARG cert=/etc/ssl/certs/ca-certificates.crt
ARG vhost=/etc/nginx/sites-available/default

WORKDIR cert
RUN ["/bin/bash", "-c", "apt-get update && apt-get install git -y && git clone -b master $repo_url $webroot \
&& curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
&& apt-get install -y nodejs && npm config set cafile $cert"]

WORKDIR $webroot
RUN ["/bin/bash", "-c", "npm i && npm run build && chown -R www-data:www-data $webroot && chmod -R 755 $webroot \
&& service nginx restart"]
