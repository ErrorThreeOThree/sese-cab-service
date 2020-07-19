# Responsibilities

## Member List

- Chanki Hong
- Christopher Woggon
- Florentin Ehser
- Julian Hartmer
- Maximilian Weissenseel

## Chanki Hong

**Rolle:** Quality Manager

**erledigte Aufgaben:** 

- Webots
  - Aufbau des Cabs inclusiv von allen Sensoren ,Motoren
  - Implementierung der Basisfunktionen vom Cab  (in the additional-contributions/Version1)
     - Abstand sensor 
     - Infrared sensor 
     - Motoren
     - Camera 
  - Implementierung der Algorithmen in Webots (in the additional-contributions/Version2)
     - Roadmarker 
     - Line Detection 
     - In to the Depot 
     - Out to the Depot
     - Obstacle Avoidance

- External Controller
  - Umsetzung die Algorithmen von Webots ins Ada
    - Line Detection
    - Roadmarker
  - Auswertung des Statecharts mit Florentin und Julian

- Quality Management
  - Unit Testing in External Controller
    - Line Detection (First Version)
    - Roadmarker
    - Motor Controller
  - Verfassung des Coding standards
    - C/C++
    - Socket Programming 
    - ADA 
    - JAVA 
  - Verification durch SPARK
    - Roadmarker 
    - Motor Controller 
    - Front Distance 


## Christopher Woggon

**Rolle:** Technical Manager (zu Anfang: Quality Manager)

**erledigte Aufgaben:** 

- Webots
    - Line following in C++ angepasst
    - Collision detection in C++ entwickelt und umgesetzt, Sensoren an Cab angebracht
    - Neue Welt von Grund auf erstellt (Layout, Boden, Linien, Curbs, Road Marker, Depot)
    - Cab mit Sensoren (+ Backup-Sensoren) ausgestattet (für collision detection, curb detection, line following, road marker detection, wall detection)
    - Motoren an Cab angebracht um Curb Detection Sensoren hoch- und runterzufahren (+ Konzept entwickelt)
    - Road Marker Konzept entwickelt, Auswertungsalgorithmus is C++ implementiert
- Quality Management
  
    - QA Konzept erstellt (`QA.md`)
- Technical Management
    - Server
        - 2 VPS
        - Installation, Konfiguration
        - Regelmäßiges Deployment von Frontend + Backend auf beiden Servern
    - Jenkins
        - Installation und Einrichtung
        - docker-compose file um Ada Code in Pipeline zu kompilieren
        - Java Tests
    - git
        - Umzug des Repos
        - Pull Request Bedingungen
            - Jenkins Pipeline
            - Review
- Backend entwickelt
    - Sehr umfangreich getestet
    - REST Schnittstellen + Logik für
        - Jobs
        - Routes
        - Location
        - Registration
        - Pickup
        - Dropoff
        - Blocked
        - Dysfunctional
        - Debug
        - Reset
    - Logik für
        - PathFinder (Routenfindung zwischen Sektionen)
    - Schnittstellenkonzepte größtenteils mit Maximilian Weisenseel entwickelt (`interface-definitions.md`)
- Frontend entwickelt
- Anleitung für Installation/Ausführung von Backend/Frontend erstellt

  ​      

## Florentin Ehser

**Rolle:** Time Manager

**erledigte Aufgaben:** 

- Zeitplan aufgestellt und aktuell gehalten
- Arbeitspakete gemeinsam mit Gruppe erstellt und verteilt
- Projektziele & Anforderungen gesammelt und festgelegt
- Risiken und mögliche Strategien gesammelt
- strukturierte Anforderungen für Teilsysteme erstellt
- Sicherheitsebenen definiert
- grundsätzliche Funktionsweise des Gesamtsystems konzeptioniert und weiterentwickelt
- Statechart von Gesamtsystem entwickelt
- Erstes Konzept für Backend erstellt
- Erste Unit-Tests für Statechart geschrieben
- verbesserte Anordnung der Roadmarker entwickelt
- Lanefollowing-Konzept überarbeitet
- Anpassungen in der Webots-Simulation:
  - Konzept verschieden farbiger Mittellinien umgesetzt
  - Roadmarker angepasst
  - Designverbesserung Cab
  - zweites Cab
- Unit-Tests für externen Controller kontrolliert und korrigiert
- Backend pair-reviewed
- System-Tests durchgeführt
- System mit Anforderungen abgeglichen
- Anleitung Simulation geschrieben
- Dokumentation der Sensoren geschrieben
- Repository aufgeräumt

## Julian Hartmer

**Rolle:** Integrationsbeauftragter

**erledigte Aufgaben:** 
- Externer Controller:
  - Festlegen des Testingformats des ADA Codes
  - Skeleton zur Erstellung der Unittests in ADA
  - Implementierung des Ringbuffers für die Kommunikation
  - Skript zur Ausführung der ADA Unit Tests in CI
  - Definition der internen Schnittstellen des externen Controllers
  - Implementierung der Pakete Motor Controller, Externer Controller, Lane Detection, Roadmarker (mit Chanki) und Front Distance
  - mehrere Testprojekte zum Umsetzen der Nebenläufigkeit der Pakete (siehe Ordner DEPRECATED)
- Statechart
  - Auswertung des Statecharts (mit Florentin und Chanki)
- Integration Management:
  - Testen der Pakete Motor Controller, Externer Controller, Lane Detection, Roadmarker (mit Chanki) und Front Distance (teilweise mit Florentin und Chanki)
  - Festlegen der Schnittstelle Externer Controller und Webots Controller (mit Max)
  - Entwurf Struktur Externer Kontroller auf Grundlage des Statecharts
    - Sehr hoher grad an Nebenläufigkeit
    - Aufteilen der Arbeit in einzelne, leicht testbare Projekte
    - Abstrakte Kommunikation zwischen den Paketen: Jedes Paket bietet ein Abstraktionslayer zwischen Sensordaten und high-level Commands an.
- Dokumentation:
  - Generierung der Dokumentation zu den  Paketen Motor Controller, Externer Controller, Lane Detection, Roadmarker und Front Distance
  - Hinzufügen der Projektstruktur zum README
  - Erstellen der Fault-Tree-Diagramme zur einfachen Übersicht der Error-States des externen Controllers (siehe *Security Concept Description.md*)

## Maximilian Weissenseel

**Rolle: Integration Manager** 

**erledigte Aufgaben:**
- WC2EC: Webots Controller to External Controller
    - Festlegen der Schnittstelle Externen Controller <-> Webots (mit Julian)
    - Entwurf des WC2EC Protokolls (`WC2EC.md`) (mit Julian)
    - Implementierung von WC2EC im Webots Controllers
    - Implementierung von WC2EC im Externen Controller
    - Features: 
        - Skalierbarkeit:
            - beliebig viele Cabs möglich 
            - beliebiges hinzufügen von bereits implementierten Sensortypen ohne anpassen des Codes
        - Effizienz: 
            - Wenig Overhead
            - optimale Bandbreitennutzung
        - Usability:
            - Schnittstelle in Ada
            - in Ada werden die selben Sensornamen wie auch in der Welt verwendet
    
- EC2B: External Controller to Backend
    - Festlegen der Schnittstelle Externer Controller <-> Backend mit Christopher (`interface-definitions.md`)
    - Implementierung der EC2B Schnittstelle im Externen Controller
    - Implementierung des Job_Executers auf Basis der EC2B Schnittstelle
    - Testen der EC2B Schnittstelle und des Job_Executers   
