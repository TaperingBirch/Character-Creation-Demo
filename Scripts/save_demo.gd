extends Node3D


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Character_Editor.tscn")
