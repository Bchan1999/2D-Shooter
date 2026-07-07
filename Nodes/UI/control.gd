extends Control

var current_box
var list_of_boxes : Array

func _ready():
	self.get_children()
	#print(self.get_children())
	var i = 0
	while (i < self.get_children().size()):
		#print(self.get_child(i))
		if (self.get_child(i).has_method('highlight_box')):
			list_of_boxes.append(self.get_child(i))
		i = 1 + i
	
	print(list_of_boxes)
