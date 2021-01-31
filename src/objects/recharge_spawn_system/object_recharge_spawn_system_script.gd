extends Node2D


export (NodePath) var spawn_points
export (PackedScene) var recharge
export (bool) var test_mode = false
export (int) var total_recharges_on_screen = 3

var is_spawning = false
var instaced_spawn_points
var total_spawn_points = 0
var last_spawn_point


func _ready():
	var _start_spawn_recharges_signal = Events.connect("start_spawn_recharges", self, "_on_Start_spawn_recharges")
	instaced_spawn_points = get_node(spawn_points)
	total_spawn_points = instaced_spawn_points.get_child_count()
	if test_mode:
		is_spawning = true


func _physics_process(_delta):
	if is_spawning:
		if get_child_count() <= total_recharges_on_screen:
			do_spawn()


func do_spawn():
	var spawn_point = get_random_spawn_point()
	if last_spawn_point != spawn_point:
		var instaced_recharge = recharge.instance()
		instaced_recharge.global_position = spawn_point.global_position
		add_child(instaced_recharge)
		last_spawn_point = spawn_point
		print("spawning_recharges")


func get_random_spawn_point():
	randomize()
	var spawn_point = instaced_spawn_points.get_child(randi() % total_spawn_points)
	return spawn_point


func _on_Start_spawn_recharges():
	is_spawning = true
