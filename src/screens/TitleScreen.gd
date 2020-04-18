extends Node2D

var _canGo := false


func _ready():
	SS.setInitialScene(self)
	yield(get_tree().create_timer(1.0), "timeout")
	_canGo = true


func _input(event) -> void:
	if _canGo && event is InputEventKey or event is InputEventJoypadButton:
		SS.push("res://screens/PlayfieldScreen.tscn")
