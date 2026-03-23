FROM php:8.3-apache

# PHP-Erweiterungen installieren (curl + mbstring sind im Base-Image bereits enthalten)
RUN a2enmod rewrite headers

# Arbeitsverzeichnis
WORKDIR /var/www/html

# Projektdateien kopieren
COPY index.html proxy.php admin.php ./
COPY config/ config/
COPY rag/ rag/
COPY vendor/ vendor/

# Schreibrechte für config und rag (API-Key-Setup + Admin-Passwort + Uploads)
RUN chown -R www-data:www-data config/ rag/ \
    && chmod -R 755 config/ rag/

# Apache: .htaccess erlauben
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

EXPOSE 80
