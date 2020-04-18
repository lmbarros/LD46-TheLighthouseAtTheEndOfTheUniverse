extends Node

# The game state.
var gs: GameState = null

func gameOver() -> void:
	if !G.gs.isGamingOver:
		G.gs.isGamingOver = true
		yield(get_tree().create_timer(5.0), "timeout")
		SS.replaceTop("res://screens/GameOverScreen.tscn")
