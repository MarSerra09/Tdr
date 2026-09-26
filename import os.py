import os
import re
from collections import Counter
import pandas as pd

# Ruta al teu fitxer de l'Escriptori
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
fitxer_entrada = os.path.join(desktop_path, "resultats_viquipedia_1839.txt")

# Llegir el fitxer de text
with open(fitxer_entrada, "r", encoding="utf-8") as f:
    text = f.read()

# Extreure totes les línies de rutes
rutes = re.findall(r"Ruta:\s*(.*)", text)

hubs_counter = Counter()

for r in rutes:
    # Dividir la ruta pels separadors "->"
    nodes = [node.strip() for node in r.split("->")]

    # Triem només els nodes intermedis (excloem el primer i l'últim)
    if len(nodes) > 2:
        nodes_intermedis = nodes[1:-1]
        hubs_counter.update(nodes_intermedis)

# Crear un DataFrame amb els 20 hubs més freqüents
top_hubs = hubs_counter.most_common(20)
df_hubs = pd.DataFrame(
    top_hubs, columns=["Article (Hub)", "Freqüència (Vegades que apareix)"]
)

# Guardar el resultat a l'Escriptori
fitxer_sortida_hubs = os.path.join(desktop_path, "hubs_mes_repetits.xlsx")
df_hubs.to_excel(fitxer_sortida_hubs, index=False)

print(
    "Anàlisi de hubs completada! S'ha generat 'hubs_mes_repetits.xlsx' a l'Escriptori."
)
print("\nEls 5 hubs principals són:")
print(df_hubs.head(5))