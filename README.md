# 1:1-Ausstattung Niedersachsen – Beratungs-Assistent

> **KI-Chatbot für medienpädagogische Beraterinnen und Berater (MPB)**
> zur Unterstützung bei der Beratung von Lehrkräften und Schulleitungen
> im Rahmen des 1:1-Ausstattungsprogramms Niedersachsen.

Entwickelt von **Steffen Schwabe** · Lizenz: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
Basiert auf [KI-Chatbot-with-RAG](https://github.com/suebi76/KI-Chatbot-with-RAG)

---

## Überblick

Eine vollständige Chat-Anwendung mit:

- **Retrieval-Augmented Generation (RAG)** – 26 Wissens-Chunks aus offiziellen Dokumenten des Bildungsportals Niedersachsen
- **Google Gemini API** als KI-Backend (serverseitig über PHP-Proxy, kein API-Key im Browser)
- **9 Themenbereiche**: Geräteausgabe, Leihverträge, Schadensprozesse, Formulare, SchifT, Gerätetypen, Software, Rücknahme, Datenschutz
- **SchifT-Toggle** – Umschaltung zwischen öffentlicher Schule und Schule in freier Trägerschaft
- **6 Vorlagen-Kategorien** mit vordefinierten Beratungsfragen
- **Streaming-Antworten** per Server-Sent Events (SSE)
- **PDF-Export** der KI-Antworten
- **DSGVO-konform** – kein CDN, alle Abhängigkeiten lokal in `vendor/`, kein Tracking

---

## Dateistruktur

```
index.html          Komplette React-App (System-Instruktion, Templates, UI, SchifT-Toggle)
proxy.php           Gemini-API-Proxy: empfängt POST, injiziert RAG-Chunks, streamt SSE
admin.php           Admin-Interface: Passwort-Setup, PDF-Upload → Gemini → Chunks
config/
  config.php        GEMINI_API_KEY + MODEL_NAME  (nicht im Repo – siehe config.php.example)
  config.php.example  Vorlage für die Konfigurationsdatei
  .htaccess         Blockiert HTTP-Zugriff auf config/
rag/
  .htaccess         Blockiert HTTP-Zugriff auf rag/
  ANLEITUNG.md      Format-Dokumentation für Chunks + Chunk-Übersicht
  chunks/           26 Wissens-Chunks (Markdown mit YAML-Frontmatter)
vendor/             Lokale Kopien: React, ReactDOM, Babel, Tailwind, marked, jsPDF
```

---

## Setup

### 1. Konfiguration anlegen

```bash
cp config/config.php.example config/config.php
```

`config/config.php` öffnen und den echten Gemini API-Key eintragen:

```php
define('GEMINI_API_KEY', 'DEIN_KEY_AUS_GOOGLE_AI_STUDIO');
define('MODEL_NAME',     'gemini-2.5-flash');
```

API-Key erstellen: [Google AI Studio](https://aistudio.google.com/app/apikey)

### 2. Deployment (Apache Shared Hosting)

Gesamten Ordner per FTP hochladen. Wichtig: `.htaccess`-Dateien in `config/` und `rag/` müssen vorhanden sein – ohne sie ist der API-Key über HTTP abrufbar.

### 3. Admin-Interface einrichten

`https://deine-domain.de/admin.php` aufrufen → beim ersten Aufruf Passwort setzen.

---

## Wissensdatenbank (26 Chunks)

| Quelle | Chunks | Dateinamen |
|--------|--------|------------|
| Checkliste Ausgabe/Verwaltung | 4 | `ausgabe-01-vorbereitung.md` bis `ausgabe-04-ruecknahme.md` |
| Checkliste Funktionsprüfung | 1 | `lieferung-funktionspruefung.md` |
| Checkliste Schaden/Verlust | 5 | `schaden-01-meldung.md` bis `schaden-05-schadensersatz.md` |
| Empfangsbestätigung | 1 | `formular-empfangsbestaetigung.md` |
| Schadensmeldung Formular | 1 | `formular-schadensmeldung.md` |
| Leihvertrag Lehrkräfte | 3 | `leihvertrag-lehrkraefte-01.md` bis `-03.md` |
| Leihvertrag SuS | 3 | `leihvertrag-sus-01.md` bis `-03.md` |
| SchifT-Dokumente | 3 | `schift-leihvertrag.md`, `schift-schaden.md`, `schift-formular.md` |
| Dialog Digitalität (FAQ) | 3 | `faq-geraetetypen.md`, `faq-software.md`, `faq-programm.md` |
| Programmüberblick | 1 | `programm-ueberblick.md` |
| Serienbrieffunktion | 1 | `serienbrieffunktion.md` |

Neue Chunks per FTP in `rag/chunks/` hochladen oder über `admin.php` aus PDFs erstellen. Siehe `rag/ANLEITUNG.md`.

---

## Lizenz

**CC BY 4.0** – Namensnennung erforderlich: *Steffen Schwabe, 1:1-Ausstattung Niedersachsen Beratungs-Assistent, 2026*
