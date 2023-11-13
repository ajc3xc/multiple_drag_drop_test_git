extends Node2D

var draggable = false
var is_inside_dropable = false
#checks if object was initialized inside of a node
var just_placed = true
var body_prev #previous body the object was in
var body_cur #current body the object is in
var offset: Vector2
var initialPos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable: #ensure mouse is inside body before continuing
		if Input.is_action_just_pressed("left_click"): #check if object was selected
			initialPos = global_position #store initial position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("left_click"): #snap to cursor while still being clicked
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("left_click"):
			global.is_dragging = false
			print("!")
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self, "position", body_cur.position,0.2).set_ease(Tween.EASE_OUT)
				
				#free up previous body, set current body to previous
				#that way it can be freed up if the object moves to another body
				body_prev.has_object = false
				body_cur.has_object = true
				body_prev = body_cur
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
		

#check if mouse is held down on object
func _on_area_2d_mouse_entered():
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05) #make it a bit bigger if being 'selected'

#check if mouse is no longer held down on object
func _on_area_2d_mouse_exited():
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1,1)


#called when sprite is in dropable area
func _on_area_2d_body_entered(body):
	print(body.has_object)
	if body.is_in_group('dropable'):
		#initialize which bodies are filled and not filled when starting program
		#WARNING: do not initialize two objects in the same place
		if just_placed:
			body.has_object = true
			just_placed = false
			body_prev = body
			body.modulate = Color(Color.WHITE, 1)
		#ensure another body is not inside
		elif not body.has_object:
			is_inside_dropable = true
			body.modulate = Color(Color.REBECCA_PURPLE, 1) #change color and opacity
			body_cur = body

#called when sprite no longer in dropable area
func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = false 
		body.modulate = Color(Color.WHITE, 1)
