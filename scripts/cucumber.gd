extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCast2DLeft
@onready var ray_cast_right: RayCast2D = $RayCast2DRight


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var direction = -1

func _physics_process(delta: float) -> void:
	
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if is_on_floor():
		if direction == 0:
			if sprite.animation != "idle":
				sprite.play("idle")
		else:
			if sprite.animation != "run":
				sprite.play("run")
	if direction > 0:
		sprite.flip_h = true
	elif direction < 0:
		sprite.flip_h = false
