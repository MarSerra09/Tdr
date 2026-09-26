# Six Degrees of Wikipedia (Viquipèdia en Català)

Aquest repositori conté el codi font, els scripts de processament, la configuració dels servidors i els scripts d'anàlisi de dades per adaptar el projecte **Six Degrees of Wikipedia (SDOW)** a la Viquipèdia en català (`cawiki`).

L'objectiu del projecte és descarregar els *dumps* oficials de la Viquipèdia catalana, processar-los per construir la base de dades SQLite local, executar el servidor backend en Flask, el frontend en React i realitzar una anàlisi estadística sobre una mostra de 1.839 cerques aleatòries.

---

## Estructura dels Fitxers al Repositori

| Fitxer | Funció i Descripció |
| :--- | :--- |
| `POWERSHELL` | Script/Guia principal d'execució en Windows PowerShell que automatitza tot el procés: preparació de l'entorn, descàrrega de dades, creació de la BD i arrencada dels servidors. |
| `DATABASE` | Script Bash cridat pel procés de base de dades per a la descàrrega automatitzada dels *dumps* `.sql.gz` de la Viquipèdia (`cawiki`) i l'execució del filtratge inicial. |
| `scriptviquipediapy` | Script d'automatització que realitza les 1.839 cerques aleatòries connectant-se a l'API pública de Viquipèdia i al backend local (`http://localhost:5000/paths`). |
| `script.py` | Parser en Python que converteix el registre de text de les cerques (`resultats_viquipedia_1839.txt`) en un fitxer **Excel** estructurat (`.xlsx`). |
| `importospy` | Script d'anàlisi de dades que avalua les rutes obtingudes i extreu els **20 articles intermedis (hubs)** més freqüents. |

---

##  Requisits de l'Entorn

* **Python:** Versió 3.10 o superior (`flask`, `flask-cors`, `pandas`, `openpyxl`).
* **Node.js / npm:** Versió 24.20.0 o compatible (s'utilitza la versió portable).
* **Terminal d'execució:** Windows PowerShell.

---

## Execució

Segueix aquesta seqüència pas a pas a la terminal de PowerShell per executar tot el projecte des de zero:

### 1. Clonar el repositori i preparar l'entorn virtual
```powershell
# Clonar i accedir al directori del projecte
git clone [https://github.com/jwngr/sdow.git](https://github.com/jwngr/sdow.git)
cd "C:\Users\MarSerraDomínguez\Downloads\sdow-main\sdow-main"

# Permetre l'execució d'scripts a PowerShell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Crear i activar l'entorn virtual de Python
python -m venv env
& ".\env\Scripts\Activate.ps1"

# Instal·lar les dependències de Python
python -m pip install --upgrade pip
python -m pip install flask flask-cors pandas openpyxl
pip install -r requirements.txt
