# Setup-Anleitung – 1:1-Ausstattung Beratungs-Assistent

## Voraussetzungen

- **Option A (Shared Hosting):** Apache-Webserver mit PHP 8.0+, `mod_rewrite`, `curl`, `fileinfo`, `mbstring`
- **Option B (Docker):** Docker Engine oder Docker Desktop
- HTTPS empfohlen (für sichere Übertragung des API-Keys)
- Ein Google-Gemini-API-Key ([hier erstellen](https://aistudio.google.com/app/apikey))

---

## Installation mit Docker (Alternative)

Falls Docker bevorzugt wird, kann der Chatbot auch als Container gestartet werden:

```bash
docker compose up -d
```

Oder ohne docker-compose:

```bash
docker run -d -p 8080:80 ghcr.io/suebi76/1zu1:latest
```

Dann `http://localhost:8080/admin.php` aufrufen → Passwort setzen → API-Key eintragen → fertig.

Die Daten (API-Key, Passwort, Chunks) werden in Docker-Volumes persistent gespeichert und überleben Container-Updates.

---

## Installation auf Apache (Shared Hosting)

### Schritt 1: Dateien hochladen

Den gesamten Ordner `KI Chatbot-1zu1/` per FTP auf den Webserver laden.

Die Ordnerstruktur auf dem Server sollte so aussehen:

```
/                       (DocumentRoot)
  index.html            Chatbot-App
  proxy.php             Gemini-API-Proxy
  admin.php             Admin-Interface
  config/
    config.php.example  Vorlage (config.php wird automatisch erstellt)
    .htaccess           Blockiert HTTP-Zugriff auf config/
  rag/
    .htaccess           Blockiert HTTP-Zugriff auf rag/
    ANLEITUNG.md        Dokumentation zum Chunk-Format
    chunks/             26 Wissens-Chunks (Markdown)
  vendor/               React, Babel, Tailwind, marked, jsPDF (lokal)
```

**Wichtig:** Die `.htaccess`-Dateien in `config/` und `rag/` müssen mit hochgeladen werden. Ohne sie wäre der API-Key über den Browser abrufbar.

---

## Schritt 2: Admin-Passwort festlegen

1. Im Browser öffnen: `https://deine-domain.de/admin.php`
2. Beim ersten Aufruf erscheint das Formular **„Admin einrichten"**
3. Passwort wählen (mindestens 6 Zeichen) und bestätigen
4. Das Passwort wird als bcrypt-Hash in `rag/.admin_password` gespeichert

---

## Schritt 3: API-Key eintragen

1. Mit dem soeben gesetzten Passwort einloggen
2. Die gelbe Karte **„Gemini API-Key einrichten"** erscheint
3. Den API-Key aus [Google AI Studio](https://aistudio.google.com/app/apikey) einfügen
4. Auf **„API-Key speichern"** klicken

Der Key wird serverseitig in `config/config.php` gespeichert. Diese Datei ist per `.htaccess` gegen HTTP-Zugriff geschützt und nur über PHP erreichbar.

> **Hinweis:** Solange kein gültiger API-Key eingetragen ist, ist der PDF-Upload deaktiviert. Der Chatbot erkennt den fehlenden Key automatisch und leitet zum Admin-Bereich weiter.

---

## Schritt 4: Chatbot testen

1. Im Browser öffnen: `https://deine-domain.de/`
2. Eine Testfrage stellen, z.B.: *„Wie läuft der 5-Phasen-Prozess bei Geräteschäden ab?"*
3. Die Antwort sollte per Streaming erscheinen und Quellenangaben enthalten

### Testfragen zur Verifikation

| Frage | Erwartet |
|-------|----------|
| „Wie gehe ich bei Geräteschäden vor?" | 5-Phasen-Prozess mit Quellenangabe |
| „Was steht im Leihvertrag zur Leihdauer?" | Vertragsparagraphen |
| „Unterschiede bei Schulen in freier Trägerschaft?" | SchifT-spezifische Infos |
| „Wie kann ich Pizza bestellen?" | Höfliche Ablehnung (themenfremd) |
| „Schüler Max aus 7b hat SN ABC123 verloren" | PII-Warnung (keine Namen verarbeiten) |

---

## Neue Wissens-Chunks hinzufügen

### Option A: Über das Admin-Interface

1. `admin.php` öffnen und einloggen
2. PDF-Datei hochladen (max. 15 MB)
3. Gemini analysiert die PDF und erstellt automatisch Chunks
4. Jeder Chunk deckt maximal 5 Seiten des Quell-PDFs ab
5. Die neuen Chunks erscheinen sofort in der Wissensdatenbank

### Option B: Manuell per FTP

1. Eine neue `.md`-Datei erstellen mit folgendem Format:

```markdown
---
title: Aussagekräftiger Titel
tags: tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8
quelle: Dokumenttitel, Version, Bildungsportal Niedersachsen
---

Inhalt hier (200-600 Wörter, Markdown mit ## Überschriften und - Listen).
```

2. Datei per FTP nach `rag/chunks/` hochladen
3. Sofort aktiv – kein Neustart nötig

Weitere Details: siehe `rag/ANLEITUNG.md`

---

## Passwort oder API-Key ändern

- **Passwort ändern:** In `admin.php` einloggen → unten „Passwort ändern" aufklappen
- **API-Key ändern:** Datei `config/config.php` per FTP bearbeiten oder löschen → beim nächsten Login in `admin.php` erscheint die Eingabe erneut

---

## Fehlersuche

| Problem | Lösung |
|---------|---------|
| Chatbot leitet zu admin.php weiter | API-Key fehlt oder ist ungültig – in `admin.php` eintragen |
| Chatbot antwortet nicht | API-Key in `admin.php` prüfen |
| „Konfigurationsdatei nicht gefunden" | `config/` Ordner mit `.htaccess` vorhanden? |
| PDF-Upload schlägt fehl | PHP `curl`-Erweiterung aktiv? `php -m \| grep curl` |
| Chunks werden nicht gefunden | `.md`-Dateien müssen YAML-Frontmatter mit `---` haben |
| API-Key im Browser sichtbar | `.htaccess` in `config/` fehlt oder `mod_rewrite` nicht aktiv |
