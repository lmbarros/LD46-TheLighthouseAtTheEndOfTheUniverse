extends "res://characters/Fighter.gd"

func _ready() -> void:
	bulletClass = preload("res://bullets/SniperBullet.tscn")
	health = 6


func fire() -> void:
	isFiring = true

	for i in range(5):
		SM.playUFO5()
		yield(get_tree().create_timer(1.0), "timeout")
		if G.gs.lighthouse.isDead:
			isFiring = false
			decideWhatToDo()
			return

	var bullet = bulletClass.instance()
	bullet.fire(self)
	SM.playShot2()
	isFiring = false


func processAI(delta: float) -> void:
	# Give the sniper time to aim and shot!
	if isFiring:
		return

	match state:
		states.GOTO:
			processGoTo(delta)

		states.ATTACK_LIGHTHOUSE:
			processAttackLighthouse(delta)

func decideWhatToDo() -> void:
	var r := RNG.uniform()
	if r < 0.40 && !G.gs.lighthouse.isDead:
		doAttackLighthouse()
	else:
		doGoTo()


func doGoTo() -> void:
	state = states.GOTO
	var currPolar := cartesian2polar(position.x, position.y)
	var angle := currPolar.y + RNG.uniform(-1, +1)
	var radius := RNG.uniform(800.0, 1600.0)
	goToTarget = polar2cartesian(radius, angle)


func processGoTo(delta: float) -> void:
	moveAndCollide((goToTarget - position).normalized() * delta * speed)
	if goToTarget.distance_squared_to(position) < ARRIVAL_EPSILON:
		decideWhatToDo()


func processAttack(delta: float, target: Vector2) -> void:
	look_at(G.gs.lighthouse.position)
	fire()
	doGoTo()


func getScore() -> int:
	return 30
