extends Button
class_name Choice

var actions : Array[Callable]

func _init(text_choice:String, func_action:Array[Callable]):
	if (text_choice == ""):
		text_choice = "suivant"
	self.set_text(text_choice)
	actions = func_action
	self.pressed.connect(_on_pressed)
	print_debug("Choice created")

func _on_pressed()-> void:
	print_debug("Choice pressed")
	for action in actions:
		action.call()
