extends Control
class_name Dialog

#var STATE : Dictionary = {
	#HAPPY = "happy",
	#SAD = "sad",
	#ANGRY = "angry",
	#OTHER = "other",
#}


@export var character_data: CharacterData
@export var character_data_droit: CharacterData
@export var character_data_centre: CharacterData
@export var mood: String # DialogData.CharacterMood
@export var mood_droit: String
@export var mood_centre: String
@export var talker_gauche:bool
@export var talker_centre:bool

@export_category("Nodes")
@export var sprite_gauche: TextureRect
@export var sprite_droit: TextureRect
@export var sprite_centre: TextureRect
@export var label: Label
@export var dialog: VBoxContainer
@export var choices: VBoxContainer
@export var text_dialog: RichTextLabel
@export var background_dialog : ColorRect


func set_character(c:CharacterData, m:String, cd:CharacterData=null, md:String="", left_talker:bool=true, cc:CharacterData=null, mc:String="", center_talker:bool=false):#DialogData.CharacterMood):
	character_data = c
	mood = m
	character_data_droit = cd
	mood_droit = md
	talker_gauche = left_talker
	character_data_centre = cc
	mood_centre = mc
	talker_centre = center_talker
	print("here")
	update_character()
	
#func mood_to_string(m:DialogData.CharacterMood)->String:
	#match m:
		#DialogData.CharacterMood.HAPPY:
			#return "happy"
		#DialogData.CharacterMood.SAD:
			#return "sad"
		#DialogData.CharacterMood.ANGRY:
			#return "angry"
		#DialogData.CharacterMood.OTHER:
			#return "other"
	#print_debug("Error : mood unknown")
	#return "unknown"
	
func update_character():
	sprite_droit.hide()
	sprite_centre.hide()
	if character_data:
		print(character_data.spriteFolder +"/"+ mood +".png")
		sprite_gauche.texture = load(character_data.spriteFolder +"/"+ mood +".png")
		if talker_gauche && !talker_centre:
			label.text = character_data.name
		# label.add_theme_color_override("font_color", character_data.color)
		# background_dialog.color = character_data.color
		if character_data_droit:
			sprite_droit.show()
			print("droit")
			print(character_data_droit.spriteFolder +"/"+ mood_droit +".png")
			sprite_droit.texture = load(character_data_droit.spriteFolder +"/"+ mood_droit +".png")
			if !talker_gauche:
				label.text = character_data_droit.name
			if character_data_centre:
				sprite_centre.show()
				print("centre")
				print(character_data_centre.spriteFolder +"/"+ mood_centre +".png")
				sprite_centre.texture = load(character_data_centre.spriteFolder +"/"+ mood_centre +".png")
				if talker_centre:
					label.text = character_data_centre.name
				
	else:
		print_debug("Character Data missing")

func remove_choices():
	for c in choices.get_children():
		if c.is_class("Button"):
			choices.remove_child(c)

func set_text_dialog(t:String):
	text_dialog.text = t

func set_talker_name(t:String):
	label.text = t

func add_choice(text:String, actions:Array[Callable]):
	var c : Choice = Choice.new(text, actions)
	choices.add_child(c)
	if text == "":
		c.self_modulate = Color(1,1,1,0)
