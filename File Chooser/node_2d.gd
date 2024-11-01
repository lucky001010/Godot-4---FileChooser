extends Control

var current_file = ""
var current_format = "txt"

func _ready():
	$OpenButton.connect("pressed", Callable(self, "_on_open_pressed"))
	$SaveButton.connect("pressed", Callable(self, "_on_save_pressed"))
	$CreateButton.connect("pressed", Callable(self, "_on_create_pressed"))
	$JsonButton.connect("pressed", Callable(self, "_on_json_pressed"))
	$TxtButton.connect("pressed", Callable(self, "_on_txt_pressed"))
	
	# Устанавливаем цвета кнопок
	$CreateButton.add_theme_color_override("font_color", Color.RED)
	$JsonButton.add_theme_color_override("font_color", Color.YELLOW)
	$TxtButton.add_theme_color_override("font_color", Color.GREEN)

func _on_open_pressed():
	var file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.add_filter("*.txt ; Text files")
	file_dialog.add_filter("*.json ; JSON files")
	
	file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
	
	add_child(file_dialog)
	file_dialog.popup_centered(Vector2(800, 600))

func _on_file_selected(path):
	current_file = path
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	$TextEdit.text = content
	file.close()
	current_format = path.get_extension()

func _on_save_pressed():
	if current_file == "":
		_show_save_dialog()
	else:
		_save_file(current_file)

func _on_create_pressed():
	current_file = ""
	$TextEdit.text = ""
	_show_save_dialog()

func _on_json_pressed():
	current_format = "json"

func _on_txt_pressed():
	current_format = "txt"

func _show_save_dialog():
	var file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.add_filter("*." + current_format + " ; " + current_format.to_upper() + " files")
	
	file_dialog.connect("file_selected", Callable(self, "_on_save_file_selected"))
	
	add_child(file_dialog)
	file_dialog.popup_centered(Vector2(800, 600))

func _on_save_file_selected(path):
	if not path.get_extension() == current_format:
		path += "." + current_format
	_save_file(path)

func _save_file(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string($TextEdit.text)
	file.close()
	current_file = path
