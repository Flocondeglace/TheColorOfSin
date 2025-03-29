extends Resource
class_name DialogData

@export var id: int
@export var next: int
@export var character: CharacterData
@export var character_mood : String # CharacterMood
@export var character_droit: CharacterData
@export var character_mood_droit : String # CharacterMood
@export var character_centre: CharacterData
@export var character_mood_centre : String
@export var left_talker : bool
@export var center_talker : bool
@export_multiline var text: String

@export_category("Choices")
@export var choices : Array[ChoiceData]
