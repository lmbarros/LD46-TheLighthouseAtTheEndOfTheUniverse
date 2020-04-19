extends Node2D

var _canGo := false


func _ready():
	SM.playGameOverMusic()
	yield(get_tree().create_timer(2.0), "timeout")
	_canGo = true


func isGoEvent(event: InputEvent) -> bool:
	return ((event is InputEventKey && event.pressed) ||
		(event is InputEventJoypadButton && event.pressed))


func _input(event: InputEvent) -> void:
	if _canGo && isGoEvent(event):
		SS.pop()
