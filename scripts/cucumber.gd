extends CharacterBody2D
class_name Explodable

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Vision

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const THRESHOLD = 40

var bomb : RigidBody2D = null
var direction = 0
var bomb_position: Vector2 = Vector2.ZERO
var has_target: bool = false
var exploded: bool = false
var dead: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if exploded == true:
		return

	if has_target:
		move_towards_bomb(delta)

	move_and_slide()
	update_animation()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Bomb")
	bomb = body
	bomb_position = bomb.position
	has_target = true

func move_towards_bomb(_delta: float) -> void:
	var direction_bomb = (bomb_position - position).normalized()
	velocity.x = direction_bomb.x * SPEED
	if position.distance_to(bomb_position) < THRESHOLD:
		has_target = false
		velocity = Vector2.ZERO
		sprite.play("blow")
func update_animation():
	if dead == false:
			if velocity.y > 0:
				if sprite.animation != "fall":
					sprite.play("fall") 
			else:
				if velocity.x != 0:
					sprite.play("run")
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "blow":
		bomb.fuse = false
		sprite.play("idle")
	
