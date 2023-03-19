extends Node3D

var body_material: StandardMaterial3D = load("res://Materials/Body_Material.tres")
var hair_material: StandardMaterial3D = load("res://Materials/Hair_Material.tres")
var pants_material: StandardMaterial3D = load("res://Materials/Pants_Material.tres")

@onready var hair_parent: Node3D = $CharacterCreationDemo/metarig/Skeleton3D/Hair
@onready var hair_label: Label = $"../Character Editor/VBoxContainer/Hair/Label"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_color_color_changed(color):
	body_material.albedo_color = color


func _on_hair_color_color_changed(color):
	hair_material.albedo_color = color


func _on_pants_color_color_changed(color):
	pants_material.albedo_color = color


func _on_hair_button_left_pressed():
	var hair_children := hair_parent.get_children()
	for i in hair_children.size():
		if hair_children[i].visible:
			if i == 0:
				hair_children[hair_children.size() - 1].show()
				hair_children[i].hide()
				hair_label.text = hair_children[hair_children.size() - 1].name
				break
			else:
				hair_children[i-1].show()
				hair_children[i].hide()
				hair_label.text = hair_children[i-1].get_name()
				break


func _on_hair_button_right_pressed():
	var hair_children := hair_parent.get_children()
	for i in hair_children.size():
		if hair_children[i].visible:
			if hair_children.size() - 1 == i:
				hair_children[0].show()
				hair_children[i].hide()
				hair_label.text = hair_children[0].name
				break
			else:
				hair_children[i+1].show()
				hair_children[i].hide()
				hair_label.text = hair_children[i+1].get_name()
				break
