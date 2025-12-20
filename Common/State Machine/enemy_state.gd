extends State
class_name EnemyState

@export_category("Connecting States")
@export var idle_state: EnemyState
@export var moving_state: EnemyState
@export var attack_state: EnemyState
@export var die_state: EnemyState

var Char: Enemy
