extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Vision
@onready var ray_cast_left: RayCast2D = $Node2D/RayCast2DLeft
@onready var ray_cast_right: RayCast2D = $Node2D/RayCast2DRight

const SPEED = 50.0
const JUMP_VELOCITY = -400.0
const THRESHOLD = 40

var bomb : RigidBody2D = null
var direction = 0
var bomb_position: Vector2 = Vector2.ZERO
var has_target: bool = false
var dead: bool = false
var friction = 20
var exploded = false
var health = 2
var knockback = Vector2(200, -400)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.x = lerpf(velocity.x, 0, friction * delta)
		if abs(velocity.x) < 5:
				velocity.x = 0
	
	if has_target and health > 0:
		move_towards_bomb(delta)

	move_and_slide()
	update_animation()
	
func _on_vision_body_entered(body: Node2D) -> void:
	if has_target and is_instance_valid(body):
		if abs(body.global_position.x - global_position.x) > abs(bomb.global_position.x - global_position.x):
			return
		else:
			pass
	if body != bomb:
		has_target = true
	bomb = body
	bomb_position = bomb.position

func move_towards_bomb(_delta: float) -> void:
	if has_target:
		direction = sign(bomb_position.x - position.x)
		velocity.x = direction * SPEED

	if abs(bomb_position.x - position.x) < THRESHOLD:
		velocity = Vector2.ZERO
		if has_target:
			kick_bomb()

func update_animation():
	if health > 0 and !exploded:
			if velocity.y > 0 and !is_on_floor():
				if sprite.animation != "fall":
					sprite.play("fall")
			elif velocity.x != 0:
				sprite.play("run")
			elif sprite.animation != "kick": 
				sprite.play("idle")
	elif exploded:
		if health > 0:
			sprite.play("hit")
			await sprite.animation_finished
			exploded = false
		elif health <= 0:
			sprite.play("dead hit")
			await sprite.animation_finished
			exploded = false
	
	if is_on_floor() and health == 0:
		if sprite.animation != "dead":
			sprite.play("dead")
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if ray_cast_right.is_colliding():
			sprite.flip_h = false
	if ray_cast_left.is_colliding():
			sprite.flip_h = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "kick":
		sprite.play("idle")

func kick_bomb():
	if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
		sprite.play("kick")
		apply_knockback(bomb)
		has_target = false

func apply_knockback(body: RigidBody2D):
	direction = sign(body.global_position.x - global_position.x)
	body.linear_velocity.x = knockback.x * direction
	body.linear_velocity.y = knockback.y
	body.exploded = true
