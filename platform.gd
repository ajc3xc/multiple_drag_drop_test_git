extends StaticBody2D

#used to track whether or not an object is in the body
var has_object = false

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(Color.WHITE, 1) #makes object semi transparent when not inside it


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#makes droppable area visible only if being dragged
	if global.is_dragging:
		visible = true
	else:
		visible = false 

