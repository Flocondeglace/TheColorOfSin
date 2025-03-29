extends Node2D

signal end
@export var current_dialog_id : int
@export_dir var folder_dialog : String
@export var dialog : Dialog
@export var background : TextureRect
@export var dialog_box : Node
@export var centered_text_box : Node
@export var effect_texture_rect : TextureRect

var uncountered_characters : Dictionary = {}
var dialog_data : DialogData
var current_character : Character
var dialog_mode : bool = false
var is_playing : bool = false


func start_game()->void:
	is_playing = true
	dialog_mode = false
	current_dialog_id = 0
	# dialog_mode = true
	# current_dialog_id = 77
	if dialog_mode:
		dialog_box.show()
		centered_text_box.hide()
	else:    
		centered_text_box.show()
		dialog_box.hide()
		change_background("black")
	change_dialog(current_dialog_id)

func _input(event: InputEvent) -> void:
	if is_playing:
		if event.is_action_released("ui_accept"):
			if not dialog_mode:
				if dialog_data.choices.size() == 1:
					for action in dialog_data.choices[0].actions:
						find_action(action).call()
				else :
					change_dialog(dialog_data.next)
	
func find_action(a: ActionData)->Callable:
	match a.action:
		ActionData.Action.AUCUNE:
			return func():print_debug("aucune action")
		ActionData.Action.GO_TO:
			return func():change_dialog(a.params[0])
		ActionData.Action.MORE_LOVE:
			return func():current_character.more_love(a.params[0])
		ActionData.Action.END:
			return func():plot_end()
		ActionData.Action.CHANGE_BACKGROUND:
			return func():change_background(a.params[0])
		ActionData.Action.PHONE:
			return func():activate_phone(a.params[0])
		ActionData.Action.REMOVE_PHONE:
			return func():remove_phone()
		ActionData.Action.BLACK_MELTING:
			return func():black_melting()
		ActionData.Action.WHITE_MELTING:
			return func():white_melting()
		ActionData.Action.EFFECT:
			return func():apply_effect(a.params[0])
		_:
			return func():print_debug("action not found")

func set_character():
	var name : String = dialog_data.character.name
	if uncountered_characters.has(name):
		pass
	else :
		uncountered_characters[name] = Character.new(dialog_data.character)
		# push_warning("New character had : "+ name)
	if dialog_data.character_droit:
		var name_droit : String = dialog_data.character_droit.name
		if uncountered_characters.has(name_droit):
			pass
		else :
			uncountered_characters[name_droit] = Character.new(dialog_data.character_droit)
			# push_warning("New character had : "+ name_droit)
	if dialog_data.character_centre:
		var name_centre : String = dialog_data.character_centre.name
		if uncountered_characters.has(name_centre):
			pass
		else :
			uncountered_characters[name_centre] = Character.new(dialog_data.character_centre)
			# push_warning("New character had : "+ name_centre)
	current_character = uncountered_characters.get(name)
	print(dialog_data.character.name)
	if dialog_data.character_droit:
		print(dialog_data.character_droit.name)
	if dialog_data.character_centre:
		print(dialog_data.character_centre.name)
	dialog.set_character(dialog_data.character, dialog_data.character_mood, dialog_data.character_droit, dialog_data.character_mood_droit, dialog_data.left_talker, dialog_data.character_centre, dialog_data.character_mood_centre, dialog_data.center_talker)

func change_dialog(id:int):
	print("current id : " + str(id))
	dialog.remove_choices()
	dialog_data = load(folder_dialog+"/"+str(id)+".tres")
	if (id==-1):
		current_dialog_id = 0
		 
		plot_end()
	else:
		if dialog_mode:
		
			# Character
			set_character()
			
			# Dialog
			dialog.set_text_dialog(dialog_data.text)
			
			# Choices
			for c in dialog_data.choices:
				var actions : Array[Callable] = []
				for a in c.actions:
					actions.append(find_action(a))
				dialog.add_choice(c.text, actions)
			if dialog_data.choices.size() == 0:
				dialog.add_choice("", [func():change_dialog(dialog_data.next)])
			dialog_box.find_children("","Button",true, false)[0].grab_focus()
		else:
			var centered_text : RichTextLabel = centered_text_box.get_child(0)
			centered_text.text = "[center]%s[/center]" % dialog_data.text
			

func plot_end():
	is_playing = false
	end.emit()
	push_warning("TODO")

func change_background(filename:String):
	var texture_background : Texture
	if filename == "black":
		texture_background = load("res://Assets/The Color of Sin/Décors/black.tres")
		dialog_box.hide()
		centered_text_box.show()
		print("TODO")
		dialog_mode = false
	else:
		print("TODO")
		texture_background = load("res://Assets/The Color of Sin/Décors/"+filename)
		centered_text_box.hide()
		dialog_box.show()
		dialog_mode = true
	background.texture = texture_background
	
func activate_phone(caller_name:String):
	print(caller_name)
	$AnimationPlayer.play("sonne")
	dialog.set_talker_name(caller_name)
	
func remove_phone():
	$AnimationPlayer.play("RESET")

func black_melting():
	$AnimationPlayer.play("black_melting")
	
func white_melting():
	$AnimationPlayer.play("white_melting")

func apply_effect(name_effect:String):
	print("res://Assets/The Color of Sin/Effets/" + name_effect)
	effect_texture_rect.texture = load("res://Assets/The Color of Sin/Décors/Effets/" + name_effect)
	$AnimationPlayer.play("play_effect")
