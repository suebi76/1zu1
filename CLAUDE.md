# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Projekt

**1:1-Ausstattung Niedersachsen – Beratungs-Assistent** — Spezialisierter KI-Chatbot für
medienpädagogische Beraterinnen und Berater (MPB) zur Unterstützung bei der Beratung
von Lehrkräften und Schulleitungen im Rahmen des 1:1-Ausstattungsprogramms Niedersachsen.
Lizenz: CC BY 4.0. Deployment-Ziel: Apache Shared Hosting (PHP, kein Node/Python).

Basiert auf dem [KI-Chatbot-with-RAG](https://github.com/suebi76/KI-Chatbot-with-RAG) Framework.

---

## Kein Build-Schritt

`index.html` ist eine einzelne HTML-Datei mit eingebettetem `<script type="text/babel">`.
Babel kompiliert JSX zur Laufzeit im Browser. Alle Abhängigkeiten liegen lokal in `vendor/` —
kein CDN, kein npm, keine Kompilierung nötig. Änderungen an `index.html` sind sofort aktiv.

---

## Dateistruktur

```
index.html          Komplette React-App (Babel, Tailwind, marked, jsPDF — alles inline)
proxy.php           Gemini-API-Proxy: empfängt POST, injiziert RAG-Chunks, streamt SSE zurück
admin.php           Admin-Interface: Passwort-Setup, PDF-Upload → Gemini → Chunks
config/
  config.php        GEMINI_API_KEY + MODEL_NAME (via .htaccess gegen HTTP gesperrt)
  .htaccess         Blockiert HTTP-Zugriff auf config/
rag/
  .htaccess         Blockiert HTTP-Zugriff auf rag/
  .admin_password   bcrypt-Hash des Admin-Passworts (wird bei erstem admin.php-Aufruf erstellt)
  ANLEITUNG.md      Format-Dokumentation für manuelle Chunks
  chunks/*.md       Wissensdatenbank – 26 Chunks zum 1:1-Ausstattungsprogramm
vendor/             Lokale Kopien: react, react-dom, babel, tailwind, marked, jspdf
```

---

## Request-Flow

```
Browser  →  POST proxy.php
               ↓ letzte Nutzernachricht extrahieren
               ↓ Schlüsselwörter aus rag/chunks/*.md scoren (Frontmatter 3×, Body 1×)
               ↓ Top-4-Chunks an System-Instruktion anhängen
               ↓ POST → Gemini API (streamGenerateContent?alt=sse)
               ↓ SSE-Stream weiterleiten
Browser  ←  Streaming-Antwort
```

---

## index.html – Aufbau der Haupt-App

Alle App-Logik in einem einzigen `<script type="text/babel">`-Block:

| Abschnitt | Inhalt |
|---|---|
| CSS `<style>` | `.md`-Markdown-Stile, `.streaming-cursor`-Animation, Tabellen-Stile |
| `Icon` | Inline-SVG-Komponente (Map von Name → SVG) |
| `App` states | `messages`, `inputText`, `isLoading`, `isStreaming`, `copiedIdx`, `showPrivacy`, `showDSB`, `isSchifT`, `currentView`, `error` |
| `systemInstruction` | Gemini-System-Prompt: 9 Themenbereiche, SchifT-Kontext, PII-Ablehnung, Rollenschutz, Quellenangaben |
| `fetchAIResponse` | SSE-Parser mit SchifT-Prefix an Nachricht |
| `templates` | 6 Kategorien mit je 4-6 Optionen, jede mit eigenem `prompt` (kein [THEMA]/[ANZAHL]) |
| `downloadAsPdf` | Direktes jsPDF-Text-API, Dateiname: `1zu1-ausstattung-antwort.pdf` |
| `applyTemplate` | Setzt Prompt in inputText, wechselt zu Chat-Ansicht |
| `quickQuestions` | 6 Fragen (öffentlich) + 6 Fragen (SchifT), abhängig von `isSchifT` |
| `PrivacyModal` | Datenschutzhinweis (Beratungsunterstützung MPB) |
| `DSBModal` | Technische Datenschutzdokumentation für DSB |
| JSX return | Header mit SchifT-Toggle, Chat-/Vorlagen-Ansicht, Footer |

---

## RAG – Chunk-Format

Jede `.md`-Datei in `rag/chunks/` muss mit diesem Frontmatter beginnen:

```markdown
---
title: Aussagekräftiger Titel
tags: tag1, tag2, tag3, ..., tag14
quelle: Dokumenttitel, Version, Bildungsportal Niedersachsen
---

Inhalt (200-600 Wörter, Markdown mit ## Überschriften und - Listen).
```

- **Tags sind entscheidend** für die Suche — sie werden 3x stärker gewichtet
- Mindestens 8-14 Tags pro Chunk, inkl. Synonyme und Fachbegriffe
- Neue Chunks per FTP in `rag/chunks/` hochladen → sofort aktiv

---

## Wichtige Konventionen

- **Sprache**: Alles auf Deutsch — UI, Kommentare, System-Instruktion, Chunk-Inhalte
- **DSGVO**: Keine externen Browser-Requests — kein CDN, kein Google Fonts
- **System-Instruktion**: 9 Themenbereiche, PII-Ablehnung, Rollenschutz, Quellenangaben, SchifT-Unterscheidung
- **SchifT-Toggle**: React-State `isSchifT`, ändert Quick-Start-Fragen und System-Prompt-Kontext
- **PDF-Export**: Dateiname `1zu1-ausstattung-antwort.pdf`, direktes jsPDF-Text-API
- **JSX-Rückgabe**: Immer in `<React.Fragment>` wrappen
- **Streaming**: `autoScroll` ist ein `useRef(true)`, kein State

---

## Dateien die NICHT geändert werden

- `proxy.php` — unverändert vom Basis-Repository
- `vendor/*` — alle 6 JS-Dateien unverändert
- `.htaccess`-Dateien — unverändert

## admin.php – Anpassungen gegenüber Basis-Repository

- Gemini-Prompt angepasst: Domäne 1:1-Ausstattung statt Didaktik
- **5-Seiten-Regel**: Jeder Chunk deckt maximal 5 Seiten des Quell-PDFs ab
- Tag-Anforderung erhöht: mindestens 8-14 Tags mit Synonymen und Fachbegriffen
- Quelle-Format: „Dokumenttitel, Version, Bildungsportal Niedersachsen"
- maxOutputTokens auf 16384 erhöht (für längere PDFs)
- UI-Texte: „KI-Didaktik Chat" → „1:1-Ausstattung"
