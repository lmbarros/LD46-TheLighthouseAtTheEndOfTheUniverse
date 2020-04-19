extends Node2D

var _canGo := false


func _ready():
	SM.playGameOverMusic()
	yield(get_tree().create_timer(2.0), "timeout")
	_canGo = true


func _input(event) -> void:
	if _canGo && event is InputEventKey or event is InputEventJoypadButton:
		SS.pop()
