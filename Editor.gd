extends Node3D

var body_material: StandardMaterial3D = load("res://Materials/Body_Material.tres")
var hair_material: StandardMaterial3D = load("res://Materials/Hair_Material.tres")
var pants_material: StandardMaterial3D = load("res://Materials/Pants_Material.tres")

@onready var hair_parent: Node3D = $CharacterCreationDemo/metarig/Skeleton3D/Hair
@onready var hair_label: Label = $"../Character Editor/VBoxContainer/Hair/Label"
@onready var hair_color_picker: ColorPickerButton = $"../Character Editor/VBoxContainer/Hair/Hair Color"

@onready var body_parent: Node3D = $CharacterCreationDemo/metarig/Skeleton3D/Body
@onready var body_label: Label = $"../Character Editor/VBoxContainer/Body/Label"
@onready var body_color_picker: ColorPickerButton = $"../Character Editor/VBoxContainer/Body/Body Color"

@onready var pants_label: Label = $"../Character Editor/VBoxContainer/Pants/Label"
@onready var pants_color_picker: ColorPickerButton = $"../Character Editor/VBoxContainer/Pants/Pants Color"
var pants_parent_name: String = "Pants"
var pants_parent_list: Array[Node]


# Called when the node enters the scene tree for the first time.
func _ready():
	for n in body_parent.get_children():
		for o in n.get_children():
			if o.get_name() == pants_parent_name:
				pants_parent_list.append(o)
	
	reset_color_picker(hair_color_picker, hair_material.albedo_color)
	reset_color_picker(body_color_picker, body_material.albedo_color)
	reset_color_picker(pants_color_picker, pants_material.albedo_color)
	
	reset_edit_label(hair_label, hair_parent)
	reset_edit_label(body_label, body_parent)
	reset_edit_label_dependent(pants_label, body_parent, "Pants")


func _on_body_color_color_changed(color):
	body_material.albedo_color = color

func _on_hair_color_color_changed(color):
	hair_material.albedo_color = color

func _on_pants_color_color_changed(color):
	pants_material.albedo_color = color


func _on_hair_button_left_pressed():
	var hair_children := hair_parent.get_children()
	iterate_item_left(hair_children, hair_label)

func _on_hair_button_right_pressed():
	var hair_children := hair_parent.get_children()
	iterate_item_right(hair_children, hair_label)


func _on_pants_button_left_pressed():
	var pants_children: Array[Node]
	for n in pants_parent_list:
		if n.get_parent().visible:
			pants_children = n.get_children()
			
	iterate_item_left(pants_children, pants_label)

func _on_pants_button_right_pressed():
	var pants_children: Array[Node]
	for n in pants_parent_list:
		if n.get_parent().visible:
			pants_children = n.get_children()
			
	iterate_item_right(pants_children, pants_label)

func _on_body_button_left_pressed():
	var body_children := body_parent.get_children()
	var body_node: Node
	iterate_item_left(body_children, body_label)
	for n in body_children:
		if n.visible:
			body_node = n

func _on_body_button_right_pressed():
	var body_children := body_parent.get_children()
	var body_node: Node
	iterate_item_right(body_children, body_label)
	for n in body_children:
		if n.visible:
			body_node = n
	update_dependent_item(body_node.get_children(), "Pants", pants_label.text)


func reset_color_picker(color_picker:ColorPickerButton, color:Color):
	color_picker.color = color

func reset_edit_label(label:Label, parent:Node):
	for n in parent.get_children():
		if n.visible:
			label.text = n.get_name()
			break

func reset_edit_label_dependent(label:Label, item_grandparent:Node, item_category:String):
	for n in item_grandparent.get_children():
		if n.visible:
			for o in n.get_children():
				if o.get_name() == item_category:
					for d in o.get_children():
						if d.visible:
							label.text = d.get_name()
							break


func iterate_item_right(children:Array[Node], label:Label):
	for i in children.size():
		if children[i].visible:
			if children.size() - 1 == i:
				children[0].show()
				children[i].hide()
				label.text = children[0].name
				break
			else:
				children[i+1].show()
				children[i].hide()
				label.text = children[i+1].get_name()
				break

func iterate_item_left(children:Array[Node], label:Label):
	for i in children.size():
		if children[i].visible:
			if i == 0:
				children[children.size() - 1].show()
				children[i].hide()
				label.text = children[children.size() - 1].name
				break
			else:
				children[i-1].show()
				children[i].hide()
				label.text = children[i-1].get_name()
				break

func update_dependent_item(children:Array[Node], item_category:String, item_name:String):
	var item_siblings: Array[Node]
	for n in children:
		if n.get_name() == item_category:
			item_siblings = n.get_children()
			for i in item_siblings.size():
				if item_siblings[i].get_name() == item_name && item_siblings[i].visible:
					return
				elif item_siblings[i].get_name() == item_name && !item_siblings[i].visible:
					item_siblings[i].show()
				elif item_siblings[i].get_name() != item_name && item_siblings[i].visible:
					item_siblings[i].hide()
