extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Vision
@onready var ray_cast_left: RayCast2D = $Node2D/RayCast2DLeft
@onready var ray_cast_right: RayCast2D = $Node2D/RayCast2DRight

const SPEED = 100.0
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
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	bomb = body
	bomb_position = bomb.position
	has_target = true

func move_towards_bomb(_delta: float) -> void:
	direction = sign(bomb_position.x - position.x)
	velocity.x = direction * SPEED

	if abs(bomb_position.x - position.x) < THRESHOLD:
		velocity = Vector2.ZERO
		if has_target:
			blow_fuse()

func update_animation():
	if health > 0 and !exploded:
			if velocity.y > 0 and !is_on_floor():
				if sprite.animation != "fall":
					sprite.play("fall")
			elif velocity.x != 0:
				sprite.play("run")
			elif sprite.animation != "blow": 
				sprite.play("idle")
	elif exploded:
		if health != 0:
			sprite.play("hit")
			await sprite.animation_finished
			exploded = false
		elif health == 0:
			sprite.play("dead hit")
			await sprite.animation_finished
			exploded = false
	
	if is_on_floor() and health == 0:
		if sprite.animation != "dead":
			sprite.play("dead")
	
	if direction > 0:
		sprite.flip_h = true
		print(velocity.x)
	elif direction < 0:
		sprite.flip_h = false
	
	if ray_cast_right.is_colliding():
			sprite.flip_h = true
	if ray_cast_left.is_colliding():
			sprite.flip_h = false
	
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "blow":
		bomb.fuse = false
		sprite.play("idle")

func blow_fuse():
	if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
		sprite.play("blow")
		has_target = false
