extends Node2D

#const enemy = preload("res://src/actors/enemy_level_3/actor_enemy_level_3.tscn")

export (NodePath) var spawn_points
export (NodePath) var navigation_area
export (PackedScene) var enemy
export (Array, Dictionary) var waves
export (bool) var test_mode = false

var actual_wave = 0
var total_spawned_enemies = 0
var is_spawning = false
var instaced_spawn_points
var instanced_navigation_area
var total_spawn_points = 0
var last_spawn_point


func _ready():
	var _start_spawn_enemies_signal = Events.connect("start_spawn_enemies", self, "_on_Start_spawn_enemies")
	instaced_spawn_points = get_node(spawn_points)
	total_spawn_points = instaced_spawn_points.get_child_count()
	instanced_navigation_area = get_node(navigation_area)
	if test_mode:
		is_spawning = true


func _physics_process(_delta):
	if is_spawning:
		if actual_wave < len(waves):
			if total_spawned_enemies <= waves[actual_wave]["total_enemies"]:
				if get_child_count() < waves[actual_wave]["enemies_on_screen"]:
					do_spawn()
			else:
				actual_wave += 1
				total_spawned_enemies = 0


func do_spawn():
	var spawn_point = get_random_spawn_point()
	if last_spawn_point != spawn_point:
		var instaced_enemy = enemy.instance()
		instaced_enemy.set_navigation_area(instanced_navigation_area)
		instaced_enemy.global_position = spawn_point.global_position
		add_child(instaced_enemy)
		total_spawned_enemies += 1
		last_spawn_point = spawn_point


func get_random_spawn_point():
	randomize()
	var spawn_point = instaced_spawn_points.get_child(randi() % total_spawn_points)
	return spawn_point


func _on_Start_spawn_enemies():
	is_spawning = true
