extends Resource
class_name ActionData

enum Action { AUCUNE=0, GO_TO=1, MORE_LOVE=2, END=3, CHANGE_BACKGROUND=4, PHONE=5, REMOVE_PHONE=6, BLACK_MELTING=7, WHITE_MELTING=8, EFFECT=9}

@export var action:Action
@export var params:Array
