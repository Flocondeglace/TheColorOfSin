extends Node
@export_dir var char_save_path
@export_dir var dialog_save_path
@export_dir var dialog_dir_json: String
@export_dir var char_dir_json: String

var dialog_json : PackedStringArray
var char_json : PackedStringArray


func _ready():
	#var dir_char : DirAccess = DirAccess.open(char_dir_json)
	#char_json = dir_char.get_files()
	#print(char_json)
	#convertir_char_json_en_tres()
	var dir_diag : DirAccess = DirAccess.open(dialog_dir_json)
	dialog_json = dir_diag.get_files()
	print(dialog_json)
	convertir_dialog_json_en_tres()
	

func read_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Erreur : Impossible de lire le fichier JSON.")
		return

	var json_string = file.get_as_text()
	var json_data = JSON.parse_string(json_string)

	if json_data == null:
		print("Erreur : JSON invalide.")
		return
	return json_data

func convertir_dialog_json_en_tres():
	var json_file = read_json(dialog_dir_json+"/dialogs.json")
	if json_file == null:
		return
	var dialogs = json_file.get("dialogs")
	for json_data in dialogs:
		var res : DialogData = DialogData.new()
		res.character = load(char_save_path + "/" + json_data.get("character", "Inconnu") + ".tres")
		var mood_name :String = json_data.get("character_mood", "happy")#.to_upper()
		res.character_mood = mood_name.to_lower() #DialogData.CharacterMood.find_key(DialogData.CharacterMood.get(mood_name))
		var name_char_droit = json_data.get("character_droit", "Inconnu")
		if name_char_droit != "Inconnu":
			res.character_droit = load(char_save_path + "/" + name_char_droit + ".tres")
			var mood_name_droit :String = json_data.get("character_mood_droit", "happy")#.to_upper()
			res.character_mood_droit = mood_name_droit.to_lower() #DialogData.CharacterMood.find_key(DialogData.CharacterMood.get(mood_name))
		res.left_talker = json_data.get("left_talker", true)
		var name_char_centre = json_data.get("character_centre", "Inconnu")
		if name_char_centre != "Inconnu":
			res.character_centre = load(char_save_path + "/" + name_char_centre + ".tres")
			var mood_name_centre :String = json_data.get("character_mood_centre", "happy")#.to_upper()
			res.character_mood_centre = mood_name_centre.to_lower() #DialogData.CharacterMood.find_key(DialogData.CharacterMood.get(mood_name))
		res.center_talker = json_data.get("center_talker", false)
		res.id = json_data.get("id")
		res.next = json_data.get("next", 0)
		res.text = json_data.get("text", "")
		var json_choices = json_data.get("choices", [])
		for c in json_choices:
			var choice_data : ChoiceData = ChoiceData.new()
			choice_data.text = c.get("text")
			choice_data.symbole = c.get("symbole", 0)
			var actions_json = c.get("actions")
			for a in actions_json:
				var action : ActionData = ActionData.new()
				var action_name :String = a.get("action", "aucune").to_upper()
				action_name = action_name.replacen("\\s", "")
				print("Action name (raw): [" + action_name + "]")
				var action_value : int = ActionData.Action.get(action_name)
				action.action = action_value #ActionData.Action.find_key(action_value)
				action.params = a.get("params",[])
				choice_data.actions.append(action)
			res.choices.append(choice_data)
		 # res.choices
		var save_path = dialog_save_path + "/" + str(res.id) + ".tres"
		ResourceSaver.save(res, save_path)
		print("Resource sauvegardée en : " + save_path)
	get_tree().quit()

func convertir_char_json_en_tres():
	for c in char_json:
		var json_data = read_json(char_dir_json+"/"+c)
		if json_data==null:
			return

		var res : CharacterData = CharacterData.new()
		res.name = json_data.get("name", "Inconnu")
		res.color = Color.from_string(json_data.get("color", "#FFFFFF"), Color.WHITE)
		res.love = json_data.get("love", 0)

		var save_path = char_save_path + "/" + res.name + ".tres"
		ResourceSaver.save(res, save_path)
		print("Resource sauvegardée en : " + save_path)
