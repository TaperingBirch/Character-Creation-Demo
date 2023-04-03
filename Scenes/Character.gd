extends Node3D


# This is the character node, of which the character autoload singleton will be
# instanced as a child of
func _ready():
	add_child(Global.character)
