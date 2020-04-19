extends Node


func playShot1() -> void:
	$Shot1.play()

func playShot2() -> void:
	$Shot2.play()

func playExplosion1() -> void:
	$Explosion1.play()

func playExplosion2() -> void:
	$Explosion2.play()

func playHit1() -> void:
	$Hit1.play()

func playHit2() -> void:
	$Hit2.play()

func playSelect() -> void:
	$Select.play()

func playConfirm() -> void:
	$Confirm.play()

func playUFO1() -> void:
	$UFO1.play()

func playUFO2() -> void:
	$UFO2.play()

func playUFO3() -> void:
	$UFO3.play()

func playUFO4() -> void:
	$UFO4.play()

func playUFO5() -> void:
	$UFO5.play()

func playUFO6() -> void:
	$UFO6.play()

func playIntroMusic() -> void:
	$InGameMusic.stop()
	$GameOverMusic.stop()
	$IntroMusic.play()

func playInGameMusic() -> void:
	$IntroMusic.stop()
	$GameOverMusic.stop()
	$InGameMusic.play()

func playGameOverMusic() -> void:
	$IntroMusic.stop()
	$InGameMusic.stop()
	$GameOverMusic.play()

