extends KinematicBody2D

# Top speed in pixels/second.
const TOP_SPEED = 300

# Hit points. Player dies if <= 0.0.
var _hp: float = 10.0

onready var _bulletClass = preload("res://bullets/WeakBullet.tscn")

func _process(_delta: float) -> void:
	_processMove()
	_processFire()


func _processMove() -> void:
	var velocity := Vector2(
		Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft"),
		Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp"))

	# If using keys, diagonals will be [1, 1]. Clamp to unit vector.
	if velocity.length_squared() > 1.0:
		velocity = velocity.normalized()

	# No need to multiply by delta (this is implied by move_and_slide)
	velocity *= TOP_SPEED

	if velocity.length_squared() > 0:
		rotation = velocity.angle()

	move_and_slide(velocity)


func _processFire() -> void:
	if Input.is_action_just_pressed("fire"):
		var bullet = _bulletClass.instance()
		bullet.fire(self)
