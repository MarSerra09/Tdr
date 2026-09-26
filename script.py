import os
import re
import pandas as pd

# Ruta al teu fitxer a l'Escriptori
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
fitxer_entrada = os.path.join(desktop_path, "resultats_viquipedia_1839.txt")
fitxer_sortida = os.path.join(desktop_path, "resultats_1839_excel.xlsx")

# Llegir el fitxer de text
with open(fitxer_entrada, "r", encoding="utf-8") as f:
    text = f.read()

data = []

# Separem per cada lloc on posa "Cerca X:"
blocks = re.split(r"(Cerca \d+:)", text)

for i in range(1, len(blocks), 2):
    cerca_num = blocks[i].strip()
    block_content = blocks[i + 1]

    # Extreure origen i destí
    m_nodes = re.search(r"'(.*?)'\s+cap a\s+'(.*?)'", block_content)
    origen = m_nodes.group(1) if m_nodes else None
    desti = m_nodes.group(2) if m_nodes else None

    # Comprovar si ha trobat ruta o si ha estat un error/no trobat
    if "Un dels articles no existeix" in block_content:
        estat = "Error / Article no existeix"
        camins = None
        pel_mig = None
        temps = re.search(r"Trigat:\s*([\d\.]+)s", block_content)
        temps = float(temps.group(1)) if temps else None
        ruta = None
    else:
        estat = "Èxit"
        m_camins = re.search(r"Camins:\s*(\d+)", block_content)
        m_pel_mig = re.search(r"Pel mig:\s*(\d+)", block_content)
        m_temps = re.search(r"Temps:\s*([\d\.]+)s", block_content)
        m_ruta = re.search(r"Ruta:\s*(.*)", block_content)

        camins = int(m_camins.group(1)) if m_camins else None
        pel_mig = int(m_pel_mig.group(1)) if m_pel_mig else None
        temps = float(m_temps.group(1)) if m_temps else None
        ruta = (
            m_ruta.group(1).split("\n")[0].strip() if m_ruta else None
        )  # Agafa la línia de la ruta

    data.append(
        {
            "Cerca": cerca_num,
            "Origen": origen,
            "Destí": desti,
            "Estat": estat,
            "Camins": camins,
            "Elements Pel Mig": pel_mig,
            "Temps (s)": temps,
            "Ruta Completa": ruta,
        }
    )

# Convertir a taula i guardar en Excel a l'Escriptori
df = pd.DataFrame(data)
df.to_excel(fitxer_sortida, index=False)
print("Procés finalitzat! S'ha creat 'resultats_1839_excel.xlsx' a l'Escriptori.")