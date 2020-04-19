extends Node2D

var _canGo := false


func _ready():
	updateText()
	SM.playGameOverMusic()
	yield(get_tree().create_timer(2.0), "timeout")
	_canGo = true
	$SighBtn.grab_focus()


func updateText() -> void:
	var msg := G.gs.gameOverMessage
	msg += "\n\nYour score was %s." % G.gs.score
	$Message.text = msg


func _onSighBtnPressed():
	SS.pop()
