#warning-ignore-all:unused_class_variable
extends Character
class_name Player

signal player_position_changed(new_position)
#warning-ignore:unused_signal
signal player_death

# cache
onready var Physics2D: Node2D = $Physics2D
onready var CooldownTimer: Timer = $CooldownTimer

var previous_position: Vector2 = Vector2()


func _ready() -> void:
	# Signals
	$AnimationPlayer.connect('animation_finished', self, '_on_animation_finished')
	CooldownTimer.connect('timeout', self, '_on_cooldown_timeout')
	$Health.connect('take_damage', self, '_on_getting_hit')
	$States/Death/Explosion.connect('exploded', self, '_on_death')
	
	._initialize_state()
	_initialize_interaction()


func _initialize_interaction():
	if get_tree().get_root().has_node('Game/World'):
		for interaction in get_tree().get_root().get_node('Game/World').get_children():
			if interaction is Interaction:
				interaction.connect('interaction', self, '_change_state')


# Delegate the call to theer
func _physics_process(delta: float) -> void:
	current_state.update(self, delta)
	Physics2D.compute_gravity(self, delta)
	if previous_position != position:
		_on_position_changed()


# Connect to Health
func _on_getting_hit(alive: bool, direction: int) -> void:
	look_direction.x = direction
	is_alive = alive
	_change_state('GettingHit')


# Catch input
func _input(event: InputEvent) -> void:
	current_state.handle_input(self, event)


func game_over():
	#warning-ignore:return_value_discarded
	get_tree().change_scene('res://interfaces/GameOverInterface.tscn')


func _on_position_changed():
	previous_position = position
	emit_signal('player_position_changed', position)