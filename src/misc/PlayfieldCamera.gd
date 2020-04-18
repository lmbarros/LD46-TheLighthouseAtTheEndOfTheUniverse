extends Camera2D

const MIN_ZOOM := 1.2
const MAX_ZOOM := 3.5

const MIN_ZOOM_SPEED := 0
const MAX_ZOOM_SPEED := 300

const ZOOM_DECREASE_SPEED := 0.8
const ZOOM_INCREASE_SPEED := ZOOM_DECREASE_SPEED * 3.0

const ZOOM_EPSILON = 0.05

var _targetZoom := MIN_ZOOM
var _zoom := _targetZoom

func _process(delta: float) -> void:
	var speed = G.gs.player.getSpeed()

	_targetZoom = lerp(MIN_ZOOM, MAX_ZOOM,
		speed / (MAX_ZOOM_SPEED - MIN_ZOOM_SPEED))

	_targetZoom = clamp(_targetZoom, MIN_ZOOM, MAX_ZOOM)

	if _targetZoom < _zoom:
		_zoom -= ZOOM_DECREASE_SPEED * delta
	elif _targetZoom > _zoom:
		_zoom += ZOOM_INCREASE_SPEED * delta

	_zoom = clamp(_zoom, MIN_ZOOM, MAX_ZOOM)

	if abs(_targetZoom - zoom.x) >= ZOOM_EPSILON:
		zoom = Vector2(_zoom, _zoom)
