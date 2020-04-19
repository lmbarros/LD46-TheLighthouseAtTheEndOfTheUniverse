extends "res://characters/BaseEnemy.gd"

# Time in seconds before attack
var waitTime := 6.5

# CIRCLE is "circle around the lighthouse". WAIT is "point to the lighthouse and
# wait a bit". ATTACK is "do a little dance and then attack"
enum states { CIRCLE, WAIT, ATTACK }

var state = states.CIRCLE

# Number of circulations performed
var numCircles := 0

const ARRIVAL_EPSILON := 20.0

# Acceleration when attacking; max attack speed
const ATTACK_ACCELERATION := 50
const MAX_ATTACK_SPEED := 1000

var circleTargetAngle := 0.0
var circleTargetRadius := 1000.0

# Meanings: 0 = "not attacking"; 1 = "prelude"; 2 = "charging"
var attackStage := 0


func _ready() -> void:
	doCircle()


func processAI(delta: float) -> void:
	match state:
		states.CIRCLE:
			processCircle(delta)

		states.WAIT:
			processWait(delta)

		states.ATTACK:
			processAttack(delta)


func doCircle() -> void:
	state = states.CIRCLE
	numCircles += 1
	circleTargetRadius = RNG.uniform(400, 1000)
	circleTargetAngle = RNG.uniform(0, 2*PI)	


func doAttack() -> void:
	speed = 0
	state = states.ATTACK
	if !G.gs.lighthouse.isDead:
		look_at(Vector2(0,0))


func doWait() -> void:
	state = states.WAIT
	waitTime = RNG.uniform(2.0, 10.0)
	if !G.gs.lighthouse.isDead:
		look_at(Vector2(0,0))


func decideWhatToDo() -> void:
	if !G.gs.lighthouse.isDead && RNG.bernoulli(numCircles * 0.2):
		doAttack()
	elif RNG.flipCoin():
		doCircle()
	else:
		doWait()


# Lighhouse is always on the origin, which simplifies things a bit here.
func processCircle(delta: float) -> void:
	var dest := polar2cartesian(circleTargetRadius, circleTargetAngle)

	if dest.distance_squared_to(position) < ARRIVAL_EPSILON:
		decideWhatToDo()
		return

	var currPolarPos := cartesian2polar(position.x, position.y)
	var currRadius := currPolarPos.x
	var currAngle := currPolarPos.y
	
	var deltaRadius := circleTargetRadius - currRadius
	var deltaAngle := circleTargetAngle - currAngle
	
	while deltaAngle < 0:
		deltaAngle += 2*PI

	while deltaAngle >= 2*PI:
		deltaAngle -= 2*PI

	var target := polar2cartesian(
		currRadius + deltaRadius * delta * 5,
		currAngle + deltaAngle * delta * 2*PI/5
	)

	var vel = (target - position).normalized() * delta * speed
	moveAndCollide(vel)


func processWait(delta: float) -> void:
	waitTime -= delta
	if waitTime <= 0.0:
		decideWhatToDo()


func processAttack(delta: float) -> void:
	if attackStage == 1:
		return

	if attackStage == 0:
		attackStage = 1
		$Sprite.self_modulate = "#EE1111"
		for i in range(7):
			SM.playUFO1()
			yield(get_tree().create_timer(2.0/(i+1)), "timeout")
			if G.gs.lighthouse.isDead:
				attackStage = 0
				decideWhatToDo()
				return
		attackStage = 2

	speed += ATTACK_ACCELERATION * delta
	speed = min(speed, MAX_ATTACK_SPEED)
	
	var lh = G.gs.lighthouse
	var vel = (lh.global_position - global_position).normalized()
	vel *= speed
	moveAndCollide(vel)


func getCollisionDamage() -> float:
	return 100.0
