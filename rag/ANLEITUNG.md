# RAG-Wissensdatenbank – Anleitung

## So funktioniert das System

Jede `.md`-Datei im Ordner `chunks/` ist ein **Wissens-Chunk**.
Wenn eine Beratungsfrage gestellt wird, sucht der Server automatisch nach den
passendsten Chunks und gibt sie der KI als Quellmaterial mit.
Die KI antwortet dann auf Basis dieser Quellen statt nur aus ihrem allgemeinen Wissen.

---

## Neue Chunks hinzufügen

1. Erstelle eine neue `.md`-Datei in `chunks/` (z. B. `mein-thema.md`)
2. Verwende exakt dieses Format:

```
---
title: Sprechender Titel des Chunks
tags: schlüsselwort1, schlüsselwort2, schlüsselwort3, fachbegriff
quelle: Dokumenttitel, Version, Bildungsportal Niedersachsen
---

Hier kommt dein Inhalt. Schreib den Text so, wie er im Original steht
oder fasse ihn sinnvoll zusammen. Fachbegriffe aus dem `tags:`-Feld
werden für die Suche besonders stark gewichtet.

Empfohlene Länge: 200-600 Wörter pro Chunk.
Ein Chunk sollte genau ein Thema / ein Konzept behandeln.
```

---

## Tipps für gute Chunks

- **Ein Chunk = ein Konzept.** Nicht zu viel in eine Datei packen.
  Lieber `leihvertrag-sus-01.md`, `leihvertrag-sus-02.md` als eine riesige Datei.

- **Tags sind entscheidend für die Suche.** Trage alle Begriffe ein,
  nach denen MPB fragen könnten. Mindestens 8-14 Tags pro Chunk.
  Beispiel: `tags: schaden, verlust, diebstahl, 5-phasen, RLSB, IT.N, gerätepool, schadensersatz`

- **Synonyme in Tags aufnehmen**: Schüler/SuS, Schaden/Beschädigung,
  Lehrkräfte/Lehrer, Mobilgeräteverwaltung/MDM

- **Fachbegriffe verwenden**: IT.N, RLSB, MDM, SchifT, Gerätepool, DEP-Nummer

- **Quellen immer angeben** – die KI nennt sie dann in der Antwort.

- **Sprache**: Deutsch. Fachbegriffe so schreiben wie MPB sie eingeben.

---

## Dateien hochladen

Einfach per FTP in den Ordner `rag/chunks/` hochladen – fertig.
Kein Neustart, kein Build-Schritt nötig. Der Server liest die Dateien
bei jeder Anfrage neu ein.

---

## Welche Inhalte eignen sich?

- Checklisten des Bildungsportals Niedersachsen (Ausgabe, Funktionsprüfung, Schaden)
- Leihverträge (SuS, Lehrkräfte, SchifT)
- Formulare (Empfangsbestätigung, Schadensmeldung)
- FAQ-Inhalte aus den Handreichungen Digitalität Band 1 und 2
- Eigene Zusammenfassungen und Erklärungen zu Prozessen

---

## Maximale Chunk-Grösse

Technisch unbegrenzt, aber: Je grösser ein Chunk, desto unschärfer wird
die Suche. **Ideal: 300-500 Wörter.** Lange Texte besser auf mehrere
Chunks aufteilen.

---

## Aktuelle Chunks (26 Stück)

| Dateiname | Inhalt |
|-----------|--------|
| `ausgabe-01-vorbereitung.md` – `ausgabe-04-ruecknahme.md` | Checkliste Ausgabe & Verwaltung (4 Chunks) |
| `lieferung-funktionspruefung.md` | Checkliste Funktionsprüfung (1 Chunk) |
| `schaden-01-meldung.md` – `schaden-05-schadensersatz.md` | 5-Phasen-Schadensprozess (5 Chunks) |
| `formular-empfangsbestaetigung.md` | Empfangsbestätigung (1 Chunk) |
| `formular-schadensmeldung.md` | Schadensmeldungsformular (1 Chunk) |
| `leihvertrag-lehrkraefte-01.md` – `-03.md` | Leihvertrag Lehrkräfte (3 Chunks) |
| `leihvertrag-sus-01.md` – `-03.md` | Leihvertrag SuS (3 Chunks) |
| `schift-leihvertrag.md`, `schift-schaden.md`, `schift-formular.md` | SchifT-Dokumente (3 Chunks) |
| `faq-geraetetypen.md`, `faq-software.md`, `faq-programm.md` | FAQ (3 Chunks) |
| `programm-ueberblick.md` | Programmüberblick (1 Chunk) |
| `serienbrieffunktion.md` | Serienbrieffunktion für Vertragsdokumente (1 Chunk) |
