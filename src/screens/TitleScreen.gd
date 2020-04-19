extends Node2D

var _canGo := false


func _ready():
	SS.setInitialScene(self)
	SM.playIntroMusic()
	yield(get_tree().create_timer(1.5), "timeout")
	_canGo = true


func onDigOut(_dummy):
	SM.playIntroMusic()
	yield(get_tree().create_timer(2.0), "timeout")
	_canGo = true


func isGoEvent(event: InputEvent) -> bool:
	return ((event is InputEventKey && event.pressed) ||
		(event is InputEventJoypadButton && event.pressed))


func _input(event: InputEvent) -> void:
	if _canGo && isGoEvent(event):
		_canGo = false
		SS.push("res://screens/PlayfieldScreen.tscn")
