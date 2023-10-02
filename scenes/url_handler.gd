extends RichTextLabel

func _ready():
	connect("meta_clicked", Callable(self,"_on_link_pressed"))
	
func _on_link_pressed(meta):
	OS.shell_open(meta)
