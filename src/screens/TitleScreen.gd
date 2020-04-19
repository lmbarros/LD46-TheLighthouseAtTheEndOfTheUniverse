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
	print("lets go")


func _input(event) -> void:
	if _canGo && event is InputEventKey or event is InputEventJoypadButton:
		SS.push("res://screens/PlayfieldScreen.tscn")
		_canGo = false
