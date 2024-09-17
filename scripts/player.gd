extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const JUMP_VELOCITY = -400.0

var SPEED = 130.0
var direction = 0
var bomb_scene = preload("res://scenes/bomb.tscn")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation()

func _process(_delta):
	if Input.is_action_just_released("bomb"):
		throw_projectile()

func throw_projectile():
	var bomb = bomb_scene.instantiate()
	bomb.position = global_position
	get_parent().add_child(bomb)
	
func update_animation():
	if is_on_floor():
		if direction == 0:
			if sprite.animation != "idle":
				sprite.play("idle")
		else:
			if sprite.animation != "run":
				sprite.play("run")
	else:
		if velocity.y < 0:
			if sprite.animation != "jump":
				sprite.play("jump")
		else:
			if sprite.animation != "fall":
				sprite.play("fall")
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
