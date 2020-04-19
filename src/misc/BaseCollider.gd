# Common behavior to most things that collide woth other things
extends KinematicBody2D

class_name BaseCollider


# If true, doesn't process AI
var isDead = false


# Generic processing; do not process AI if dead.
func _process(delta: float) -> void:
	if isDead:
		return

	processAI(delta)


# Common behavior: stop processing and calls custom behavior
func commonDie() -> void:
	# YODO! (You Only Die Once)
	if isDead:
		return
	isDead = true

	G.gs.score += getScore()
	die()


# Move by a given amount. On collision, dies and causes damage to target.
func moveAndCollide(vel: Vector2) -> void:
	rotation = vel.angle()
	var col := move_and_collide(vel)
	
	if col != null:
		var target := col.collider

		if target.has_method("sufferDamage"):
			target.call_deferred("sufferDamage", getCollisionDamage())

		commonDie()


# Override in subclasses if desired.
func processAI(delta: float) -> void:
	pass


# Override in subclasses if desired.
func die():
	queue_free()


# How much damage this causes when colliding with something else. Override
# as needed.
func getCollisionDamage() -> float:
	return 0.0


# Score for killing one of those.
func getScore() -> int:
	return 0
