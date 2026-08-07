extends Node2D

# --- Node references ---
@export var progress_bar: ProgressBar 
@export var day_label: Label 
@export var night_node: CanvasModulate

# --- Config ---
@export var day_duration: float = 10.0    # seconds of daytime
@export var night_duration: float = 5.0   # seconds of nighttime
@export var total_days: int = 5           # how many days before "done"

# --- State ---
enum state { DAY, NIGHT }
var current_state = state.DAY
var current_day: int = 1
var day_timer: Timer
var night_timer: Timer

func _ready() -> void:
	day_timer = Timer.new()
	day_timer.one_shot = true
	day_timer.wait_time = day_duration
	day_timer.timeout.connect(_on_day_finished)
	add_child(day_timer)

	night_timer = Timer.new()
	night_timer.one_shot = true
	night_timer.wait_time = night_duration
	night_timer.timeout.connect(_on_night_finished)
	add_child(night_timer)

	progress_bar.min_value = 0.0
	progress_bar.max_value = 1.0

	_start_day()

func _process(_delta: float) -> void:
	# Progress bar tracks the currently active timer's countdown
	var timer := day_timer if current_state == state.DAY else night_timer
	if not timer.is_stopped():
		var elapsed := timer.wait_time - timer.time_left
		progress_bar.value = elapsed / timer.wait_time

func _start_day() -> void:
	current_state = state.DAY
	_update_label()
	progress_bar.value = 0.0
	day_timer.start()

func _start_night() -> void:
	current_state = state.NIGHT
	_update_label()
	progress_bar.value = 0.0
	night_timer.start()

func _on_day_finished() -> void:
	progress_bar.value = 1.0
	toggle_night()
	_start_night()

func _on_night_finished() -> void:
	if current_day >= total_days:
		_update_label()
		progress_bar.value = 1.0
		return
	current_day += 1
	toggle_night()
	_start_day()

func _update_label() -> void:
	var phase := "Day" if current_state == state.DAY else "Night"
	if current_state == state.NIGHT and current_day >= total_days:
		day_label.text = "Day %d — Finished" % current_day
	else:
		day_label.text = "%s %d / %d" % [phase, current_day, total_days]
		
func toggle_night() -> void:
	if !night_node.visible:
		night_node.visible = true
	else: 
		night_node.visible = false
