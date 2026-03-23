#!/bin/bash
set -e

# ── Standarddateien in gemountete Volumes kopieren (nur wenn leer) ──

# config/: Vorlage bereitstellen
if [ ! -f /var/www/html/config/config.php.example ]; then
    cp -rn /defaults/config/* /var/www/html/config/ 2>/dev/null || true
fi

# rag/: Chunks und .htaccess bereitstellen
if [ ! -d /var/www/html/rag/chunks ] || [ -z "$(ls -A /var/www/html/rag/chunks/ 2>/dev/null)" ]; then
    cp -rn /defaults/rag/* /var/www/html/rag/ 2>/dev/null || true
fi

# .htaccess sicherstellen (wichtig für Zugriffsschutz)
[ -f /var/www/html/config/.htaccess ] || cp /defaults/config/.htaccess /var/www/html/config/.htaccess
[ -f /var/www/html/rag/.htaccess ]    || cp /defaults/rag/.htaccess /var/www/html/rag/.htaccess

# uploads-Ordner anlegen falls nötig
mkdir -p /var/www/html/rag/uploads

# Schreibrechte setzen
chown -R www-data:www-data /var/www/html/config /var/www/html/rag

# Apache starten
exec apache2-foreground
