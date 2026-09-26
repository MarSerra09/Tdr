import random
import requests
import time

def obtenir_titols_aleatoris_wikipedia():
    # Viquipèdia en català
    url_wiki = "https://ca.wikipedia.org/w/api.php"

    headers = {
        'User-Agent': 'ExperimentEducatiu1848/1.0 (contacte: elteuicorreu@exemple.com)'
    }

    params = {
        "action": "query",
        "format": "json",
        "list": "random",
        "rnnamespace": 0,
        "rnlimit": 2
    }
    try:
        resposta = requests.get(url_wiki, params=params, headers=headers).json()
        articles = resposta["query"]["random"]
        return articles[0]["title"], articles[1]["title"]
    except Exception as e:
        print(f"\n[Avís] Error temporal de connexió amb la Viquipèdia: {e}")
        return None, None

def cercar_camins(origen, desti):
    # URL real del backend al port 5000
    url_api = "http://127.0.0.1:5000/paths" 
    payload = {"source": origen, "target": desti}

    try:
        temps_inicial = time.time()
        response = requests.post(url_api, json=payload)
        temps_final = time.time()
        temps_trigat = temps_final - temps_inicial

        if response.status_code == 200:
            dades = response.json()
            paths = dades.get("paths", [])

            if not paths:
                return "OK", f"Sense camins trobats (Trigat: {temps_trigat:.2f}s)"

            num_camins = len(paths)
            longitud_cami = len(paths[0])
            articles_pel_mig = max(0, longitud_cami - 2)

            primer_cami = paths[0]
            titols_cami = [dades["pages"].get(str(page_id), {}).get("title", f"ID:{page_id}") for page_id in primer_cami]
            ruta_text = " -> ".join(titols_cami)

            resum = f"Camins: {num_camins} | Pel mig: {articles_pel_mig} | Temps: {temps_trigat:.2f}s | Ruta: {ruta_text}"
            return "OK", resum

        elif response.status_code == 400:
            return "ERROR_400", f"Un dels articles no existeix a la BD local (Trigat: {temps_trigat:.2f}s)"
        else:
            return "ERROR_API", f"Error de servidor Codi {response.status_code} (Trigat: {temps_trigat:.2f}s)"

    except Exception as e:
        return "ERROR_CONNEXIO", str(e)

# --- EXECUCIÓ PRINCIPAL ---
# CANVIS APLICATS:
TOTAL_CERQUES = 1839
fitxer_resultats = "resultats_viquipedia_1839.txt"

print(f"Iniciant l'experiment de {TOTAL_CERQUES} cerques aleatòries (Viquipèdia en Català)...")
print(f"Els resultats es guardaran a: {fitxer_resultats}\n")

with open(fitxer_resultats, "w", encoding="utf-8") as f:
    f.write(f"--- EXPERIMENT DE {TOTAL_CERQUES} CERQUES ALEATÒRIES (VIQUIPÈDIA CATALÀ) ---\n\n")

    cerques_fetes = 0

    while cerques_fetes < TOTAL_CERQUES:
        origen, desti = obtenir_titols_aleatoris_wikipedia()

        if not origen or not desti:
            time.sleep(3)
            continue

        cerques_fetes += 1
        print(f"[{cerques_fetes}/{TOTAL_CERQUES}] Buscant: '{origen}' -> '{desti}'...")

        estat, resultat_text = cercar_camins(origen, desti)

        f.write(f"Cerca {cerques_fetes}: '{origen}' cap a '{desti}'\n")
        f.write(f"Resultat: {resultat_text}\n")
        f.write("-" * 50 + "\n")

        if estat.startswith("ERROR"):
            time.sleep(3)
        else:
            time.sleep(1)

print(f"\n¡Fet! S'han completat les {TOTAL_CERQUES} cerques. Pots obrir el fitxer '{fitxer_resultats}'.")