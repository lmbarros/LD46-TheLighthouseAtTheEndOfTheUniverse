extends KinematicBody2D

# Top speed in pixels/second.
const TOP_SPEED = 300

var maxHealth: float = 25.0

# Health. Player dies if <= 0.0.
var health: float = maxHealth

# Current velocity
var velocity = Vector2(0, 0)

# Is the player dead?
var isDead = false

onready var _bulletClass = preload("res://bullets/WeakBullet.tscn")

func _process(delta: float) -> void:
	if isDead:
		return

	_processMove(delta)
	_processFire()


func _processMove(delta: float) -> void:
	velocity = Vector2(
		Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft"),
		Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp"))

	# If using keys, diagonals will be [1, 1]. Clamp to unit vector.
	if velocity.length_squared() > 1.0:
		velocity = velocity.normalized()

	velocity *= TOP_SPEED

	if velocity.length_squared() > 0:
		rotation = velocity.angle()

	var col := move_and_collide(velocity * delta)
	if col != null:
		var target := col.collider
		if target.is_in_group("enemies"):
			sufferDamage(target.getCollisionDamage())
			target.commonDie()


func _processFire() -> void:
	if Input.is_action_just_pressed("fire"):
		var bullet = _bulletClass.instance()
		bullet.fire(self)
		SM.playShot1()


func getSpeed() -> float:
	return velocity.length()


# Suffers damage, maybe dies.
func sufferDamage(damage: float) -> void:
	health -= damage
	health = max(health, 0.0)

	if health <= 0:
		die()


# Dies. Triggers game over.
func die() -> void:
	G.addSmallExplosion(global_position)
	isDead = true
	visible = false
	collision_layer = 0
	collision_mask = 0
	G.gameOver()
