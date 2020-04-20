extends Node

const MAX_ASTEROIDS := 5

# The game state.
var gs: GameState = null

# Starts the game over sequence
func gameOver() -> void:
	if !gs.isGamingOver:
		gs.isGamingOver = true
		yield(get_tree().create_timer(5.0), "timeout")
		gs.gameOverMessage = getGameOverMessage()
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
onready var sniperClass = preload("res://characters/Sniper.tscn")


func startNextWave() -> void:
	# Fighters are the bread and butter enemies (what a metaphor!)
	var k := int(pow(G.gs.waveNumber, 1.1) * RNG.uniform(1.1, 1.25))
	for i in range(k):
		createEnemy(fighterClass)

	# Start adding some kamikazes after a few waves
	if G.gs.waveNumber < 3:
		k = 0
	else:
		k = int(pow(G.gs.waveNumber-3, 1.2) * RNG.uniform(1.0, 1.2))

	for i in range(k):
		createEnemy(kamikazeClass)

	# And then some snipers!
	if G.gs.waveNumber < 5:
		k = 0
	else:
		k = int(pow(G.gs.waveNumber-5, 1.2) * RNG.uniform(1.1, 1.3))

	for i in range(k):
		createEnemy(sniperClass)


func createEnemy(theClass: PackedScene) -> void:
		var e = theClass.instance()
		e.initPosition()
		gs.playingField.add_child(e)


func isWaveDefeated() -> bool:
	if gs.player.isDead:
		return false

	var enemies := get_tree().get_nodes_in_group("enemies")
	return enemies.size() == 0


func getGameOverMessage() -> String:
	if gs.player.isDead && gs.lighthouse.isDead:
		return "Both you and the lighthouse were destroyed! A defeat combo!"
	elif gs.player.isDead:
		return "You were killed by the space marauders! They probably destroyed the lighthouse afterwards. Or maybe they occupied it and then did a better job than you defending it. Maybe."
	else:
		return "The lighhouse was destroyed! And worse: you survived and will have to feel the shame of your flop!"



# Asteroid class
onready var asteroidClass = preload("res://misc/Asteroid.tscn")

func createAsteroidMaybe() -> void:
	if gs.asteroidCount < MAX_ASTEROIDS:
		gs.asteroidCount += 1
		var a = asteroidClass.instance()
		a.initPosition()
		gs.playingField.add_child(a)
