extends Node2D


var console = null

func _ready():
	var consoles = get_tree().get_nodes_in_group("Console")
	add_to_group("Scriptable")
	
	if consoles.size() > 0:
		console = consoles[0]

		console.connect("delete_command", self, "_delete_command")
		console.connect("color_command", self, "_color_command")
		console.connect("move_command", self, "_move_command")
		console.connect("copy_command", self, "_copy_command")



func _delete_command(id):
	if id == name:
		get_parent().remove_child(self)
		console.out("%s was deleted"%[id])
	
func _color_command(id, color):
	if id == name:
		var sprite = get_node("Sprite")
		if sprite:
			if color == "red":
				sprite.modulate = Color(1, 0.2, 0.2, 1)
				console.out("%s changed to %s"%[id, color])
			if color == "green":
				sprite.modulate = Color(0.2, 1, 0.2, 1)
				console.out("%s changed to %s"%[id, color])
			if color == "blue":
				sprite.modulate = Color(0.2, 0.2, 1, 1)
				console.out("%s changed to %s"%[id, color])
			if color == "black":
				sprite.modulate = Color(0.2, 0.2, 0.2, 1)
				console.out("%s changed to %s"%[id, color])

	
func _move_command(id, x, y):
	if id == name:
		position.x = position.x + int(x)
		position.y = position.y + int(y)
	
func _copy_command(id):
	if id == name:
		#we check for other copies
		var scriptable = get_tree().get_nodes_in_group("Scriptable")
		var nCopies = 0
		var lastCopyPos = position
		
		for s in scriptable:
			var string = ""
			if s.name.begins_with(name):
				if s.name.length() > name.length() and s.name[name.length()] == "_":
					var nc = int(s.name.substr(name.length() + 1, s.name.length() - name.length() - 1))
					if nc > nCopies:
						nCopies = nc
						lastCopyPos = s.position
		
		var new = duplicate()
		
		nCopies = nCopies + 1
		new.name = name + "_" + String(nCopies)
		new.position = lastCopyPos - Vector2(100, 100)
		get_parent().add_child(new)
