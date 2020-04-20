extends Node2D

func _ready():
	$ThanksBtn.grab_focus()


func _onThanksBtnPressed():
	SM.playConfirm()
	SS.pop()
