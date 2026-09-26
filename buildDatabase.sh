import os
import re
import gzip
import sqlite3

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
DUMP_DIR = os.path.join(ROOT_DIR, "dump")
DB_PATH = os.path.join(ROOT_DIR, "sdow.sqlite")

def get_dump_filepath(pattern):
    for filename in os.listdir(DUMP_DIR):
        if re.search(pattern, filename):
            return os.path.join(DUMP_DIR, filename)
    raise FileNotFoundError(f"No s'ha trobat cap fitxer que coincideixi amb el patró: {pattern}")

def parse_sql_file(filepath):
    """Llegeix el fitxer SQL comprimit en blocs de 64KB per estalviar memòria RAM."""
    with gzip.open(filepath, 'rt', encoding='utf-8', errors='ignore') as f:
        buffer = ""
        while True:
            chunk = f.read(65536)
            if not chunk:
                break
            buffer += chunk
            lines = buffer.split('\n')
            buffer = lines.pop()
            for line in lines:
                if line.startswith("INSERT INTO"):
                    yield line

def create_database():
    print("[1/5] Processant pàgines (Espai de noms 0)...")
    pages = {}  # page_id -> (title, is_redirect)
    page_file = get_dump_filepath(r"page\.sql\.gz")
    page_pattern = re.compile(r"\((\d+),0,'([^']+)','[^']*',(\d+),")
    
    for insert_line in parse_sql_file(page_file):
        matches = page_pattern.findall(insert_line)
        for page_id, title, is_redirect in matches:
            pages[int(page_id)] = (title, int(is_redirect))

    print(f"-> Carregades {len(pages)} pàgines vàlides.")

    print("[2/5] Processant redireccions...")
    redirect_file = get_dump_filepath(r"redirect\.sql\.gz")
    redirects = {}  # source_page_id -> target_title
    redirect_pattern = re.compile(r"\((\d+),0,'([^']*)',")

    for insert_line in parse_sql_file(redirect_file):
        matches = redirect_pattern.findall(insert_line)
        for src_id, target_title in matches:
            src_id = int(src_id)
            if src_id in pages:
                redirects[src_id] = target_title

    print("[3/5] Processant linktargets...")
    linktarget_file = get_dump_filepath(r"linktarget\.sql\.gz")
    linktargets = {}  # lt_id -> target_title
    lt_pattern = re.compile(r"\((\d+),0,'([^']*)'\)")

    for insert_line in parse_sql_file(linktarget_file):
        matches = lt_pattern.findall(insert_line)
        for lt_id, target_title in matches:
            linktargets[int(lt_id)] = target_title

    title_to_id = {data[0]: p_id for p_id, data in pages.items()}

    print("[4/5] Processant pagelinks i associant connexions...")
    pagelinks_file = get_dump_filepath(r"pagelinks\.sql\.gz")
    links = {}  # source_id -> set(target_ids)
    pl_pattern = re.compile(r"\((\d+),0,(\d+),0\)")

    for insert_line in parse_sql_file(pagelinks_file):
        matches = pl_pattern.findall(insert_line)
        for src_id, lt_id in matches:
            src_id, lt_id = int(src_id), int(lt_id)
            if src_id in pages and lt_id in linktargets:
                target_title = linktargets[lt_id]
                if target_title in title_to_id:
                    target_id = title_to_id[target_title]
                    if src_id not in links:
                        links[src_id] = set()
                    links[src_id].add(target_id)

    print("[5/5] Escrivint dades a la base de dades SQLite (sdow.sqlite)...")
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("DROP TABLE IF EXISTS pages")
    cursor.execute("DROP TABLE IF EXISTS redirects")
    cursor.execute("DROP TABLE IF EXISTS links")

    cursor.execute("""
        CREATE TABLE pages (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            is_redirect INTEGER NOT NULL
        )
    """)
    cursor.execute("""
        CREATE TABLE redirects (
            source_id INTEGER PRIMARY KEY,
            target_id INTEGER NOT NULL
        )
    """)
    cursor.execute("""
        CREATE TABLE links (
            id INTEGER PRIMARY KEY,
            outgoing_links TEXT NOT NULL,
            incoming_links TEXT NOT NULL
        )
    """)

    # Inserció de pàgines
    page_records = [(p_id, data[0], data[1]) for p_id, data in pages.items()]
    cursor.executemany("INSERT INTO pages VALUES (?, ?, ?)", page_records)

    # Inserció de redireccions resoltes
    redirect_records = []
    for src_id, target_title in redirects.items():
        if target_title in title_to_id:
            redirect_records.append((src_id, title_to_id[target_title]))
    cursor.executemany("INSERT INTO redirects VALUES (?, ?)", redirect_records)

    # Construcció i inserció de connexions
    incoming_map = {}
    outgoing_map = {}

    for src_id, targets in links.items():
        outgoing_map[src_id] = " ".join(map(str, sorted(targets)))
        for t_id in targets:
            if t_id not in incoming_map:
                incoming_map[t_id] = []
            incoming_map[t_id].append(src_id)

    all_page_ids = set(pages.keys())
    link_records = []
    for p_id in all_page_ids:
        out_str = outgoing_map.get(p_id, "")
        inc_str = " ".join(map(str, sorted(incoming_map.get(p_id, []))))
        link_records.append((p_id, out_str, inc_str))

    cursor.executemany("INSERT INTO links VALUES (?, ?, ?)", link_records)

    # Creació d'índex per optimitzar consultes ràpides per títol
    print("Creant índex per títol...")
    cursor.execute("CREATE INDEX idx_pages_title ON pages (title)")

    conn.commit()
    conn.close()
    print("✅ Base de dades sdow.sqlite creada correctament!")

if __name__ == "__main__":
    create_database()
