extends Node2D


export (String) var input_action_trigger
export (bool) var depends_input = false
export (bool) var depends_event = false
export (bool) var needs_input_pressed = false
export (NodePath) var event_trigger
export (Array, NodePath) var events


var instanced_events = []
var pressed_time = 0


func _process(delta):
	if get_child_count() > 0 and not any_events_playing():
		if depends_input:
			if depends_event and not has_node(event_trigger):
				do_input_action(delta)
			elif not depends_event:
				do_input_action(delta)
		elif not depends_input and depends_event and not has_node(event_trigger):
			execute()


func do_input_action(delta):
	if Input.is_action_pressed(input_action_trigger):
		pressed_time += delta
	if Input.is_action_just_released(input_action_trigger) and pressed_time < 0.3 and not needs_input_pressed:
		execute()
		pressed_time = 0
	elif Input.is_action_just_released(input_action_trigger) and pressed_time > 0.3 and needs_input_pressed:
		execute()
		pressed_time = 0

func any_events_playing():
	for event in get_children():
		if not event.is_playing():
			return false
	return true

func execute():
	if get_tree().paused:
		get_tree().paused = false
	if get_child_count() > 0:
		for event in get_children():
			if not event.is_playing():
				event.play()
		queue_free()
		
