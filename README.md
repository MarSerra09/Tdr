# Six Degrees of Wikipedia (Viquipèdia en Català)

Aquest repositori conté el codi font, els scripts de processament, la configuració dels servidors i els scripts d'anàlisi de dades per adaptar el projecte **Six Degrees of Wikipedia (SDOW)** a la Viquipèdia en català (`cawiki`).

L'objectiu del projecte és descarregar els *dumps* oficials de la Viquipèdia catalana, processar-los per construir la base de dades SQLite local, executar el servidor backend en Flask, el frontend en React i realitzar una anàlisi estadística sobre una mostra de 1.839 cerques aleatòries.

---

## Autoria i Llicència

Aquest projecte és una adaptació i simplificació del projecte original **[Six Degrees of Wikipedia (SDOW)](https://github.com/jwngr/sdow)** creat per **Jacob Wenger ([jwngr](https://github.com/jwngr))**.

* **Codi original (Jacob Wenger):** L'estructura base de la base de dades, l'algorisme de cerca i la lògica del backend/frontend pertanyen al projecte original SDOW i estan subjectes a la **[Llicència MIT](https://opensource.org/licenses/MIT)**.
* **Aportacions i adaptacions pròpies:**
  * Adaptació i optimització de la base de dades SQLite per a la **Viquipèdia en català (`cawiki`)**.
  * Script de mostreig automàtic (`scriptviquipediapy`) per dur a terme 1.839 cerques aleatòries connectades a l'API pública de la Viquipèdia.
  * Script de conversió a Excel (`script.py`) per a l'estructuració de les dades obtingudes.
  * Script d'anàlisi de freqüències (`importospy`) per a la identificació i recompte dels 20 articles intermedis (*hubs*) més utilitzats.
  * Scripts de configuració i automatització global de l'entorn.

---

## Dades Utilitzades i Requisits Previs

Per dur a terme aquest projecte s'han utilitzat els *dumps* oficials de la Viquipèdia en català amb data **01/07/2026**.

> **⚠️ NOTA IMPORTANT:** Abans d'executar qualsevol dels scripts d'anàlisi o processament propi, cal descarregar prèviament tots els fitxers i la font del repositori des de la [web oficial de Six Degrees of Wikipedia](https://github.com/jwngr/sdow) (o clonar l'estructura base d'aquest repositori) i obtenir els fitxers `.sql.gz` corresponents des de la plataforma de *dumps* de la Fundació Wikimedia.

---

## Estructura dels Fitxers al Repositori

| Fitxer | Funció i Descripció | Autoria |
| :--- | :--- | :--- |
| `POWERSHELL` | Script/Guia principal d'execució en Windows PowerShell que automatitza tot el procés. | Pròpia |
| `buildDatabase.sh` | Script Bash executat per a la descàrrega dels *dumps* `.sql.gz` de `cawiki` i la generació de la BD. | Adaptació de J. Wenger |
| `scriptviquipediapy` | Script d'automatització que realitza les 1.839 cerques aleatòries via API i backend local. | Pròpia |
| `script.py` | Parser en Python que converteix el registre de text de les cerques en un fitxer **Excel** estructurat. | Pròpia |
| `importospy` | Script d'anàlisi de dades que avalua les rutes i extreu els **20 articles intermedis (hubs)** més freqüents. | Pròpia |

---

## Requisits de l'Entorn

* **Python:** Versió 3.10 o superior (`flask`, `flask-cors`, `pandas`, `openpyxl`).
* **Node.js / npm:** Versió 24.20.0 o compatible.
* **Terminal d'execució:** Windows PowerShell.

---

## Execució

Executa aquesta seqüència pas a pas a la terminal de PowerShell per realitzar tot el procés:

### 1. Clonar el repositori i preparar l'entorn virtual
```powershell
# Clonar i accedir al directori del projecte
git clone [https://github.com/MarSerra09/Tdr.git](https://github.com/MarSerra09/Tdr.git)
cd Tdr

# Permetre l'execució d'scripts a PowerShell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Crear i activar l'entorn virtual de Python
python -m venv env
& ".\env\Scripts\Activate.ps1"

# Instal·lar les dependències de Python
python -m pip install --upgrade pip
python -m pip install flask flask-cors pandas openpyxl
pip install -r requirements.txt
