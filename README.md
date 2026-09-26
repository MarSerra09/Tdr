# Six Degrees of Wikipedia (Viquipèdia en Català)

Aquest repositori conté el codi font, els scripts de processament, la configuració dels servidors i els scripts d'anàlisi de dades per adaptar el projecte **Six Degrees of Wikipedia (SDOW)** a la Viquipèdia en català (`cawiki`).

L'objectiu del projecte és processar els *dumps* de la Viquipèdia, construir la base de dades d'enllaços locals en SQLite, executar el backend en Flask i el frontend en React, i realitzar una anàlisi estadística sobre una mostra de 1.839 cerques aleatòries.

---

## Estructura del Repositori

| Fitxer | Descripció |
| :--- | :--- |
| `powershell` | Guia i seqüència de comandes per Windows PowerShell per instal·lar, processar i arrencar el projecte. |
| `scriptviquipediapy` | Script que automatitza les 1.839 cerques aleatòries connectant-se a l'API de Viquipèdia i al backend local. |
| `script.py` | Parser que converteix el registre en text (`.txt`) en un fitxer **Excel** estructurat (`.xlsx`). |
| `importospy` | Script d'anàlisi de dades per identificar els **20 articles intermedis (hubs)** més freqüents. |

---

## 🛠️ Requisits de l'Entorn

* **Python:** Versió 3.10 o superior.
* **Node.js / npm:** Versió 24.20.0 o compatible.
* **Entorn d'execució:** Windows PowerShell.

---

## Passos per Recrear el Projecte

Tots els passos detallats a continuació es troben reflectits al fitxer d'instruccions `powershell`.

### 1. Clonar el repositori i preparar l'entorn virtual
```powershell
git clone [https://github.com/jwngr/sdow.git](https://github.com/jwngr/sdow.git)
cd sdow

# Configurar permisos d'execució a PowerShell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Crear i activar l'entorn virtual de Python
python -m venv env
& ".\env\Scripts\Activate.ps1"

# Instal·lar dependències
python -m pip install --upgrade pip
python -m pip install flask flask-cors pandas openpyxl
pip install -r requirements.txt
