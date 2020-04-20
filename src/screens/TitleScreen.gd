extends Node2D

var _canGo := false


func _ready():
	SS.setInitialScene(self)
	SM.playIntroMusic()
	yield(get_tree().create_timer(1.5), "timeout")
	$PlayBtn.grab_focus()
	_canGo = true


func onDigOut(_dummy):
	SM.playIntroMusic()
	yield(get_tree().create_timer(2.0), "timeout")
	$PlayBtn.grab_focus()
	_canGo = true


func isGoEvent(event: InputEvent) -> bool:
	return ((event is InputEventKey && event.pressed) ||
		(event is InputEventJoypadButton && event.pressed))


func _onPlayBtnPressed():
	if _canGo:
		SM.playConfirm()
		SS.push("res://screens/PlayfieldScreen.tscn")


func _onQuitBtnPressed():
	SM.playConfirm()
	SS.pop()


func _onHelpBtnPressed():
	SM.playConfirm()
	SS.push("res://screens/HelpScreen.tscn")
