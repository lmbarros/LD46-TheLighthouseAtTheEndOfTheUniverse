extends Node

# The game state.
var gs: GameState = null

# Starts the game over sequence
func gameOver() -> void:
	if !gs.isGamingOver:
		gs.isGamingOver = true
		yield(get_tree().create_timer(5.0), "timeout")
		SS.replaceTop("res://screens/GameOverScreen.tscn")


# Enemy classes
onready var kamikazeClass = preload("res://characters/Kamikaze.tscn")


func startNextWave() -> void:
	for i in range(3):
		var e = kamikazeClass.instance()
		e.initPosition()
		gs.playingField.add_child(e)


func isWaveDefeated() -> bool:
	if gs.player.isDead:
		return false

	var enemies := get_tree().get_nodes_in_group("enemies")
	return enemies.size() == 0
