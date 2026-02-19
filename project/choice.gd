extends HBoxContainer
class_name Choice

signal choice_made

var actions : Array[Callable]
@export var liste_symboles : Array[Texture2D]
var button: Button
var symbole: TextureRect
var animation : AnimationPlayer
#@export var num_symbole : int = 0 :
	#get:
		#return num_symbole
	#set(value):
		#num_symbole = value
		#set_symbole(num_symbole)

func _ready() -> void:
	
	print("ready")

'''
Choice should have been already added to tree
'''
func set_up(text_choice:String, func_action:Array[Callable]):
	print(is_inside_tree())
	print("set up")
	if (text_choice == ""):
		text_choice = ">"
	var padding :String = "  "
	text_choice = padding + text_choice + padding
	button = $Choice
	symbole = $Symbole
	animation = $AnimationPlayer
	button.set_text(text_choice)
	actions = func_action
	button.pressed.connect(_on_pressed)
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	symbole.texture = null
	print_debug("Choice set up")
	
func set_symbole(num:int):
	if num == 0 :
		symbole.texture = null
	else :
		symbole.texture = liste_symboles[num-1]

func anti_try_hard():
	button.disabled = true
	get_tree().create_timer(1.0).timeout.connect(func():button.disabled=false)

func disable():
	button.disabled = true

func _on_pressed()-> void:
	choice_made.emit()
	print_debug("Choice pressed")
	if symbole.texture != null :
		print("animation en cours")
		animation.play("effect_choice")
		await animation.animation_finished
		print("animation fini")
		
	for action in actions:
		action.call()
