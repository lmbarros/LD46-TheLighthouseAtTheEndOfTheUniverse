extends "res://characters/BaseEnemy.gd"

# Time in seconds before attack
var waitTime := 6.5

enum states { WAIT, ATTACK }

var state = states.WAIT

# Acceleration when attacking (no speed limit!)
const ATTACK_ACCELERATION = 50

func processAI(delta: float) -> void:
	match state:
		states.WAIT:
			_processWait(delta)

		states.ATTACK:
			_processAttack(delta)


func _processWait(delta: float) -> void:
	waitTime -= delta
	if waitTime < 0.0:
		speed = 0.0
		state = states.ATTACK


func _processAttack(delta: float) -> void:
	speed += ATTACK_ACCELERATION * delta
	var lh = G.gs.lighthouse
	var vel = (lh.global_position - global_position).normalized()
	vel *= speed
	moveAndCollide(vel)


func getCollisionDamage() -> float:
	return 100.0
