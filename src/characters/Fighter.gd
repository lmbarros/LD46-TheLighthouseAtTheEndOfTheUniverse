extends "res://characters/BaseEnemy.gd"

# GOTO is "go to random point". ATTACK_PLAYER and ATTACK_LIGHTHOUSE don't need
# further explanation.
enum states { GOTO, ATTACK_PLAYER, ATTACK_LIGHTHOUSE }

var state = states.GOTO

onready var bulletClass = preload("res://bullets/WeakBullet.tscn")

var goToTarget := Vector2(0,0)

# Will fire if target is this close.
const MIN_ATTACK_DISTANCE := 300.0

# Must keep flying straight when firing, until the volley is complete.
var isFiring := false

func _ready():
	health = 1
	speed = 450
	doGoTo()


func decideWhatToDo() -> void:
	var r := RNG.uniform()
	if r < 0.15:
		doGoTo()
	elif r < 0.40:
		doAttackLighthouse()
	else:
		# Don't fly towards the player if the lighthouse is on the way
		$RayCast.cast_to = to_local(G.gs.player.position)
		$RayCast.force_raycast_update()
		if $RayCast.is_colliding():
			if RNG.bernoulli(0.75):
				doAttackLighthouse()
			else:
				doGoTo()
		else:
			doAttackPlayer()


func processAI(delta: float) -> void:
	# Fly straight if firing
	if isFiring:
		moveAndCollide(polar2cartesian(1.0, rotation) * delta * speed)
		return

	match state:
		states.GOTO:
			processGoTo(delta)

		states.ATTACK_PLAYER:
			processAttackPlayer(delta)

		states.ATTACK_LIGHTHOUSE:
			processAttackLighthouse(delta)


func processGoTo(delta: float) -> void:
	moveAndCollide((goToTarget - position).normalized() * delta * speed)
	if goToTarget.distance_squared_to(position) < ARRIVAL_EPSILON:
		decideWhatToDo()


func processAttackPlayer(delta: float) -> void:
	processAttack(delta, G.gs.player.position)


func processAttackLighthouse(delta: float) -> void:
	processAttack(delta, G.gs.lighthouse.position)


func processAttack(delta: float, target: Vector2) -> void:
	moveAndCollide((target - position).normalized() * delta * speed)
	if target.distance_to(position) < MIN_ATTACK_DISTANCE:
		fire()
		doGoTo()


func doGoTo() -> void:
	state = states.GOTO
	var currPolar := cartesian2polar(position.x, position.y)
	var angle := currPolar.y + RNG.uniform(-1, +1)
	var radius := RNG.uniform(350.0, 1000.0)
	goToTarget = polar2cartesian(radius, angle)


func doAttackPlayer() -> void:
	state = states.ATTACK_PLAYER


func doAttackLighthouse() -> void:
	state = states.ATTACK_LIGHTHOUSE


func fire() -> void:
	isFiring = true
	for i in range(3):
		var bullet = bulletClass.instance()
		rotation += RNG.uniform(-0.03, 0.03)
		bullet.fire(self)
		SM.playShot1()
		yield(get_tree().create_timer(0.15), "timeout")
	isFiring = false

func getCollisionDamage() -> float:
	return 5.0
