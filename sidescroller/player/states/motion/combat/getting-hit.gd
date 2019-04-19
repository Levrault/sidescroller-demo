extends State

onready var stream: Resource = load('res://player/assets/sfx_damage_hit1.wav')


func enter(host: Player) -> void:
	host.get_node('AnimationPlayer').play('GettingHit')
	play_sound(host, stream)
	host.snap_enable = false
	host.velocity.x = host.knockback_force.x * host.look_direction.x * -1
	host.velocity.y = -host.knockback_force.y


func exit(host: Player) -> void:
	host.snap_enable = true


#warning-ignore:unused_argument
func update(host: Player, delta: float) -> void:
	# prevent player from sliding
	if host.velocity.y > 0 and host.is_grounded:
		host.velocity.x = 0


#warning-ignore:unused_argument
func _on_animation_finished(anim_name: String, host: Player) -> void:
	assert anim_name == 'GettingHit'
	emit_signal('finished', 'Previous')