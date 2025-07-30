extends Node2D

var workers

func _ready():
	var workers = get_tree().get_nodes_in_group("worker")
