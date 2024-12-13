extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var rotating_to = 0
var rotating_direction = 0
var orig_position
var prep_rotating = false
var is_rotating = false
@onready
var current_anchor = $Anchors/RotationAnchor1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$"I-block".scale = Vector2(1.4, 1.6)
	else:
		$"I-block".scale = Vector2(1.5, 1.5)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#if rotating_to > 0 and rotation_degrees >= 90:
		#rotation_degrees = 90
		#rotating_to = 0
		##position = position - $Anchors/RotationAnchor1.position
		#$"I-block".position = Vector2.ZERO
		#$PlayerCollision.position = Vector2.ZERO
	#elif rotating_to < 0 and rotation_degrees <= 0:
		#rotation_degrees = 0
		#rotating_to = 0
		##position = position - $Anchors/RotationAnchor1.position
		#$"I-block".position = Vector2.ZERO
		#$PlayerCollision.position = Vector2.ZERO

	var rotation_input := Input.get_axis("rotate_left", "rotate_right")
	if rotation_input and not is_rotating:
		rotating_direction = rotation_input
		rotating_to = fmod(rotation_degrees + 180 + rotation_input * 90, 360)
		var next_anchor = get_furthest_anchor(1)
		if next_anchor != current_anchor:
			$"I-block".position += current_anchor.global_position - next_anchor.global_position
			$PlayerCollision.position += current_anchor.position - next_anchor.position
			position += next_anchor.position - current_anchor.position 
		#is_rotating = true
	
	if is_rotating:
		rotation_degrees = rotation_degrees + rotating_direction
		if absf(rotation_degrees + 180 - rotating_to) < 0.01:
			rotation_degrees = rotating_to - 180
			is_rotating = false

	move_and_slide()
	
func get_furthest_anchor(direction: int) -> Node2D:
	var rightmostX = -9999
	var rightmostY = 9999
	var best_anchor = null
	for anchor: Node2D in $Anchors.get_children():
		if best_anchor == null:
			best_anchor = anchor
		elif anchor.global_position.y - best_anchor.global_position.y > 0:
			best_anchor = anchor
		elif anchor.global_position.y == best_anchor.global_position.y and (anchor.global_position.x - best_anchor.global_position.x) * direction > 0:
			best_anchor = anchor
	return best_anchor
