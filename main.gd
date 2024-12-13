extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD/Dev.text = "Rotation: " + str($Player.rotation_degrees) + "\n" \
	+ "Rotating to: " + str($Player.rotating_to) + "\n" \
	+ "Player Main Position: " + str($Player.position) + "\n" \
	+ "Player Anchor 1 Position" + str($Player/Anchors/RotationAnchor1.position) + "\n" \
	+ "Player Anchor 2 Position" + str($Player/Anchors/RotationAnchor2.position) + "\n" \
	+ "Player Sprite Position: " + str($Player/"I-block".position)
