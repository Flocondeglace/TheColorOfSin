extends Control
class_name Dialog

#var STATE : Dictionary = {
	#HAPPY = "happy",
	#SAD = "sad",
	#ANGRY = "angry",
	#OTHER = "other",
#}
const CHOICE = preload("res://Scenes/choice.tscn")

@export var previous_characters : Array[CharacterData] = [null, null, null]
@export var previous_characters_mood : Array[String] = ["","",""]
@export var talker_gauche:bool
@export var talker_centre:bool

@export_category("Nodes")
@export var sprites_char: Array[TextureRect]
@export var label: Label
@export var dialog: VBoxContainer
@export var choices: VBoxContainer
@export var text_dialog: RichTextLabel

func apply_character(sprite, c:CharacterData, m, t):
	if c:
		sprite.show()
		sprite.texture = load(c.spriteFolder +"/"+ m +".png")
		if t:
			label.text = c.name

func set_characters(char_list: Array[CharacterData], mood_list: Array[String], talker:int):
	if char_list.size() != 3 || mood_list.size() != 3:
		push_warning("Problem")
	else :
		for i in range(3):
			if not char_list[i]:
				if char_list[i]!=previous_characters[i]:
					var anim : AnimationPlayer = sprites_char[i].get_children()[0]
					anim.play("leave")
					await anim.animation_finished
		var already_here = false
		for i in range(3):
			if char_list[i]:
				if(char_list[i]!=previous_characters[i]):
					for j in range(3):
						if char_list[i] == previous_characters[j]:
							var anim : AnimationPlayer = sprites_char[j].get_children()[0]
							anim.play(str(j)+"_"+str(i))
							await anim.animation_finished
							already_here = true
			if char_list[i] && char_list[i].name!="Kirua":
				apply_character(sprites_char[i], char_list[i], mood_list[i], i==talker)
			if not char_list[i]:
				sprites_char[i].hide()
			if char_list[i] != previous_characters[i] && not already_here:
				var anim : AnimationPlayer = sprites_char[i].get_children()[0]
				anim.play_backwards("leave")
				await anim.animation_finished
			
	previous_characters = char_list
	previous_characters_mood = mood_list

func remove_choices():
	for c in choices.get_children():
		choices.remove_child(c)

func set_text_dialog(t:String):
	text_dialog.text = t

func set_talker_name(t:String):
	label.text = t

func add_choice(text:String, actions:Array[Callable], symbole:int = 0):
	var c : Choice = CHOICE.instantiate()
	choices.add_child(c)
	c.set_up(text, actions)
	c.connect("choice_made", on_choice_made)
	if symbole != 0:
		c.set_symbole(symbole)
	c.anti_try_hard()
	#if text == "":
		#c.self_modulate = Color(1,1,1,0)
		
func on_choice_made():
	for c in choices.get_children():
		c.disable()
