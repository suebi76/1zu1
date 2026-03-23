FROM php:8.3-apache

# Apache-Module aktivieren
RUN a2enmod rewrite headers

# Apache: .htaccess erlauben
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Arbeitsverzeichnis
WORKDIR /var/www/html

# Projektdateien kopieren
COPY index.html proxy.php admin.php ./
COPY config/ config/
COPY rag/ rag/
COPY vendor/ vendor/

# Standarddateien sichern (werden bei leeren Volumes als Vorlage genutzt)
RUN mkdir -p /defaults \
    && cp -r config/ /defaults/config \
    && cp -r rag/ /defaults/rag

# uploads-Ordner anlegen
RUN mkdir -p rag/uploads

# Schreibrechte für config und rag (API-Key, Passwort, Chunks, Uploads)
RUN chown -R www-data:www-data config/ rag/ \
    && chmod -R 755 config/ rag/

# Entrypoint: kopiert Defaults in leere Volumes beim Start
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Persistente Daten als Volumes deklarieren
VOLUME ["/var/www/html/config", "/var/www/html/rag"]

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
