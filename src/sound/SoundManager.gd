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

#
# Music
#

const MUSIC_FADE_DURATION := 3.0

func _startMusic(player: AudioStreamPlayer) -> void:
	player.volume_db = 0
	player.play()


func _stopMusic(player: AudioStreamPlayer) -> void:
	if !player.playing:
		return
		
	var fo := player.find_node("FadeOut") as Tween
	fo.interpolate_property(player, "volume_db", player.volume_db, -80,
		MUSIC_FADE_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	fo.start()


func playInGameMusic() -> void:
	_stopMusic($IntroMusic)
	_stopMusic($GameOverMusic)
	_startMusic($InGameMusic)


func playGameOverMusic() -> void:
	_stopMusic($IntroMusic)
	_stopMusic($InGameMusic)
	_startMusic($GameOverMusic)


func playIntroMusic() -> void:
	_stopMusic($InGameMusic)
	_stopMusic($GameOverMusic)
	_startMusic($IntroMusic)


func _onIntroMusicFadeOutCompleted(object, key):
	$IntroMusic.stop()


func _onInGameMusicFadeOutCompleted(object, key):
	$InGameMusic.stop()


func _onGameOverMusicFadeOutCompleted(object, key):
	$GameOverMusic.stop()
