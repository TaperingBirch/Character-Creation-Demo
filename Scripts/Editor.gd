extends Node3D

# Hair-related variables
@onready var hair_parent: Node3D = $CharacterCreationDemo/metarig/Skeleton3D/Hair
@onready var hair_label: Label = $"../Character Editor/VBoxContainer/Hair/Label"
@onready var hair_color_picker: ColorPickerButton = $"../Character Editor/VBoxContainer/Hair/Hair Color"
var hair_material: StandardMaterial3D = load("res://Resources/Materials/Hair_Material.tres")

# Body-related variables
@onready var body_parent: Node3D = $CharacterCreationDemo/metarig/Skeleton3D/Body
@onready var body_label: Label = $"../Character Editor/VBoxContainer/Body/Label"
@onready var body_color_picker: ColorPickerButton = $"../Character Editor/VBoxContainer/Body/Body Color"
var body_material: StandardMaterial3D = load("res://Resources/Materials/Body_Material.tres")

# Pants-related variables
var pants_parent_name: String = "Pants"
var pants_parent_list: Array[Node]
@onready var pants_label: Label = $"../Character Editor/VBoxContainer/Pants/Label"
@onready var pants_color_picker: ColorPickerButton = $"../Character Editor/VBoxContainer/Pants/Pants Color"
var pants_material: StandardMaterial3D = load("res://Resources/Materials/Pants_Material.tres")

# Character nodes not related to any cosmetic item in particular
@onready var skeleton: Skeleton3D = $CharacterCreationDemo/metarig/Skeleton3D
@onready var character_node: Node3D = $CharacterCreationDemo
var cosmetic_items: Dictionary = {} # {"Body": "Body02", "Hair": "Hair01", etc.}

# Called when the node enters the scene tree for the first time.
func _ready():
	# If the save dictionary has been build, show and hide the cosmetic items in
	# the editor from the dictionary accordingly
	if Global.cosmetics_enabled.keys().size() > 0:
		for key in Global.cosmetics_enabled.keys():
			enable_from_dict(skeleton, key)

# Builds an array of two duplicate pants parent nodes when the scene opens so we
# don't have to do it ourselves
	for n in body_parent.get_children():
		for o in n.get_children():
			if o.get_name() == pants_parent_name:
				pants_parent_list.append(o)

	# Makes sure the color pickers match the colors of the materials' albedo 
	# color when the scene opens
	hair_color_picker.color = hair_material.albedo_color
	body_color_picker.color = body_material.albedo_color
	pants_color_picker.color = pants_material.albedo_color

	# Makes sure the labels match the names of the different cosmetic items when
	# the scene opens
	reset_edit_label(hair_label, hair_parent)
	reset_edit_label(body_label, body_parent)
	reset_edit_label_dependent(pants_label, body_parent, pants_parent_name)


func _on_body_color_color_changed(color):
	body_material.albedo_color = color

func _on_hair_color_color_changed(color):
	hair_material.albedo_color = color

func _on_pants_color_color_changed(color):
	pants_material.albedo_color = color


func _on_hair_button_left_pressed():
	iterate_item_left(hair_parent.get_children(), hair_label)

func _on_hair_button_right_pressed():
	iterate_item_right(hair_parent.get_children(), hair_label)


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
	update_dependent_item(body_node.get_children(), "Pants", pants_label.text)

func _on_body_button_right_pressed():
	var body_children := body_parent.get_children()
	var body_node: Node
	iterate_item_right(body_children, body_label)
	for n in body_children:
		if n.visible:
			body_node = n
	update_dependent_item(body_node.get_children(), "Pants", pants_label.text)


func _on_save_exit_pressed():
	shrink(skeleton)
	save()
	get_tree().change_scene_to_file("res://Scenes/save_demo.tscn")

# Searches for the first(which should also be only) visible child of parent and
# sets the label text to the name of that visible child
func reset_edit_label(label:Label, parent:Node):
	for n in parent.get_children():
		if n.visible:
			label.text = n.get_name()
			break

