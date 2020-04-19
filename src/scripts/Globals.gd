extends Node

# The game state.
var gs: GameState = null

# Starts the game over sequence
func gameOver() -> void:
	if !gs.isGamingOver:
		gs.isGamingOver = true
		yield(get_tree().create_timer(5.0), "timeout")
		SS.replaceTop("res://screens/GameOverScreen.tscn")


# Effects classes
onready var bulletHitClass = preload("res://effects/BulletHit.tscn")
onready var smallExplosionClass = preload("res://effects/SmallExplosion.tscn")
onready var largeExplosionClass = preload("res://effects/LargeExplosion.tscn")

func addBulletHit(pos: Vector2) -> void:
	if RNG.flipCoin():
		SM.playHit1()
	else:
		SM.playHit2()
	var e = bulletHitClass.instance()
	e.position = pos
	e.emitting = true
	gs.playingField.add_child(e)


func addSmallExplosion(pos: Vector2) -> void:
	SM.playExplosion2()
	var e = smallExplosionClass.instance()
	e.position = pos
	e.emitting = true
	gs.playingField.add_child(e)


func addLargeExplosion(pos: Vector2) -> void:
	SM.playExplosion1()
	var e = largeExplosionClass.instance()
	e.position = pos
	e.emitting = true
	gs.playingField.add_child(e)


# Enemy classes
onready var fighterClass = preload("res://characters/Fighter.tscn")
onready var kamikazeClass = preload("res://characters/Kamikaze.tscn")


func startNextWave() -> void:
	for i in range(1):
		var e = kamikazeClass.instance()
		e.initPosition()
		gs.playingField.add_child(e)

	for i in range(3):
		var e = fighterClass.instance()
		e.initPosition()
		gs.playingField.add_child(e)


func isWaveDefeated() -> bool:
	if gs.player.isDead:
		return false

	var enemies := get_tree().get_nodes_in_group("enemies")
	return enemies.size() == 0
