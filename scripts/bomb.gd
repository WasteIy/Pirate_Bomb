extends RigidBody2D

@onready var sprite = $AnimatedSprite2D
@onready var explosion: Area2D = $Explosion

var fuse = true

func _process(_delta):
	if fuse == false:
		collision_layer = 16
		sprite.play("bomb_off")

func _on_timer_timeout() -> void:
	if fuse == true:
		sprite.play("explosion")
		bomb_explosion()
		if sprite.animation == "explosion":
			await sprite.animation_finished
			queue_free()

func bomb_explosion():
	explosion.monitoring = true

func _on_explosion_body_entered(body: Node2D) -> void:
	body.exploded = true
	
	
	
