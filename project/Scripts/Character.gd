extends Node

class_name Character

var character_data : CharacterData
var love : int

func _init(cd:CharacterData):
	character_data = cd
	love = character_data.love

func more_love(x:int):
	love += x 
	push_warning(love)
