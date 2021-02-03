extends Node2D


export (NodePath) var affected_node


var node
var is_done = false


func _ready():
	node = get_node(affected_node)


func play():
	print("please overload this 'play' function")
