extends Control

@onready var game: Node2D = $"../Game"
@export var first_selected_button : Button

func _ready() -> void:
	back_to_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		quit()
		
func back_to_menu()->void:
	game.hide()
	self.show()
	first_selected_button.grab_focus()

func _on_start_button_button_up() -> void:
	game.show()
	game.start_game()
	self.hide()

func quit() -> void:
	get_tree().quit()