# This function is similar to reset_edit_label() in that it does the same thing,
# except for cosmetics that rely on other cosmetics, like pants(which relies on
# body)
func reset_edit_label_dependent(label:Label, independent_item_parent:Node, category:String):
	# Searches for the first(which should also be only) visible child of
	# grandparent
	for n in independent_item_parent.get_children():
		if n.visible:
			# Once found, it's children are searched for any node with the same
			# name as category(eg. "Pants")
			for o in n.get_children():
				if o.get_name() == category:
					# The rest is the same as reset_edit_label()
					for d in o.get_children():
						if d.visible:
							label.text = d.get_name()
							break


func iterate_item_right(children:Array[Node], label:Label):
	# Search for first(and hopefully only) visible child
	for i in children.size():
		if children[i].visible:
			# If that child is the last element in the array, hide it and show
			# the first element in the array
			if children.size() - 1 == i:
				children[0].show()
				children[i].hide()
				label.text = children[0].name
				break
			# Otherwise, hide it and show the next element in the array
			else:
				children[i+1].show()
				children[i].hide()
				label.text = children[i+1].get_name()
				break

func iterate_item_left(children:Array[Node], label:Label):
	# Search for first(and hopefully only) visible child
	for i in children.size():
		if children[i].visible:
			# If that child is the first element in the array, hide it and show
			# the last element in the array
			if i == 0:
				children[children.size() - 1].show()
				children[i].hide()
				label.text = children[children.size() - 1].name
				break
			# Otherwise, hide it and show the previous element in the array
			else:
				children[i-1].show()
				children[i].hide()
				label.text = children[i-1].get_name()
				break

# This is called when a cosmetic has just been changed and also contains
# dependent cosmetics
func update_dependent_item(children:Array[Node], item_category:String, item_name:String):
	# Search the children array for the node with the same name as item_category
	var item_siblings: Array[Node]
	for n in children:
		if n.get_name() == item_category:
			# Then search the children of that node and show the node with the 
			# same name as item_name and hide everything else
			item_siblings = n.get_children()
			for i in item_siblings.size():
				if item_siblings[i].get_name() == item_name && item_siblings[i].visible:
					return
				elif item_siblings[i].get_name() == item_name && !item_siblings[i].visible:
					item_siblings[i].show()
				elif item_siblings[i].get_name() != item_name && item_siblings[i].visible:
					item_siblings[i].hide()

# Recursive function that deletes every hidden node which is a child, 
# grandchild, etc. of parent
func shrink(parent:Node):
	var roots := parent.get_children()
	for i in roots:
		if !i.visible:
			i.free()
		elif i.get_child_count() > 0:
			shrink(i)

# Saves the now shrunk node tree as a variable in the Global autoload singleton,
# as well as a dictionary(Also in the Global autoload singleton) which can be
# put into a save file, read and shrunk when the game loads up, and/or just read
# when the character editor is opened
func save():
	character_node.get_parent().remove_child(character_node)
	Global.character = character_node
	build_save_dict(skeleton)
	Global.cosmetics_enabled = cosmetic_items

func build_save_dict(grandparent:Node):
	# Save all of the grandchildren to the dictionary with the key being the 
	# name of the parent of said grandchild
	for parent in grandparent.get_children():
		var child: Node = parent.get_child(0)
		cosmetic_items[parent.get_name()] = child.get_name()
		# If the grandchild has children if it's own, call this function again 
		# with the grandparent being the grandchild
		if child.get_child_count() > 0:
			build_save_dict(child)

# Recursive function which shows all of the cosmetics in cosmetic_items and
# hides the rest
func enable_from_dict(parent:Node, anchor:String):
	# Search for the child of parent with a name that matches anchor(anchor will
	# be something like "Pants" or "Hair")
	for node in parent.get_children():
		if node.get_name() == anchor:
			# Search the children of that anchor node for the one named in the 
			# save dictionary, and hide the node unless it matches
			for child in node.get_children():
				if child.get_name() == Global.cosmetics_enabled[anchor]:
					child.show()
				else:
					child.hide()
		# If the node has children, call this function with the node as the 
		# parent
		if node.get_child_count() > 0:
			enable_from_dict(node, anchor)
