import os
import re

folder = "./json_diag"  # à adapter
pattern = re.compile(r"(\d+)\.json")

objects = []

for filename in os.listdir(folder):
    match = pattern.match(filename)
    if match:
        file_id = int(match.group(1))
        file_path = os.path.join(folder, filename)

        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read().strip()

            # On suppose que le JSON est un objet { ... }
            if content.startswith("{") and content.endswith("}"):
                # On injecte le champ "id" juste après la première accolade
                content_with_id = content[:1] + f'"id": {file_id}, ' + content[1:]
                objects.append(content_with_id)
            else:
                print(f"Fichier ignoré (format inattendu) : {filename}")

# Création de la liste finale JSON
output_content = '{"dialogs":' + "[\n" + ",\n".join(objects) + "\n]}"

with open("dialogs.json", "w", encoding="utf-8") as f:
    f.write(output_content)

print("Fichiers concaténés sans utiliser le module json.")
