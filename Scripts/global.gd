extends Node

# The shrunk character node itself - includes all of its children
var character: Node3D

# A dictionary containing all of the nodes that make up the shrunk character 
# node
var cosmetics_enabled: Dictionary # {"Body": "Body02", "Hair": "Hair01", etc.}
