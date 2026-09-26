# Six Degrees of Wikipedia (Viquipèdia en Català)

Aquest repositori conté el codi font, scripts de processament, configuració del servidor i scripts d'anàlisi de dades per adaptar el projecte **Six Degrees of Wikipedia (SDOW)** a la Viquipèdia en català (`cawiki`).

L'objectiu del projecte és processar els *dumps* oficials de la Viquipèdia, construir la base de dades d'enllaços locals en SQLite, executar el backend en Flask i el frontend en React, i realitzar una anàlisi estadística sobre una mostra de 1.839 cerques aleatòries.

---

## Estructura dels Scripts Principals

| Fitxer / Script | Descripció |
| :--- | :--- |
| `build_base_data.sh` | Bash script per descarregar els dumps de `cawiki` i executar `process_all_links.py`. |
| `scriptviquipedia.py` | Script que automatitza les 1.839 cerques aleatòries contra l'API de Viquipèdia i el backend local. |
| `script.py` | Parser per convertir els resultats en text (`.txt`) a format unificat en **Excel** (`.xlsx`). |
| `importospy.py` | Script d'anàlisi de dades per extreure els **20 articles intermedis (hubs)** més freqüents. |

---

## Requisits de l'Entorn

* **Python:** Versió 3.10 o superior.
* **Node.js / npm:** Versió 24.20.0 o compatible (inclosa la versió portable).
* **Entorn de treball:** Windows PowerShell o Bash (Linux/macOS).

---

##  1. Descàrrega dels Dumps i Creació de la BD (`sdow.sqlite`)

Per descarregar automàticament els fitxers de la Viquipèdia catalana (`cawiki`), es pot utilitzar el script Bash de processament:

```bash
# Execució del script amb la data per defecte (2026-07-01) o data personalitzada
bash build_base_data.sh 20260701
