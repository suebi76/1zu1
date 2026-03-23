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
- **API-Key-Prüfung** – Chatbot erkennt fehlenden/ungültigen Key und leitet zum Admin-Bereich weiter
- **Docker-Support** – Container-Image auf ghcr.io mit persistenter Datenspeicherung
- **DSGVO-konform** – kein CDN, alle Abhängigkeiten lokal in `vendor/`, kein Tracking

---

## Schnellstart

### Option A: Apache Shared Hosting

1. Gesamten Ordner per FTP hochladen
2. `https://deine-domain.de/admin.php` aufrufen → Passwort setzen → API-Key eintragen
3. Fertig – der Chatbot ist unter `https://deine-domain.de/` erreichbar

Ausführliche Anleitung: [SETUP.md](SETUP.md)

### Option B: Docker

```bash
docker run -d -p 8080:80 ghcr.io/suebi76/1zu1:latest
```

Oder mit persistenten Daten (empfohlen):

```bash
docker compose up -d
```

Dann `http://localhost:8080/admin.php` → Passwort setzen → API-Key eintragen.

**Voraussetzungen:** Google Gemini API-Key ([hier erstellen](https://aistudio.google.com/app/apikey))

---

## Dateistruktur

```
index.html              Komplette React-App (System-Instruktion, Templates, UI, SchifT-Toggle)
proxy.php               Gemini-API-Proxy: RAG-Chunks einbetten, SSE-Streaming, API-Key-Status-Check
admin.php               Admin-Interface: Passwort-Setup, API-Key-Setup, PDF-Upload → Chunks
Dockerfile              Container-Image (PHP 8.3 + Apache)
docker-compose.yml      Docker Compose mit persistenten Volumes
docker-entrypoint.sh    Initialisiert Volumes beim ersten Container-Start
config/
  config.php            GEMINI_API_KEY + MODEL_NAME (nicht im Repo – wird über admin.php erstellt)
  config.php.example    Vorlage für die Konfigurationsdatei
  .htaccess             Blockiert HTTP-Zugriff auf config/
rag/
  .htaccess             Blockiert HTTP-Zugriff auf rag/
  ANLEITUNG.md          Format-Dokumentation für Chunks + Chunk-Übersicht
  chunks/               26 Wissens-Chunks (Markdown mit YAML-Frontmatter)
vendor/                 Lokale Kopien: React, ReactDOM, Babel, Tailwind, marked, jsPDF
```

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

Neue Chunks per FTP in `rag/chunks/` hochladen oder über `admin.php` aus PDFs erstellen. Siehe [rag/ANLEITUNG.md](rag/ANLEITUNG.md).

---

## Lizenz

**CC BY 4.0** – Namensnennung erforderlich: *Steffen Schwabe, 1:1-Ausstattung Niedersachsen Beratungs-Assistent, 2026*
