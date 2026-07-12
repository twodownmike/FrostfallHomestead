extends Control

const GameStateScript := preload("res://scripts/GameState.gd")
const BackgroundScript := preload("res://scripts/PolishedBackground.gd")
const SnowOverlayScript := preload("res://scripts/SnowOverlay.gd")
const FONT_FUTURE := preload("res://assets/kenney_ui_pack/Font/Kenney Future.ttf")
const TERRAIN_SNOW := preload("res://assets/map_details/tile_snow.png")
const TERRAIN_SNOW_ROUGH := preload("res://assets/map_details/tile_snow_rough.png")
const TERRAIN_ROAD_HORIZONTAL := preload("res://assets/map_details/tile_road_horizontal.png")
const TERRAIN_ROAD_VERTICAL := preload("res://assets/map_details/tile_road_vertical.png")
const TERRAIN_CLEARING := preload("res://assets/map_details/tile_clearing.png")
const TERRAIN_PINE := preload("res://assets/map_details/tile_pine.png")
const TERRAIN_LOGS := preload("res://assets/map_details/tile_logs.png")
const SPRITE_CITY_HALL_L1 := preload("res://assets/building_upgrades/city_hall_l1.png")
const SPRITE_CITY_HALL_L2 := preload("res://assets/building_upgrades/city_hall_l2.png")
const SPRITE_CITY_HALL_L3 := preload("res://assets/building_upgrades/city_hall_l3.png")
const SPRITE_HUNTERS_LODGE_L1 := preload("res://assets/building_upgrades/hunters_lodge_l1.png")
const SPRITE_HUNTERS_LODGE_L2 := preload("res://assets/building_upgrades/hunters_lodge_l2.png")
const SPRITE_HUNTERS_LODGE_L3 := preload("res://assets/building_upgrades/hunters_lodge_l3.png")
const SPRITE_SAWMILL_L1 := preload("res://assets/building_upgrades/sawmill_l1.png")
const SPRITE_SAWMILL_L2 := preload("res://assets/building_upgrades/sawmill_l2.png")
const SPRITE_SAWMILL_L3 := preload("res://assets/building_upgrades/sawmill_l3.png")
const SPRITE_COAL_MINE_L1 := preload("res://assets/building_upgrades/coal_mine_l1.png")
const SPRITE_COAL_MINE_L2 := preload("res://assets/building_upgrades/coal_mine_l2.png")
const SPRITE_COAL_MINE_L3 := preload("res://assets/building_upgrades/coal_mine_l3.png")
const SPRITE_SHELTERS_L1 := preload("res://assets/building_upgrades/shelters_l1.png")
const SPRITE_SHELTERS_L2 := preload("res://assets/building_upgrades/shelters_l2.png")
const SPRITE_SHELTERS_L3 := preload("res://assets/building_upgrades/shelters_l3.png")
const DETAIL_TIMBER := preload("res://assets/map_details/timber_forest_l1.png")
const DETAIL_STONE := preload("res://assets/map_details/stone_rocks_l1.png")
const DETAIL_HUNTING := preload("res://assets/map_details/hunting_tracks_l1.png")
const DETAIL_CAMP := preload("res://assets/map_details/camp_poi.png")
const DETAIL_CAVE := preload("res://assets/map_details/ice_cave.png")
const DETAIL_OUTPOST := preload("res://assets/map_details/outpost.png")
const DETAIL_QUARRY := preload("res://assets/map_details/quarry_l3.png")
const DETAIL_ORE := preload("res://assets/map_details/ore_mine_l2.png")
const DETAIL_ROCKS := preload("res://assets/map_details/stone_rocks_l1.png")
const DETAIL_BLIND := preload("res://assets/map_details/hunting_blind_l3.png")
const DETAIL_CARCASS := preload("res://assets/map_details/hunting_carcass_l2.png")
const DETAIL_TIMBER_CAMP := preload("res://assets/map_details/timber_camp_l2.png")
const DETAIL_SAWMILL := preload("res://assets/map_details/timber_sawmill_l3.png")
const ICON_HOME := preload("res://assets/kenney_game_icons/PNG/White/2x/home.png")
const ICON_WRENCH := preload("res://assets/kenney_game_icons/PNG/White/2x/wrench.png")
const ICON_TARGET := preload("res://assets/kenney_game_icons/PNG/White/2x/target.png")
const ICON_PLUS := preload("res://assets/kenney_game_icons/PNG/White/2x/plus.png")
const ICON_MINUS := preload("res://assets/kenney_game_icons/PNG/White/2x/minus.png")
const SFX_CLICK := preload("res://assets/kenney_ui_pack/Sounds/click-a.ogg")
const SFX_TAP := preload("res://assets/kenney_ui_pack/Sounds/tap-a.ogg")
const SFX_SWITCH := preload("res://assets/kenney_ui_pack/Sounds/switch-a.ogg")

const TILE_SIZE := 16
const TILE_SCALE := 3
const TILE_PIXEL := TILE_SIZE * TILE_SCALE
const WORLD_COLUMNS := 32
const WORLD_ROWS := 42
const TERRAIN_SNOW_ID := 0
const TERRAIN_SNOW_ROUGH_ID := 1
const TERRAIN_ROAD_HORIZONTAL_ID := 2
const TERRAIN_CLEARING_ID := 3
const TERRAIN_ROAD_VERTICAL_ID := 4
const TERRAIN_PINE_ID := 10
const TERRAIN_LOGS_ID := 70
const BUILDING_TEXTURE_SCALE := 0.54
const DETAIL_TEXTURE_SCALE := 0.68
const KEYBOARD_PAN_STEP := 72
const BUILDING_SPRITES := {
	"cabin": [SPRITE_CITY_HALL_L1, SPRITE_CITY_HALL_L2, SPRITE_CITY_HALL_L3],
	"woodlot": [SPRITE_SAWMILL_L1, SPRITE_SAWMILL_L2, SPRITE_SAWMILL_L3],
	"garden": [SPRITE_HUNTERS_LODGE_L1, SPRITE_HUNTERS_LODGE_L2, SPRITE_HUNTERS_LODGE_L3],
	"well": [SPRITE_SHELTERS_L1, SPRITE_SHELTERS_L2, SPRITE_SHELTERS_L3],
	"workshop": [SPRITE_COAL_MINE_L1, SPRITE_COAL_MINE_L2, SPRITE_COAL_MINE_L3],
	"root_cellar": [DETAIL_ROCKS, DETAIL_ORE, DETAIL_QUARRY],
	"smokehouse": [DETAIL_TIMBER_CAMP, DETAIL_BLIND, DETAIL_SAWMILL],
	"coop": [DETAIL_CAMP, DETAIL_CARCASS, DETAIL_OUTPOST],
}
const RESOURCE_COLORS := {
	"food": Color("#f3b05a"),
	"wood": Color("#9b6a4a"),
	"water": Color("#55bde8"),
	"tools": Color("#d8e0e8"),
	"seed": Color("#90d06f"),
}
const MAP_DETAILS := [
	{"id": "timber_stand", "name": "Frozen Timber Stand", "texture": DETAIL_TIMBER, "cell": Vector2i(5, 5), "size": Vector2(116, 88), "message": "Timber stand marked.", "reward": {"wood": 26}},
	{"id": "stone_outcrop", "name": "Stone Outcrop", "texture": DETAIL_STONE, "cell": Vector2i(26, 5), "size": Vector2(98, 78), "message": "Stone outcrop scouted.", "reward": {"tools": 3}},
	{"id": "hunting_trail", "name": "Hunting Trail", "texture": DETAIL_HUNTING, "cell": Vector2i(9, 18), "size": Vector2(112, 82), "message": "Fresh tracks found near the hunting trail.", "reward": {"food": 22}},
	{"id": "abandoned_camp", "name": "Abandoned Camp", "texture": DETAIL_CAMP, "cell": Vector2i(24, 18), "size": Vector2(118, 86), "message": "Abandoned camp logged.", "reward": {"food": 12, "tools": 2}},
	{"id": "ice_cave", "name": "Ice Cave", "texture": DETAIL_CAVE, "cell": Vector2i(29, 13), "size": Vector2(130, 98), "message": "Ice cave discovered.", "reward": {"water": 26}},
	{"id": "ridge_outpost", "name": "Ridge Outpost", "texture": DETAIL_OUTPOST, "cell": Vector2i(4, 21), "size": Vector2(120, 86), "message": "Ridge outpost marked.", "reward": {"morale": 4, "wood": 12}},
]

var game: GameState
var resource_labels := {}
var resource_chips := {}
var building_rows := {}
var building_buttons := {}
var building_badges := {}
var map_tiles: Array[TextureButton] = []
var map_detail_buttons: Array[TextureButton] = []
var building_positions := {
	"cabin": Vector2i(14, 10),
}
var event_list: VBoxContainer
var objective_list: VBoxContainer
var world_grid: Control
var map_scroll: ScrollContainer
var build_menu_panel: PanelContainer
var goals_menu_panel: PanelContainer
var log_menu_panel: PanelContainer
var placement_layer: Control
var placement_preview: TextureRect
var top_margin: MarginContainer
var right_dock: Control
var quick_actions: Control
var selected_panel: Control
var move_mode_button: Button
var map_status_label: Label
var day_label: Label
var season_label: Label
var workers_label: Label
var power_label: Label
var storm_label: Label
var chapter_label: Label
var selected_title: Label
var selected_detail: Label
var selected_preview: TextureRect
var selected_role: Label
var selected_risk: Label
var selected_output: Label
var condition_bar: ProgressBar
var readiness_bar: ProgressBar
var ability_list: HFlowContainer
var worker_row: HBoxContainer
var morale_bar: ProgressBar
var heat_bar: ProgressBar
var day_progress: ProgressBar
var project_bar: ProgressBar
var project_label: Label
var pause_button: Button
var speed_button: Button
var save_button: Button
var load_button: Button
var selected_building := "cabin"
var ability_rebuild_queued := false
var world_rebuild_queued := false
var move_mode := false
var placing_building_id := ""
var placement_cell := Vector2i.ZERO
var ui_ready := false
var compact_layout := false
var sfx_player: AudioStreamPlayer
var modal_layer: CanvasLayer
var tutorial_panel: PanelContainer
var tutorial_title: Label
var tutorial_body: Label
var choice_panel: PanelContainer
var choice_title: Label
var choice_body: Label
var choice_buttons: VBoxContainer
var end_panel: PanelContainer
var end_title: Label
var end_body: Label
var control_bar: Control

func _ready() -> void:
	randomize()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	game = GameStateScript.new()
	_build_interface()
	resized.connect(_apply_responsive_layout)
	game.changed.connect(_refresh)
	game.choice_requested.connect(_on_choice_requested)
	game.game_ended.connect(_on_game_ended)
	game.tutorial_step.connect(_on_tutorial_step)
	if game.has_save():
		game.set_paused(true)
		_set_status("Welcome back. Press Load to continue, or New for a fresh settlement.")
	else:
		game.start_new_game()
	_refresh()

func _process(delta: float) -> void:
	game.tick(delta)
	if day_progress != null:
		day_progress.value = game.DAY_LENGTH - game.seconds_until_day
	if project_bar != null:
		if game.project_in_progress():
			project_bar.visible = true
			project_label.visible = true
			project_bar.value = game.project_progress() * 100.0
			project_label.text = game.project_status()
		else:
			project_bar.visible = false
			project_label.visible = false

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	if key_event.keycode == KEY_P and placing_building_id == "":
		game.toggle_pause()
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return
	if key_event.keycode == KEY_1:
		game.set_time_scale(1.0)
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return
	if key_event.keycode == KEY_2:
		game.set_time_scale(2.0)
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return
	if key_event.keycode == KEY_3:
		game.set_time_scale(3.0)
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return

	var direction := Vector2i.ZERO
	match key_event.physical_keycode:
		KEY_W, KEY_UP:
			direction = Vector2i.UP
		KEY_S, KEY_DOWN:
			direction = Vector2i.DOWN
		KEY_A, KEY_LEFT:
			direction = Vector2i.LEFT
		KEY_D, KEY_RIGHT:
			direction = Vector2i.RIGHT

	if placing_building_id != "" and direction != Vector2i.ZERO:
		placement_cell = Vector2i(
			clampi(placement_cell.x + direction.x, 0, WORLD_COLUMNS - 1),
			clampi(placement_cell.y + direction.y, 0, WORLD_ROWS - 1)
		)
		_update_placement_preview_for_cell(placement_cell)
		get_viewport().set_input_as_handled()
	elif placing_building_id != "" and (key_event.keycode == KEY_ENTER or key_event.keycode == KEY_KP_ENTER or key_event.keycode == KEY_SPACE):
		_handle_map_cell_pressed(placement_cell)
		get_viewport().set_input_as_handled()
	elif placing_building_id != "" and key_event.keycode == KEY_ESCAPE:
		_cancel_build_placement()
		get_viewport().set_input_as_handled()
	elif key_event.keycode == KEY_ESCAPE and (build_menu_panel.visible or goals_menu_panel.visible or log_menu_panel.visible):
		_hide_overlay_menus()
		get_viewport().set_input_as_handled()
	elif direction != Vector2i.ZERO and map_scroll != null and is_instance_valid(map_scroll):
		var pan_step := KEYBOARD_PAN_STEP * (3 if key_event.shift_pressed else 1)
		map_scroll.scroll_horizontal += direction.x * pan_step
		map_scroll.scroll_vertical += direction.y * pan_step
		get_viewport().set_input_as_handled()

func _build_interface() -> void:
	add_theme_font_override("font", FONT_FUTURE)

	sfx_player = AudioStreamPlayer.new()
	sfx_player.volume_db = -8.0
	add_child(sfx_player)

	var background: Control = BackgroundScript.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var map_surface := _build_map_surface()
	map_surface.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(map_surface)

	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(overlay)

	top_margin = MarginContainer.new()
	top_margin.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_margin.mouse_filter = Control.MOUSE_FILTER_STOP
	top_margin.add_theme_constant_override("margin_left", 18)
	top_margin.add_theme_constant_override("margin_top", 14)
	top_margin.add_theme_constant_override("margin_right", 18)
	overlay.add_child(top_margin)

	var top_stack := VBoxContainer.new()
	top_stack.add_theme_constant_override("separation", 8)
	top_margin.add_child(top_stack)
	top_stack.add_child(_build_top_hud())
	top_stack.add_child(_build_resource_strip())
	top_stack.add_child(_build_control_bar())

	right_dock = _build_right_dock()
	right_dock.mouse_filter = Control.MOUSE_FILTER_STOP
	right_dock.anchor_left = 1.0
	right_dock.anchor_right = 1.0
	right_dock.offset_left = -190
	right_dock.offset_top = 250
	right_dock.offset_right = -18
	right_dock.offset_bottom = 560
	overlay.add_child(right_dock)

	quick_actions = _build_action_bar()
	quick_actions.mouse_filter = Control.MOUSE_FILTER_STOP
	quick_actions.anchor_left = 0.0
	quick_actions.anchor_top = 1.0
	quick_actions.anchor_right = 0.0
	quick_actions.anchor_bottom = 1.0
	quick_actions.offset_left = 18
	quick_actions.offset_top = -92
	quick_actions.offset_right = 720
	quick_actions.offset_bottom = -18
	overlay.add_child(quick_actions)

	selected_panel = _build_selected_inspector()
	selected_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	selected_panel.anchor_left = 0.54
	selected_panel.anchor_top = 1.0
	selected_panel.anchor_right = 0.98
	selected_panel.anchor_bottom = 1.0
	selected_panel.offset_left = 0
	selected_panel.offset_top = -280
	selected_panel.offset_right = -18
	selected_panel.offset_bottom = -18
	overlay.add_child(selected_panel)

	map_status_label = Label.new()
	map_status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_status_label.anchor_left = 0.5
	map_status_label.anchor_right = 0.5
	map_status_label.offset_left = -300
	map_status_label.offset_top = 200
	map_status_label.offset_right = 300
	map_status_label.offset_bottom = 236
	map_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	map_status_label.add_theme_color_override("font_color", Color("#fff1c4"))
	map_status_label.add_theme_font_size_override("font_size", 14)
	map_status_label.add_theme_stylebox_override("normal", _panel_style(Color(0.02, 0.08, 0.12, 0.72), Color(1, 1, 1, 0.18), 8))
	map_status_label.text = "Drag or WASD to explore. P pause · 1/2/3 speed · Build to expand."
	overlay.add_child(map_status_label)

	_build_overlay_menus(overlay)
	_build_modals()
	ui_ready = true
	_apply_responsive_layout()

func _build_top_hud() -> Control:
	var hud := PanelContainer.new()
	hud.add_theme_stylebox_override("panel", _panel_style(Color(0.03, 0.10, 0.17, 0.88), Color(0.68, 0.91, 1.0, 0.36), 8))

	var row := HFlowContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.add_theme_constant_override("v_separation", 6)
	hud.add_child(row)

	var title_box := VBoxContainer.new()
	title_box.custom_minimum_size = Vector2(260, 0)
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title_box)

	var title := Label.new()
	title.text = "Frostfall Homestead"
	title.add_theme_color_override("font_color", Color("#f7fbff"))
	title.add_theme_font_size_override("font_size", 24)
	title_box.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Survive winter. Grow a valley settlement."
	subtitle.add_theme_color_override("font_color", Color("#a9d7e8"))
	subtitle.add_theme_font_size_override("font_size", 12)
	title_box.add_child(subtitle)

	day_label = _make_chip()
	row.add_child(day_label)
	season_label = _make_chip()
	row.add_child(season_label)
	chapter_label = _make_chip()
	chapter_label.custom_minimum_size = Vector2(140, 34)
	row.add_child(chapter_label)
	workers_label = _make_chip()
	row.add_child(workers_label)
	power_label = _make_chip()
	row.add_child(power_label)
	storm_label = _make_chip()
	row.add_child(storm_label)

	day_progress = ProgressBar.new()
	day_progress.min_value = 0
	day_progress.max_value = 20
	day_progress.custom_minimum_size = Vector2(160, 18)
	day_progress.tooltip_text = "Day progress"
	day_progress.add_theme_stylebox_override("background", _meter_background())
	day_progress.add_theme_stylebox_override("fill", _meter_fill(Color("#65c7f0")))
	row.add_child(day_progress)

	return hud

func _build_resource_strip() -> Control:
	var strip := HFlowContainer.new()
	strip.add_theme_constant_override("separation", 8)
	strip.add_theme_constant_override("v_separation", 6)

	for resource_name in ["food", "wood", "water", "tools", "seed"]:
		var chip := PanelContainer.new()
		chip.custom_minimum_size = Vector2(140, 0)
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chip.add_theme_stylebox_override("panel", _panel_style(Color(0.94, 0.99, 1.0, 0.78), Color(1, 1, 1, 0.58), 8))
		resource_chips[resource_name] = chip
		strip.add_child(chip)

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		chip.add_child(row)

		var swatch := ColorRect.new()
		swatch.color = RESOURCE_COLORS[resource_name]
		swatch.custom_minimum_size = Vector2(8, 34)
		row.add_child(swatch)

		var label := Label.new()
		label.add_theme_color_override("font_color", Color("#153247"))
		label.add_theme_font_size_override("font_size", 13)
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		resource_labels[resource_name] = label
		row.add_child(label)

	return strip

func _build_control_bar() -> Control:
	control_bar = HFlowContainer.new()
	control_bar.add_theme_constant_override("separation", 8)
	control_bar.add_theme_constant_override("v_separation", 6)

	pause_button = _make_action_button("Pause", ICON_TARGET, Callable(self, "_on_pause_pressed"), Color("#3a5f7a"))
	pause_button.custom_minimum_size = Vector2(110, 42)
	control_bar.add_child(pause_button)

	speed_button = _make_action_button("1x", ICON_PLUS, Callable(self, "_on_speed_pressed"), Color("#2f6f8a"))
	speed_button.custom_minimum_size = Vector2(90, 42)
	control_bar.add_child(speed_button)

	save_button = _make_action_button("Save", ICON_HOME, Callable(self, "_on_save_pressed"), Color("#356b5f"))
	save_button.custom_minimum_size = Vector2(100, 42)
	control_bar.add_child(save_button)

	load_button = _make_action_button("Load", ICON_HOME, Callable(self, "_on_load_pressed"), Color("#425f75"))
	load_button.custom_minimum_size = Vector2(100, 42)
	control_bar.add_child(load_button)

	var new_game_btn := _make_action_button("New", ICON_PLUS, Callable(self, "_on_new_game_pressed"), Color("#7a4a3a"))
	new_game_btn.custom_minimum_size = Vector2(90, 42)
	control_bar.add_child(new_game_btn)

	project_label = Label.new()
	project_label.add_theme_color_override("font_color", Color("#e8f6ff"))
	project_label.add_theme_font_size_override("font_size", 12)
	project_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	project_label.visible = false
	control_bar.add_child(project_label)

	project_bar = ProgressBar.new()
	project_bar.min_value = 0
	project_bar.max_value = 100
	project_bar.custom_minimum_size = Vector2(160, 22)
	project_bar.show_percentage = true
	project_bar.visible = false
	project_bar.add_theme_stylebox_override("background", _meter_background())
	project_bar.add_theme_stylebox_override("fill", _meter_fill(Color("#f0b35a")))
	control_bar.add_child(project_bar)

	return control_bar
func _build_map_surface() -> Control:
	var panel := Control.new()

	map_scroll = ScrollContainer.new()
	map_scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	map_scroll.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	panel.add_child(map_scroll)

	world_grid = Control.new()
	world_grid.custom_minimum_size = Vector2(WORLD_COLUMNS * TILE_PIXEL, WORLD_ROWS * TILE_PIXEL)
	map_scroll.add_child(world_grid)
	_build_world_grid(world_grid)

	var snow: Control = SnowOverlayScript.new()
	snow.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(snow)

	return panel

func _build_right_dock() -> Control:
	var dock := HFlowContainer.new()
	dock.add_theme_constant_override("separation", 10)
	dock.add_theme_constant_override("v_separation", 10)

	var build_button := _make_action_button("Build", ICON_PLUS, Callable(self, "_toggle_build_menu"), Color("#1f7fab"))
	build_button.custom_minimum_size = Vector2(170, 54)
	dock.add_child(build_button)

	var goals_button := _make_action_button("Goals", ICON_TARGET, Callable(self, "_toggle_goals_menu"), Color("#356b5f"))
	goals_button.custom_minimum_size = Vector2(170, 54)
	dock.add_child(goals_button)

	var log_button := _make_action_button("Log", ICON_HOME, Callable(self, "_toggle_log_menu"), Color("#425f75"))
	log_button.custom_minimum_size = Vector2(170, 54)
	dock.add_child(log_button)

	move_mode_button = _make_action_button("Move", ICON_TARGET, Callable(self, "_toggle_move_mode"), Color("#725f9b"))
	move_mode_button.custom_minimum_size = Vector2(170, 54)
	dock.add_child(move_mode_button)

	return dock

func _apply_responsive_layout() -> void:
	if top_margin == null or right_dock == null or quick_actions == null or selected_panel == null:
		return

	var viewport_size := get_viewport_rect().size
	var compact := viewport_size.x < 980.0
	var portrait := viewport_size.y > viewport_size.x
	var margin := 10 if compact or portrait else 18
	var top_offset := 10 if compact or portrait else 14
	compact_layout = compact or portrait

	top_margin.add_theme_constant_override("margin_left", margin)
	top_margin.add_theme_constant_override("margin_top", top_offset)
	top_margin.add_theme_constant_override("margin_right", margin)

	if compact_layout:
		right_dock.anchor_left = 0.0
		right_dock.anchor_top = 1.0
		right_dock.anchor_right = 1.0
		right_dock.anchor_bottom = 1.0
		right_dock.offset_left = margin
		right_dock.offset_top = -160
		right_dock.offset_right = -margin
		right_dock.offset_bottom = -92

		quick_actions.anchor_left = 0.0
		quick_actions.anchor_top = 1.0
		quick_actions.anchor_right = 1.0
		quick_actions.anchor_bottom = 1.0
		quick_actions.offset_left = margin
		quick_actions.offset_top = -86
		quick_actions.offset_right = -margin
		quick_actions.offset_bottom = -10

		selected_panel.anchor_left = 0.0
		selected_panel.anchor_top = 1.0
		selected_panel.anchor_right = 1.0
		selected_panel.anchor_bottom = 1.0
		selected_panel.offset_left = margin
		selected_panel.offset_top = -460 if portrait else -390
		selected_panel.offset_right = -margin
		selected_panel.offset_bottom = -168

		map_status_label.anchor_left = 0.0
		map_status_label.anchor_right = 1.0
		map_status_label.offset_left = margin
		map_status_label.offset_top = 220
		map_status_label.offset_right = -margin
		map_status_label.offset_bottom = 256
	else:
		right_dock.anchor_left = 1.0
		right_dock.anchor_top = 0.0
		right_dock.anchor_right = 1.0
		right_dock.anchor_bottom = 0.0
		right_dock.offset_left = -190
		right_dock.offset_top = 250
		right_dock.offset_right = -18
		right_dock.offset_bottom = 560

		quick_actions.anchor_left = 0.0
		quick_actions.anchor_top = 1.0
		quick_actions.anchor_right = 0.0
		quick_actions.anchor_bottom = 1.0
		quick_actions.offset_left = 18
		quick_actions.offset_top = -92
		quick_actions.offset_right = 720
		quick_actions.offset_bottom = -18

		selected_panel.anchor_left = 0.52
		selected_panel.anchor_top = 1.0
		selected_panel.anchor_right = 0.98
		selected_panel.anchor_bottom = 1.0
		selected_panel.offset_left = 0
		selected_panel.offset_top = -320
		selected_panel.offset_right = -18
		selected_panel.offset_bottom = -18

		map_status_label.anchor_left = 0.5
		map_status_label.anchor_right = 0.5
		map_status_label.offset_left = -300
		map_status_label.offset_top = 200
		map_status_label.offset_right = 300
		map_status_label.offset_bottom = 236

	_layout_overlay_menus(compact_layout, margin)

func _layout_overlay_menus(compact: bool, margin: int) -> void:
	if build_menu_panel == null or goals_menu_panel == null or log_menu_panel == null:
		return

	for panel in [build_menu_panel, goals_menu_panel, log_menu_panel]:
		panel.anchor_top = 0.0
		panel.anchor_bottom = 0.0
		panel.offset_top = 132 if compact else 150

	if compact:
		for panel in [build_menu_panel, goals_menu_panel, log_menu_panel]:
			panel.anchor_left = 0.0
			panel.anchor_right = 1.0
			panel.offset_left = margin
			panel.offset_right = -margin
			panel.offset_bottom = -176
	else:
		build_menu_panel.anchor_left = 1.0
		build_menu_panel.anchor_right = 1.0
		build_menu_panel.offset_left = -700
		build_menu_panel.offset_right = -210
		build_menu_panel.offset_bottom = 650

		for panel in [goals_menu_panel, log_menu_panel]:
			panel.anchor_left = 1.0
			panel.anchor_right = 1.0
			panel.offset_left = -590
			panel.offset_right = -210
			panel.offset_bottom = 620 if panel == goals_menu_panel else 650

func _build_overlay_menus(overlay: Control) -> void:
	build_menu_panel = _make_overlay_panel("Build")
	build_menu_panel.anchor_left = 1.0
	build_menu_panel.anchor_right = 1.0
	build_menu_panel.offset_left = -700
	build_menu_panel.offset_top = 150
	build_menu_panel.offset_right = -210
	build_menu_panel.offset_bottom = 650
	build_menu_panel.visible = false
	build_menu_panel.z_index = 20
	overlay.add_child(build_menu_panel)

	var build_box: VBoxContainer = build_menu_panel.get_meta("content")
	for building_id in game.building_ids():
		var row := _make_building_row(building_id)
		building_rows[building_id] = row
		build_box.add_child(row["container"])

	goals_menu_panel = _make_overlay_panel("Survival Goals")
	goals_menu_panel.anchor_left = 1.0
	goals_menu_panel.anchor_right = 1.0
	goals_menu_panel.offset_left = -590
	goals_menu_panel.offset_top = 150
	goals_menu_panel.offset_right = -210
	goals_menu_panel.offset_bottom = 620
	goals_menu_panel.visible = false
	goals_menu_panel.z_index = 20
	overlay.add_child(goals_menu_panel)
	objective_list = VBoxContainer.new()
	objective_list.add_theme_constant_override("separation", 6)
	var goals_box: VBoxContainer = goals_menu_panel.get_meta("content")
	goals_box.add_child(objective_list)

	log_menu_panel = _make_overlay_panel("Dispatch Log")
	log_menu_panel.anchor_left = 1.0
	log_menu_panel.anchor_right = 1.0
	log_menu_panel.offset_left = -590
	log_menu_panel.offset_top = 150
	log_menu_panel.offset_right = -210
	log_menu_panel.offset_bottom = 650
	log_menu_panel.visible = false
	log_menu_panel.z_index = 20
	overlay.add_child(log_menu_panel)
	event_list = VBoxContainer.new()
	event_list.add_theme_constant_override("separation", 6)
	var log_box: VBoxContainer = log_menu_panel.get_meta("content")
	log_box.add_child(event_list)

func _make_overlay_panel(title_text: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.95, 0.985, 1.0, 0.99), Color(1, 1, 1, 0.78), 8))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	panel.set_meta("content", box)

	var title := Label.new()
	title.text = title_text
	title.add_theme_color_override("font_color", Color("#153247"))
	title.add_theme_font_size_override("font_size", 22)
	box.add_child(title)

	return panel

func _toggle_build_menu() -> void:
	if placing_building_id != "":
		_cancel_build_placement()
		return
	_toggle_overlay(build_menu_panel)

func _toggle_goals_menu() -> void:
	_toggle_overlay(goals_menu_panel)

func _toggle_log_menu() -> void:
	_toggle_overlay(log_menu_panel)

func _toggle_overlay(panel: Control) -> void:
	var will_show := not panel.visible
	if will_show:
		if placing_building_id != "":
			_cancel_build_placement()
		if move_mode:
			_cancel_move_mode()
	for menu in [build_menu_panel, goals_menu_panel, log_menu_panel]:
		if menu != panel:
			menu.visible = false
	panel.visible = will_show
	if selected_panel != null:
		selected_panel.visible = not panel.visible

func _build_selected_inspector() -> Control:
	var panel := PanelContainer.new()
	panel.clip_contents = true
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.02, 0.08, 0.13, 0.84), Color(0.77, 0.94, 1.0, 0.34), 8))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	box.add_child(header)

	selected_title = Label.new()
	selected_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	selected_title.add_theme_color_override("font_color", Color("#f8fcff"))
	selected_title.add_theme_font_size_override("font_size", 18)
	header.add_child(selected_title)

	selected_detail = Label.new()
	selected_detail.add_theme_color_override("font_color", Color("#bde3f3"))
	selected_detail.add_theme_font_size_override("font_size", 12)
	header.add_child(selected_detail)

	var info_row := HFlowContainer.new()
	info_row.add_theme_constant_override("separation", 12)
	info_row.add_theme_constant_override("v_separation", 6)
	box.add_child(info_row)

	selected_preview = TextureRect.new()
	selected_preview.custom_minimum_size = Vector2(82, 62)
	selected_preview.size = Vector2(82, 62)
	selected_preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	selected_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	selected_preview.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	selected_preview.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	info_row.add_child(selected_preview)

	var text_stack := VBoxContainer.new()
	text_stack.custom_minimum_size = Vector2(210, 0)
	text_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_row.add_child(text_stack)

	selected_role = Label.new()
	selected_role.add_theme_color_override("font_color", Color("#edf9ff"))
	selected_role.add_theme_font_size_override("font_size", 13)
	text_stack.add_child(selected_role)

	selected_output = Label.new()
	selected_output.add_theme_color_override("font_color", Color("#9fd8ed"))
	selected_output.add_theme_font_size_override("font_size", 12)
	text_stack.add_child(selected_output)

	selected_risk = Label.new()
	selected_risk.add_theme_color_override("font_color", Color("#f1c684"))
	selected_risk.add_theme_font_size_override("font_size", 12)
	selected_risk.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_stack.add_child(selected_risk)

	condition_bar = _make_named_meter("Condition", Color("#75d4d0"))
	condition_bar.custom_minimum_size = Vector2(104, 38)
	info_row.add_child(condition_bar)
	readiness_bar = _make_named_meter("Order Ready", Color("#7cc8ff"))
	readiness_bar.custom_minimum_size = Vector2(104, 38)
	info_row.add_child(readiness_bar)

	worker_row = HBoxContainer.new()
	worker_row.add_theme_constant_override("separation", 8)
	box.add_child(worker_row)

	var worker_label := Label.new()
	worker_label.text = "Workers"
	worker_label.add_theme_color_override("font_color", Color("#cfe9f5"))
	worker_label.add_theme_font_size_override("font_size", 13)
	worker_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	worker_row.add_child(worker_label)

	var worker_minus := _make_icon_button(ICON_MINUS, func() -> void:
		_play_sfx(SFX_TAP)
		game.assign_worker(selected_building, -1)
	)
	worker_row.add_child(worker_minus)
	worker_row.set_meta("minus", worker_minus)

	var worker_plus := _make_icon_button(ICON_PLUS, func() -> void:
		_play_sfx(SFX_TAP)
		game.assign_worker(selected_building, 1)
	)
	worker_row.add_child(worker_plus)
	worker_row.set_meta("plus", worker_plus)

	ability_list = HFlowContainer.new()
	ability_list.add_theme_constant_override("separation", 8)
	ability_list.add_theme_constant_override("v_separation", 6)
	box.add_child(ability_list)

	return panel

func _build_action_bar() -> Control:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 10)
	var repair := _make_action_button("Repair Hearth", ICON_WRENCH, func() -> void:
		_play_sfx(SFX_CLICK)
		game.repair_hearth()
	, Color("#176f9c"))
	repair.custom_minimum_size = Vector2(155, 54)
	bar.add_child(repair)
	var expedition := _make_action_button("Expedition", ICON_TARGET, func() -> void:
		_play_sfx(SFX_CLICK)
		game.send_expedition()
	, Color("#2f6b62"))
	expedition.custom_minimum_size = Vector2(145, 54)
	bar.add_child(expedition)

	morale_bar = _make_named_meter("Morale", Color("#77d37b"))
	bar.add_child(morale_bar)
	heat_bar = _make_named_meter("Hearth", Color("#f0a44a"))
	bar.add_child(heat_bar)

	return bar

func _build_world_grid(world_grid: Control) -> void:
	building_buttons.clear()
	building_badges.clear()
	map_tiles.clear()
	map_detail_buttons.clear()
	placement_layer = null
	placement_preview = null
	var terrain := _make_terrain()

	for y in range(WORLD_ROWS):
		for x in range(WORLD_COLUMNS):
			var position := Vector2i(x, y)
			var tile := TextureButton.new()
			tile.position = Vector2(x * TILE_PIXEL, y * TILE_PIXEL)
			tile.custom_minimum_size = Vector2(TILE_PIXEL, TILE_PIXEL)
			tile.size = Vector2(TILE_PIXEL, TILE_PIXEL)
			tile.stretch_mode = TextureButton.STRETCH_SCALE
			tile.texture_normal = _terrain_texture(terrain[y][x])
			var base_modulate := _terrain_modulate(terrain[y][x])
			tile.modulate = base_modulate
			tile.set_meta("cell", position)
			tile.set_meta("base_modulate", base_modulate)
			tile.disabled = not _placement_active()
			tile.pressed.connect(_handle_map_cell_pressed.bind(position))
			map_tiles.append(tile)
			world_grid.add_child(tile)

	for detail in MAP_DETAILS:
		_add_map_detail(world_grid, detail)

	for building_id in building_positions.keys():
		_add_building_sprite(world_grid, building_id)

	_add_placement_layer(world_grid)

func _add_map_detail(board: Control, detail: Dictionary) -> void:
	var cell: Vector2i = detail["cell"]
	var detail_texture: Texture2D = detail["texture"]
	var detail_size: Vector2 = _texture_draw_size(detail_texture, DETAIL_TEXTURE_SCALE)
	var detail_name: String = detail["name"]
	var detail_message: String = detail["message"]
	var center := Vector2(cell.x * TILE_PIXEL + TILE_PIXEL * 0.5, cell.y * TILE_PIXEL + TILE_PIXEL * 0.5)
	var button := TextureButton.new()
	button.position = center - detail_size * 0.5
	button.custom_minimum_size = detail_size
	button.size = detail_size
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.texture_normal = detail_texture
	button.tooltip_text = detail_name
	button.pressed.connect(_handle_map_detail_pressed.bind(detail))
	button.z_index = 1
	map_detail_buttons.append(button)
	board.add_child(button)

func _add_building_sprite(board: Control, building_id: String) -> void:
	var texture: Texture2D = _building_texture(building_id)
	var level := int(game.buildings[building_id]["level"])
	var visual_tier := mini(level - 1, 2)
	var sprite_size := _texture_draw_size(texture, BUILDING_TEXTURE_SCALE + float(visual_tier) * 0.08)
	var plot: Vector2i = building_positions[building_id]
	var center := Vector2(plot.x * TILE_PIXEL + TILE_PIXEL * 0.5, plot.y * TILE_PIXEL + TILE_PIXEL * 0.5)

	var button := TextureButton.new()
	button.position = center - sprite_size * 0.5
	button.custom_minimum_size = sprite_size
	button.size = sprite_size
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.texture_normal = texture
	button.tooltip_text = game.buildings[building_id]["name"]
	button.pressed.connect(_select_building.bind(building_id))
	button.z_index = 3
	building_buttons[building_id] = button
	board.add_child(button)

	var badge := Label.new()
	badge.text = "READY"
	badge.position = button.position + Vector2(sprite_size.x * 0.18, sprite_size.y - 22)
	badge.custom_minimum_size = Vector2(maxi(52, int(sprite_size.x * 0.55)), 18)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_color_override("font_color", Color("#0b2534"))
	badge.add_theme_font_size_override("font_size", 9)
	badge.add_theme_stylebox_override("normal", _badge_style())
	badge.z_index = 4
	building_badges[building_id] = badge
	board.add_child(badge)

func _add_placement_layer(board: Control) -> void:
	placement_layer = Control.new()
	placement_layer.position = Vector2.ZERO
	placement_layer.custom_minimum_size = Vector2(WORLD_COLUMNS * TILE_PIXEL, WORLD_ROWS * TILE_PIXEL)
	placement_layer.size = placement_layer.custom_minimum_size
	placement_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	placement_layer.visible = false
	placement_layer.z_index = 12
	placement_layer.gui_input.connect(_handle_placement_layer_input)
	board.add_child(placement_layer)

	placement_preview = TextureRect.new()
	placement_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	placement_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	placement_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	placement_preview.modulate = Color(0.65, 1.0, 1.0, 0.72)
	placement_preview.visible = false
	placement_layer.add_child(placement_preview)

func _texture_draw_size(texture: Texture2D, scale: float) -> Vector2:
	return Vector2(texture.get_width(), texture.get_height()) * scale

func _make_terrain() -> Array:
	var terrain := []
	for y in range(WORLD_ROWS):
		var row := []
		for x in range(WORLD_COLUMNS):
			var tile_id := TERRAIN_SNOW_ID
			if x == 14 and y == 13:
				tile_id = TERRAIN_CLEARING_ID
			elif x == 14:
				tile_id = TERRAIN_ROAD_VERTICAL_ID
			elif y == 13:
				tile_id = TERRAIN_ROAD_HORIZONTAL_ID
			elif x in [18, 19, 20, 21, 22] and y in [10, 11, 12, 13]:
				tile_id = TERRAIN_CLEARING_ID
			elif (x + y) % 9 == 0:
				tile_id = TERRAIN_SNOW_ROUGH_ID
			row.append(tile_id)
		terrain.append(row)

	for tree_position in [Vector2i(2, 2), Vector2i(5, 4), Vector2i(25, 3), Vector2i(28, 7), Vector2i(6, 18), Vector2i(27, 20)]:
		terrain[tree_position.y][tree_position.x] = TERRAIN_PINE_ID

	for fence_position in [Vector2i(11, 12), Vector2i(12, 12), Vector2i(13, 12), Vector2i(18, 14), Vector2i(19, 14), Vector2i(20, 14)]:
		terrain[fence_position.y][fence_position.x] = TERRAIN_LOGS_ID

	return terrain

func _terrain_texture(tile_id: int) -> Texture2D:
	match tile_id:
		TERRAIN_SNOW_ROUGH_ID:
			return TERRAIN_SNOW_ROUGH
		TERRAIN_ROAD_HORIZONTAL_ID:
			return TERRAIN_ROAD_HORIZONTAL
		TERRAIN_ROAD_VERTICAL_ID:
			return TERRAIN_ROAD_VERTICAL
		TERRAIN_CLEARING_ID:
			return TERRAIN_CLEARING
		TERRAIN_PINE_ID:
			return TERRAIN_PINE
		TERRAIN_LOGS_ID:
			return TERRAIN_LOGS
	return TERRAIN_SNOW

func _terrain_modulate(tile_id: int) -> Color:
	if tile_id == TERRAIN_SNOW_ID:
		return Color("#e5f4f8")
	if tile_id == TERRAIN_SNOW_ROUGH_ID:
		return Color("#f6fbff")
	if tile_id == TERRAIN_ROAD_HORIZONTAL_ID or tile_id == TERRAIN_ROAD_VERTICAL_ID or tile_id == TERRAIN_CLEARING_ID:
		return Color("#ffffff")
	if tile_id == TERRAIN_PINE_ID or tile_id == TERRAIN_LOGS_ID:
		return Color("#f8fbff")
	return Color.WHITE

func _select_building(building_id: String) -> void:
	_play_sfx(SFX_TAP)
	selected_building = building_id
	_hide_overlay_menus()
	_refresh()

func _toggle_move_mode() -> void:
	_play_sfx(SFX_SWITCH)
	placing_building_id = ""
	move_mode = not move_mode
	if move_mode:
		_hide_overlay_menus()
	_set_move_button_text("Move: On" if move_mode else "Move")
	_set_status("Move mode: tap an open snow tile to place %s." % game.buildings[selected_building]["name"] if move_mode else "Drag or WASD to explore. P pause · 1/2/3 speed · Build to expand.")
	_set_map_tiles_enabled(move_mode)

func _handle_map_cell_pressed(cell: Vector2i) -> void:
	if placing_building_id != "":
		_place_pending_building(cell)
		return
	if not move_mode:
		return
	if _is_occupied(cell):
		game.add_log("That tile is already occupied.")
		return

	building_positions[selected_building] = cell
	move_mode = false
	_set_move_button_text("Move")
	_set_map_tiles_enabled(false)
	_set_status("%s moved to a new plot." % game.buildings[selected_building]["name"])
	game.add_log("%s relocated to plot %s,%s." % [game.buildings[selected_building]["name"], cell.x, cell.y])
	_queue_world_rebuild()

func _begin_build_placement(building_id: String) -> void:
	if game.has_building(building_id):
		selected_building = building_id
		_refresh()
		return
	if not game.is_building_unlocked(building_id):
		game.add_log("%s locked. %s." % [game.building_name(building_id), game.build_lock_reason(building_id)])
		return
	if game.project_in_progress():
		game.add_log("Finish the active project first: %s." % game.project_status())
		return
	if not game.can_build(building_id):
		game.add_log("Not enough supplies to build %s." % game.building_name(building_id))
		return

	move_mode = false
	_set_move_button_text("Move")
	placing_building_id = building_id
	placement_cell = _initial_placement_cell()
	build_menu_panel.visible = false
	if selected_panel != null:
		selected_panel.visible = true
	_set_status("Place %s: click a plot, or use WASD/arrows + Enter. Esc cancels." % game.building_name(building_id))
	_set_map_tiles_enabled(true)

func _place_pending_building(cell: Vector2i) -> void:
	if _is_occupied(cell):
		game.add_log("That tile is already occupied.")
		return

	var building_id := placing_building_id
	if game.build(building_id):
		building_positions[building_id] = cell
		selected_building = building_id
		_set_status("%s built at plot %s,%s." % [game.building_name(building_id), cell.x, cell.y])
		_queue_world_rebuild()
		_refresh()
	else:
		_set_status("Build canceled. Supplies are too low.")

	placing_building_id = ""
	_set_map_tiles_enabled(false)

func _cancel_build_placement() -> void:
	var building_name := game.building_name(placing_building_id)
	placing_building_id = ""
	_set_map_tiles_enabled(false)
	_set_status("Canceled %s placement." % building_name)

func _cancel_move_mode() -> void:
	move_mode = false
	_set_move_button_text("Move")
	_set_map_tiles_enabled(false)

func _hide_overlay_menus() -> void:
	for menu in [build_menu_panel, goals_menu_panel, log_menu_panel]:
		if menu != null:
			menu.visible = false
	if selected_panel != null:
		selected_panel.visible = true

func _handle_map_detail_pressed(detail: Dictionary) -> void:
	if move_mode or placing_building_id != "":
		return
	game.scout_site(detail["id"], detail["reward"], detail["message"])

func _set_status(message: String) -> void:
	if map_status_label == null:
		return
	map_status_label.text = message

func _set_move_button_text(message: String) -> void:
	if move_mode_button == null:
		return
	move_mode_button.text = message

func _is_occupied(cell: Vector2i) -> bool:
	for position in building_positions.values():
		if position == cell:
			return true
	return false

func _set_map_tiles_enabled(enabled: bool) -> void:
	for tile in map_tiles:
		if is_instance_valid(tile):
			tile.disabled = not enabled
			_style_map_tile_for_mode(tile, enabled)
	for detail_button in map_detail_buttons:
		if is_instance_valid(detail_button):
			detail_button.mouse_filter = Control.MOUSE_FILTER_IGNORE if enabled else Control.MOUSE_FILTER_STOP
	if placement_layer != null and is_instance_valid(placement_layer):
		placement_layer.visible = enabled
		placement_layer.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE
	if placement_preview != null and is_instance_valid(placement_preview):
		placement_preview.visible = enabled and placing_building_id != ""
		if placing_building_id != "":
			_update_placement_preview_for_cell(placement_cell)

func _placement_active() -> bool:
	return move_mode or placing_building_id != ""

func _handle_placement_layer_input(event: InputEvent) -> void:
	if not _placement_active():
		return
	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		_update_placement_preview(motion.position)
	elif event is InputEventMouseButton:
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index == MOUSE_BUTTON_LEFT and mouse_button.pressed:
			_commit_map_press(mouse_button.position)
	elif event is InputEventScreenDrag:
		var screen_drag := event as InputEventScreenDrag
		_update_placement_preview(screen_drag.position)
	elif event is InputEventScreenTouch:
		var screen_touch := event as InputEventScreenTouch
		if screen_touch.pressed:
			_commit_map_press(screen_touch.position)

func _commit_map_press(local_position: Vector2) -> void:
	_handle_map_cell_pressed(_cell_from_map_position(local_position))
	if placement_layer != null and is_instance_valid(placement_layer):
		placement_layer.accept_event()

func _update_placement_preview(local_position: Vector2) -> void:
	if placement_preview == null or not is_instance_valid(placement_preview) or placing_building_id == "":
		return
	var cell := _cell_from_map_position(local_position)
	placement_cell = cell
	_update_placement_preview_for_cell(cell)

func _update_placement_preview_for_cell(cell: Vector2i) -> void:
	if placement_preview == null or not is_instance_valid(placement_preview) or placing_building_id == "":
		return
	var texture := _blueprint_texture(placing_building_id)
	var preview_size := _texture_draw_size(texture, BUILDING_TEXTURE_SCALE)
	var center := Vector2(cell.x * TILE_PIXEL + TILE_PIXEL * 0.5, cell.y * TILE_PIXEL + TILE_PIXEL * 0.5)
	placement_preview.texture = texture
	placement_preview.custom_minimum_size = preview_size
	placement_preview.size = preview_size
	placement_preview.position = center - preview_size * 0.5
	placement_preview.modulate = Color(1.0, 0.48, 0.42, 0.66) if _is_occupied(cell) else Color(0.65, 1.0, 1.0, 0.72)
	placement_preview.visible = true

func _initial_placement_cell() -> Vector2i:
	var origin: Vector2i = building_positions.get(selected_building, Vector2i(WORLD_COLUMNS / 2, WORLD_ROWS / 2))
	for offset in [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP]:
		var candidate: Vector2i = origin + offset
		if candidate.x >= 0 and candidate.x < WORLD_COLUMNS and candidate.y >= 0 and candidate.y < WORLD_ROWS and not _is_occupied(candidate):
			return candidate
	return Vector2i(clampi(origin.x, 0, WORLD_COLUMNS - 1), clampi(origin.y, 0, WORLD_ROWS - 1))

func _cell_from_map_position(local_position: Vector2) -> Vector2i:
	return Vector2i(
		clampi(int(floor(local_position.x / TILE_PIXEL)), 0, WORLD_COLUMNS - 1),
		clampi(int(floor(local_position.y / TILE_PIXEL)), 0, WORLD_ROWS - 1)
	)

func _style_map_tile_for_mode(tile: TextureButton, enabled: bool) -> void:
	if not tile.has_meta("base_modulate"):
		return
	var base: Color = tile.get_meta("base_modulate")
	if not enabled:
		tile.modulate = base
		return

	var cell: Vector2i = tile.get_meta("cell")
	if _is_occupied(cell):
		tile.modulate = Color(1.0, 0.62, 0.56, 0.78)
	else:
		tile.modulate = Color(0.78, 1.0, 1.0, 1.0)

func _building_texture(building_id: String) -> Texture2D:
	var level := int(game.buildings[building_id]["level"])
	var options: Array = BUILDING_SPRITES[building_id]
	var index: int = clampi(level - 1, 0, options.size() - 1)
	return options[index]

func _blueprint_texture(building_id: String) -> Texture2D:
	var options: Array = BUILDING_SPRITES[building_id]
	return options[0]

func _queue_world_rebuild() -> void:
	if world_rebuild_queued:
		return
	world_rebuild_queued = true
	call_deferred("_rebuild_world_grid")

func _rebuild_world_grid() -> void:
	world_rebuild_queued = false
	for child in world_grid.get_children():
		child.hide()
		child.queue_free()
	call_deferred("_build_world_grid", world_grid)

func _make_building_row(building_id: String) -> Dictionary:
	var row_panel := PanelContainer.new()
	row_panel.add_theme_stylebox_override("panel", _panel_style(Color(1, 1, 1, 0.92), Color(0.55, 0.73, 0.84, 0.32), 6))

	var row := HFlowContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.add_theme_constant_override("v_separation", 6)
	row_panel.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _blueprint_texture(building_id)
	icon.custom_minimum_size = Vector2(64, 52)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	var info := Label.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_theme_color_override("font_color", Color("#153247"))
	info.add_theme_font_size_override("font_size", 15)
	row.add_child(info)

	var minus := _make_icon_button(ICON_MINUS, func() -> void: game.assign_worker(building_id, -1))
	row.add_child(minus)

	var plus := _make_icon_button(ICON_PLUS, func() -> void: game.assign_worker(building_id, 1))
	row.add_child(plus)

	var upgrade := _make_icon_button(ICON_WRENCH, func() -> void: game.upgrade(building_id))
	row.add_child(upgrade)

	var build := _make_action_button("Place", ICON_PLUS, _begin_build_placement.bind(building_id), Color("#1f7fab"))
	build.custom_minimum_size = Vector2(94, 42)
	build.size_flags_horizontal = Control.SIZE_SHRINK_END
	build.tooltip_text = "Build %s" % game.building_name(building_id)
	row.add_child(build)

	return {
		"container": row_panel,
		"icon": icon,
		"info": info,
		"minus": minus,
		"plus": plus,
		"upgrade": upgrade,
		"build": build,
	}

func _refresh() -> void:
	if not ui_ready or not _hud_ready():
		return
	_ensure_selected_building()
	_sync_building_positions_with_state()
	day_label.text = "DAY %s" % game.day
	season_label.text = game.season.to_upper()
	if chapter_label != null:
		chapter_label.text = "CH %s" % game.current_chapter
	workers_label.text = "IDLE %s/%s" % [game.available_workers, game.homesteaders]
	power_label.text = "POWER %s" % game.settlement_power()
	storm_label.text = "STORM %s%%" % game.storm_pressure()
	if game.project_in_progress() and not move_mode and placing_building_id == "":
		_set_status("Active project: %s." % game.project_status())
	if game.game_over:
		if game.victory:
			_set_status("Victory — Frostfall stands strong. %s" % game.end_summary())
		else:
			_set_status("Settlement failed. The storm has overtaken Frostfall Homestead.")
	day_progress.max_value = game.DAY_LENGTH
	day_progress.value = game.DAY_LENGTH - game.seconds_until_day
	morale_bar.value = game.morale
	heat_bar.value = game.heat

	if pause_button != null:
		pause_button.text = "Resume" if game.paused else "Pause"
		pause_button.disabled = game.game_over and not game.paused
	if speed_button != null:
		var scale_label := str(int(game.time_scale)) if fmod(game.time_scale, 1.0) == 0.0 else str(game.time_scale)
		speed_button.text = "%sx" % scale_label
	if load_button != null:
		load_button.disabled = not game.has_save()
	if save_button != null:
		save_button.disabled = game.game_over

	for resource_name in resource_labels.keys():
		var amount := int(game.resources[resource_name])
		resource_labels[resource_name].text = "%s\n%s" % [resource_name.to_upper(), amount]
		resource_chips[resource_name].add_theme_stylebox_override("panel", _resource_style(resource_name, amount))

	if not game.has_building(selected_building):
		return

	var selected: Dictionary = game.buildings[selected_building]
	if selected_preview != null and selected_title != null and selected_detail != null and selected_role != null and selected_output != null and selected_risk != null:
		selected_preview.texture = _building_texture(selected_building)
		selected_title.text = "%s Command" % selected["name"]
		selected_detail.text = "L%s  |  Workers %s/%s  |  Ready %s%%  |  %s" % [
			selected["level"],
			selected["workers"],
			selected["max_workers"],
			int(selected["readiness"]),
			game.building_status_text(selected_building),
		]
		var details := game.building_details(selected_building)
		selected_role.text = details["role"]
		selected_output.text = "%s | %s" % [details["output"], _format_production(game.production_preview(selected_building))]
		selected_risk.text = details["risk"]
	if condition_bar != null:
		condition_bar.value = selected["condition"]
	if readiness_bar != null:
		readiness_bar.value = selected["readiness"]
	if worker_row != null and worker_row.has_meta("plus") and worker_row.has_meta("minus"):
		var w_plus: Button = worker_row.get_meta("plus")
		var w_minus: Button = worker_row.get_meta("minus")
		var operational := game.is_building_operational(selected_building)
		w_plus.disabled = game.game_over or not operational or game.available_workers <= 0 or int(selected["workers"]) >= int(selected["max_workers"])
		w_minus.disabled = game.game_over or not operational or int(selected["workers"]) <= 0
	if ability_list != null:
		_queue_ability_rebuild()

	for building_id in building_rows.keys():
		var row: Dictionary = building_rows[building_id]
		if game.has_building(building_id):
			var building: Dictionary = game.buildings[building_id]
			var cost := game.upgrade_cost(building_id)
			var prefix := "> " if building_id == selected_building else ""
			row["container"].add_theme_stylebox_override("panel", _building_row_style(building_id == selected_building, true))
			row["icon"].texture = _building_texture(building_id)
			row["icon"].modulate = Color.WHITE
			row["info"].text = "%s%s  L%s\n%s/%s assigned | %s%% condition\n%s | Upgrade %s wood, %s tools" % [
				prefix,
				building["name"],
				building["level"],
				building["workers"],
				building["max_workers"],
				int(building["condition"]),
				game.building_status_text(building_id),
				cost["wood"],
				cost["tools"],
			]
			row["plus"].visible = true
			row["minus"].visible = true
			row["upgrade"].visible = true
			row["build"].visible = false
			row["plus"].disabled = not game.is_building_operational(building_id) or game.available_workers <= 0 or building["workers"] >= building["max_workers"]
			row["minus"].disabled = not game.is_building_operational(building_id) or building["workers"] <= 0
			row["upgrade"].disabled = not game.can_upgrade(building_id)
		else:
			var build_cost := game.build_cost(building_id)
			var status := game.building_status_text(building_id)
			row["container"].add_theme_stylebox_override("panel", _building_row_style(false, false))
			row["icon"].texture = _blueprint_texture(building_id)
			row["icon"].modulate = Color(0.72, 0.84, 0.90, 0.68)
			row["info"].text = "%s\n%s | Build cost: %s" % [game.building_name(building_id), status, _format_cost(build_cost)]
			row["plus"].visible = false
			row["minus"].visible = false
			row["upgrade"].visible = false
			row["build"].visible = true
			row["build"].disabled = not game.can_build(building_id)

		if game.game_over:
			row["plus"].disabled = true
			row["minus"].disabled = true
			row["upgrade"].disabled = true
			row["build"].disabled = true

	for building_id in building_buttons.keys():
		if not game.has_building(building_id):
			continue
		var button: TextureButton = building_buttons[building_id]
		var building: Dictionary = game.buildings[building_id]
		var badge: Label = building_badges[building_id]
		button.texture_normal = _building_texture(building_id)
		button.tooltip_text = "%s | %s | Ready %s%% | Condition %s%%" % [
			building["name"],
			game.building_status_text(building_id),
			int(building["readiness"]),
			int(building["condition"]),
		]
		var under_construction := bool(building.get("under_construction", false))
		var upgrading: bool = str(game.active_project.get("building_id", "")) == building_id and str(game.active_project.get("type", "")) == "upgrade"
		if under_construction or upgrading:
			badge.visible = true
			badge.text = "%s%%" % int(game.project_progress() * 100.0) if game.active_project.get("building_id", "") == building_id else "..."
			badge.add_theme_stylebox_override("normal", _badge_style_alt(Color("#f0c36a")))
			button.modulate = Color(0.85, 0.9, 1.0, 0.75)
		elif game.is_building_operational(building_id) and building["readiness"] >= 100.0:
			badge.visible = true
			badge.text = "READY"
			badge.add_theme_stylebox_override("normal", _badge_style())
			button.modulate = Color("#d8fff1") if building_id != selected_building else Color(1.55, 1.55, 1.55)
		elif float(building["condition"]) < 30.0:
			badge.visible = true
			badge.text = "WEAK"
			badge.add_theme_stylebox_override("normal", _badge_style_alt(Color("#f08a6a")))
			button.modulate = Color(1.1, 0.85, 0.8) if building_id != selected_building else Color(1.55, 1.55, 1.55)
		else:
			badge.visible = false
			button.modulate = Color(1.55, 1.55, 1.55) if building_id == selected_building else Color(0.95, 1.0, 1.04)

	# Dim scouted landmarks
	for i in range(map_detail_buttons.size()):
		if i >= MAP_DETAILS.size():
			break
		var detail: Dictionary = MAP_DETAILS[i]
		var detail_btn: TextureButton = map_detail_buttons[i]
		if not is_instance_valid(detail_btn):
			continue
		if game.scouted_sites.has(detail["id"]):
			detail_btn.modulate = Color(0.55, 0.65, 0.7, 0.55)
			detail_btn.tooltip_text = "%s (scouted)" % detail["name"]
		else:
			detail_btn.modulate = Color.WHITE
			detail_btn.tooltip_text = detail["name"]

	for child in event_list.get_children():
		child.queue_free()

	for index in range(game.event_log.size()):
		event_list.add_child(_make_event_card(game.event_log[index], index))

	for child in objective_list.get_children():
		child.queue_free()

	for goal in game.survival_goals():
		objective_list.add_child(_make_goal_card(goal))

	move_mode_button.disabled = game.game_over

func _hud_ready() -> bool:
	return day_label != null \
		and season_label != null \
		and workers_label != null \
		and power_label != null \
		and storm_label != null \
		and day_progress != null \
		and morale_bar != null \
		and heat_bar != null

func _sync_building_positions_with_state() -> void:
	var missing := false
	for building_id in game.buildings.keys():
		if not building_positions.has(building_id):
			building_positions[building_id] = _find_open_cell_near_cabin()
			missing = true
	var stale: Array[String] = []
	for building_id in building_positions.keys():
		if not game.has_building(building_id):
			stale.append(building_id)
	for building_id in stale:
		building_positions.erase(building_id)
		missing = true
	if missing:
		_queue_world_rebuild()

func _find_open_cell_near_cabin() -> Vector2i:
	var origin: Vector2i = building_positions.get("cabin", Vector2i(14, 10))
	for radius in range(1, 8):
		for dy in range(-radius, radius + 1):
			for dx in range(-radius, radius + 1):
				var cell := Vector2i(origin.x + dx, origin.y + dy)
				if cell.x < 1 or cell.y < 1 or cell.x >= WORLD_COLUMNS - 1 or cell.y >= WORLD_ROWS - 1:
					continue
				if not _is_occupied(cell):
					return cell
	return Vector2i(clampi(origin.x + 2, 0, WORLD_COLUMNS - 1), clampi(origin.y + 2, 0, WORLD_ROWS - 1))

func _store_layout_to_game() -> void:
	var layout := {}
	for building_id in building_positions.keys():
		var cell: Vector2i = building_positions[building_id]
		layout[building_id] = {"x": cell.x, "y": cell.y}
	game.layout_data = {"buildings": layout}

func _restore_layout_from_game() -> void:
	building_positions = {"cabin": Vector2i(14, 10)}
	var layout: Dictionary = game.layout_data.get("buildings", {})
	for building_id in layout.keys():
		if not game.has_building(building_id):
			continue
		var entry: Dictionary = layout[building_id]
		building_positions[building_id] = Vector2i(int(entry.get("x", 14)), int(entry.get("y", 10)))
	for building_id in game.buildings.keys():
		if not building_positions.has(building_id):
			building_positions[building_id] = _find_open_cell_near_cabin()
	_queue_world_rebuild()

func _build_modals() -> void:
	modal_layer = CanvasLayer.new()
	modal_layer.layer = 40
	add_child(modal_layer)

	tutorial_panel = _make_modal_shell()
	tutorial_panel.visible = false
	modal_layer.add_child(tutorial_panel)
	var t_box: VBoxContainer = tutorial_panel.get_meta("content")
	tutorial_title = Label.new()
	tutorial_title.add_theme_color_override("font_color", Color("#153247"))
	tutorial_title.add_theme_font_size_override("font_size", 22)
	t_box.add_child(tutorial_title)
	tutorial_body = Label.new()
	tutorial_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tutorial_body.add_theme_color_override("font_color", Color("#2a4a5c"))
	tutorial_body.add_theme_font_size_override("font_size", 15)
	t_box.add_child(tutorial_body)
	var t_row := HBoxContainer.new()
	t_row.add_theme_constant_override("separation", 10)
	t_box.add_child(t_row)
	var skip_btn := _make_action_button("Skip", ICON_MINUS, Callable(self, "_on_tutorial_skip"), Color("#65757c"))
	skip_btn.custom_minimum_size = Vector2(120, 44)
	t_row.add_child(skip_btn)
	var next_btn := _make_action_button("Next", ICON_PLUS, Callable(self, "_on_tutorial_next"), Color("#1f7fab"))
	next_btn.custom_minimum_size = Vector2(140, 44)
	t_row.add_child(next_btn)

	choice_panel = _make_modal_shell()
	choice_panel.visible = false
	modal_layer.add_child(choice_panel)
	var c_box: VBoxContainer = choice_panel.get_meta("content")
	choice_title = Label.new()
	choice_title.add_theme_color_override("font_color", Color("#153247"))
	choice_title.add_theme_font_size_override("font_size", 22)
	c_box.add_child(choice_title)
	choice_body = Label.new()
	choice_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	choice_body.add_theme_color_override("font_color", Color("#2a4a5c"))
	choice_body.add_theme_font_size_override("font_size", 15)
	c_box.add_child(choice_body)
	choice_buttons = VBoxContainer.new()
	choice_buttons.add_theme_constant_override("separation", 8)
	c_box.add_child(choice_buttons)

	end_panel = _make_modal_shell()
	end_panel.visible = false
	modal_layer.add_child(end_panel)
	var e_box: VBoxContainer = end_panel.get_meta("content")
	end_title = Label.new()
	end_title.add_theme_color_override("font_color", Color("#153247"))
	end_title.add_theme_font_size_override("font_size", 24)
	e_box.add_child(end_title)
	end_body = Label.new()
	end_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	end_body.add_theme_color_override("font_color", Color("#2a4a5c"))
	end_body.add_theme_font_size_override("font_size", 15)
	e_box.add_child(end_body)
	var restart_btn := _make_action_button("New Settlement", ICON_PLUS, Callable(self, "_on_new_game_pressed"), Color("#1f7fab"))
	restart_btn.custom_minimum_size = Vector2(200, 48)
	e_box.add_child(restart_btn)

func _make_modal_shell() -> PanelContainer:
	var dim := PanelContainer.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.add_theme_stylebox_override("panel", _panel_style(Color(0.01, 0.04, 0.08, 0.62), Color(0, 0, 0, 0), 0))
	dim.mouse_filter = Control.MOUSE_FILTER_STOP

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(420, 0)
	card.add_theme_stylebox_override("panel", _panel_style(Color(0.96, 0.99, 1.0, 0.98), Color(1, 1, 1, 0.7), 12))
	center.add_child(card)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	card.add_child(box)
	dim.set_meta("content", box)
	return dim

func _on_tutorial_step(_step: int, title: String, body: String) -> void:
	if tutorial_panel == null:
		return
	tutorial_title.text = title
	tutorial_body.text = body
	tutorial_panel.visible = true
	game.set_paused(true)

func _on_tutorial_next() -> void:
	_play_sfx(SFX_CLICK)
	tutorial_panel.visible = false
	game.advance_tutorial()
	if game.tutorial_complete:
		game.set_paused(false)

func _on_tutorial_skip() -> void:
	_play_sfx(SFX_SWITCH)
	tutorial_panel.visible = false
	game.skip_tutorial()
	game.set_paused(false)

func _on_choice_requested(_event_id: String, title: String, body: String, options: Array) -> void:
	if choice_panel == null:
		return
	choice_title.text = title
	choice_body.text = body
	for child in choice_buttons.get_children():
		child.queue_free()
	for option in options:
		var option_id := str(option.get("id", ""))
		var label := str(option.get("label", "Choose"))
		var btn := _make_action_button(label, ICON_TARGET, _resolve_choice.bind(option_id), Color("#1f6f94"))
		btn.custom_minimum_size = Vector2(280, 48)
		btn.add_theme_font_size_override("font_size", 14)
		choice_buttons.add_child(btn)
	choice_panel.visible = true

func _resolve_choice(option_id: String) -> void:
	_play_sfx(SFX_CLICK)
	choice_panel.visible = false
	game.resolve_choice(option_id)
	if not game.game_over:
		game.set_paused(false)

func _on_game_ended(won: bool, summary: String) -> void:
	if end_panel == null:
		return
	end_title.text = "Valley Secured" if won else "Settlement Lost"
	end_body.text = ("%s\n\n%s" % [
		"Frostfall outlasted the worst of winter. Your homestead is a true valley stronghold." if won \
			else "The storm and shortages broke Frostfall. Learn from the log and try a new settlement.",
		summary,
	])
	end_panel.visible = true
	_play_sfx(SFX_SWITCH)

func _on_pause_pressed() -> void:
	_play_sfx(SFX_SWITCH)
	game.toggle_pause()

func _on_speed_pressed() -> void:
	_play_sfx(SFX_SWITCH)
	game.cycle_time_scale()

func _on_save_pressed() -> void:
	_play_sfx(SFX_CLICK)
	_store_layout_to_game()
	if game.save_game():
		_set_status("Game saved.")
		game.add_log("Manual save complete.")
	else:
		_set_status("Save failed.")

func _on_load_pressed() -> void:
	_play_sfx(SFX_CLICK)
	if not game.has_save():
		_set_status("No save found.")
		return
	if game.load_game():
		placing_building_id = ""
		move_mode = false
		_set_move_button_text("Move")
		_set_map_tiles_enabled(false)
		_hide_overlay_menus()
		if tutorial_panel:
			tutorial_panel.visible = false
		if choice_panel:
			choice_panel.visible = false
		if end_panel:
			end_panel.visible = false
		_restore_layout_from_game()
		_set_status("Save loaded — day %s." % game.day)
		_refresh()
	else:
		_set_status("Load failed.")

func _on_new_game_pressed() -> void:
	_play_sfx(SFX_CLICK)
	if tutorial_panel:
		tutorial_panel.visible = false
	if choice_panel:
		choice_panel.visible = false
	if end_panel:
		end_panel.visible = false
	placing_building_id = ""
	move_mode = false
	_set_move_button_text("Move")
	_set_map_tiles_enabled(false)
	building_positions = {"cabin": Vector2i(14, 10)}
	game.start_new_game()
	_queue_world_rebuild()
	_refresh()

func _play_sfx(stream: AudioStream) -> void:
	if sfx_player == null:
		return
	sfx_player.stream = stream
	sfx_player.play()

func _ensure_selected_building() -> void:
	if game.has_building(selected_building):
		return
	for building_id in game.building_ids():
		if game.has_building(building_id):
			selected_building = building_id
			return

func _queue_ability_rebuild() -> void:
	if ability_rebuild_queued:
		return

	ability_rebuild_queued = true
	call_deferred("_rebuild_ability_buttons")

func _rebuild_ability_buttons() -> void:
	ability_rebuild_queued = false
	for child in ability_list.get_children():
		child.hide()
		child.queue_free()

	if not game.is_building_operational(selected_building):
		var status_button := _make_action_button(
			"%s\n%s\nOrders locked" % [game.buildings[selected_building]["name"], game.building_status_text(selected_building)],
			ICON_TARGET,
			func() -> void: game.add_log(game.building_status_text(selected_building)),
			Color("#425f75")
		)
		status_button.custom_minimum_size = Vector2(190, 50)
		status_button.add_theme_font_size_override("font_size", 13)
		status_button.disabled = true
		ability_list.add_child(status_button)
		return

	for action in game.building_actions(selected_building):
		var action_id: String = action["id"]
		var button := _make_action_button(
			"%s\n%s\n%s" % [action["name"], action["cost"], action["effect"]],
			ICON_TARGET,
			_perform_selected_action.bind(action_id),
			Color("#1f6f94")
		)
		button.custom_minimum_size = Vector2(145 if compact_layout else 156, 50)
		button.add_theme_font_size_override("font_size", 13)
		button.disabled = game.game_over or not game.can_perform_building_action(selected_building, action_id)
		ability_list.add_child(button)

	var upgrade_cost := game.upgrade_cost(selected_building)
	var upgrade := _make_action_button(
		"Upgrade\n%s wood, %s tools\n+level, +capacity" % [upgrade_cost["wood"], upgrade_cost["tools"]],
		ICON_WRENCH,
		func() -> void: game.upgrade(selected_building),
		Color("#a36a25")
	)
	upgrade.custom_minimum_size = Vector2(145 if compact_layout else 156, 50)
	upgrade.add_theme_font_size_override("font_size", 13)
	upgrade.disabled = game.game_over or not game.can_upgrade(selected_building)
	ability_list.add_child(upgrade)

func _format_production(production: Dictionary) -> String:
	var parts: Array[String] = []
	for key in production.keys():
		parts.append("+%s %s/day" % [snappedf(production[key], 0.1), key])
	return ", ".join(parts)

func _format_cost(cost: Dictionary) -> String:
	var parts: Array[String] = []
	for resource_name in ["wood", "tools", "seed", "food", "water"]:
		if cost.has(resource_name) and int(cost[resource_name]) > 0:
			parts.append("%s %s" % [cost[resource_name], resource_name])
	if parts.is_empty():
		return "free"
	return ", ".join(parts)

func _make_event_card(message: String, index: int) -> Control:
	var panel := PanelContainer.new()
	var alpha := 0.84 - minf(float(index) * 0.08, 0.30)
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.05, 0.16, 0.24, alpha), Color(0.62, 0.86, 1.0, 0.22), 6))

	var label := Label.new()
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color("#d8edf7"))
	label.add_theme_font_size_override("font_size", 13)
	panel.add_child(label)
	return panel

func _make_goal_card(goal: Dictionary) -> Control:
	var complete := bool(goal["complete"])
	var active := bool(goal.get("active", false))
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _goal_style(complete))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	panel.add_child(box)

	var title := Label.new()
	title.text = "%s%s" % ["DONE  " if complete else ("ACTIVE  " if active else "NEXT  "), goal["title"]]
	title.add_theme_color_override("font_color", Color("#123247") if not complete else Color("#0d4b35"))
	title.add_theme_font_size_override("font_size", 14)
	box.add_child(title)

	var detail := Label.new()
	detail.text = "%s\n%s\n%s" % [goal.get("chapter_title", ""), goal["detail"], goal["progress"]]
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_theme_color_override("font_color", Color("#315265") if not complete else Color("#3c6b58"))
	detail.add_theme_font_size_override("font_size", 12)
	box.add_child(detail)

	return panel

func _perform_selected_action(action_id: String) -> void:
	_play_sfx(SFX_CLICK)
	game.perform_building_action(selected_building, action_id)

func _make_chip() -> Label:
	var label := Label.new()
	label.custom_minimum_size = Vector2(96, 34)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color("#f2fbff"))
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_stylebox_override("normal", _panel_style(Color(0.08, 0.23, 0.34, 0.90), Color(0.78, 0.95, 1.0, 0.36), 6))
	return label

func _make_action_button(text: String, icon: Texture2D, callback: Callable, color: Color) -> Button:
	var button := Button.new()
	button.text = text
	button.icon = icon
	button.expand_icon = true
	button.custom_minimum_size = Vector2(220, 52)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _button_style(color, Color(1, 1, 1, 0.32)))
	button.add_theme_stylebox_override("hover", _button_style(color.lightened(0.14), Color(1, 1, 1, 0.44)))
	button.add_theme_stylebox_override("pressed", _button_style(color.darkened(0.12), Color(1, 1, 1, 0.24)))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#5a6a73"), Color(1, 1, 1, 0.12)))
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_font_size_override("font_size", 16)
	button.pressed.connect(callback)
	return button

func _make_icon_button(icon: Texture2D, callback: Callable) -> Button:
	var button := Button.new()
	button.icon = icon
	button.expand_icon = true
	button.custom_minimum_size = Vector2(46, 42)
	button.add_theme_stylebox_override("normal", _button_style(Color("#1d6d93"), Color(1, 1, 1, 0.26)))
	button.add_theme_stylebox_override("hover", _button_style(Color("#2588b4"), Color(1, 1, 1, 0.36)))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#165675"), Color(1, 1, 1, 0.20)))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#65757c"), Color(1, 1, 1, 0.12)))
	button.pressed.connect(callback)
	return button

func _make_named_meter(label_text: String, fill_color: Color) -> ProgressBar:
	var meter := ProgressBar.new()
	meter.min_value = 0
	meter.max_value = 100
	meter.show_percentage = true
	meter.tooltip_text = label_text
	meter.custom_minimum_size = Vector2(150, 52)
	meter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	meter.add_theme_stylebox_override("background", _meter_background())
	meter.add_theme_stylebox_override("fill", _meter_fill(fill_color))
	meter.add_theme_color_override("font_color", Color("#f7fbff"))
	return meter

func _panel_style(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 12
	style.content_margin_top = 10
	style.content_margin_right = 12
	style.content_margin_bottom = 10
	style.shadow_color = Color(0.0, 0.05, 0.10, 0.24)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 4)
	return style

func _button_style(bg: Color, border: Color) -> StyleBoxFlat:
	var style := _panel_style(bg, border, 8)
	style.content_margin_left = 10
	style.content_margin_top = 8
	style.content_margin_right = 10
	style.content_margin_bottom = 8
	style.shadow_color = Color(0.0, 0.03, 0.06, 0.34)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 3)
	return style

func _building_row_style(selected: bool, built: bool) -> StyleBoxFlat:
	if selected:
		return _panel_style(Color(0.82, 0.96, 1.0, 0.92), Color("#78d8ff"), 8)
	if built:
		return _panel_style(Color(1.0, 1.0, 1.0, 0.80), Color(0.60, 0.78, 0.88, 0.30), 8)
	return _panel_style(Color(0.78, 0.88, 0.93, 0.58), Color(0.72, 0.86, 0.94, 0.24), 8)

func _resource_style(resource_name: String, amount: int) -> StyleBoxFlat:
	var warning_threshold := {
		"food": 45,
		"wood": 35,
		"water": 35,
		"tools": 6,
		"seed": 8,
	}
	if amount <= int(warning_threshold[resource_name]):
		return _panel_style(Color(1.0, 0.86, 0.70, 0.88), Color("#ffd08a"), 8)
	return _panel_style(Color(0.94, 0.99, 1.0, 0.78), Color(1, 1, 1, 0.58), 8)

func _goal_style(complete: bool) -> StyleBoxFlat:
	if complete:
		return _panel_style(Color(0.78, 1.0, 0.88, 0.76), Color("#7be7aa"), 7)
	return _panel_style(Color(1.0, 1.0, 1.0, 0.72), Color(0.60, 0.78, 0.88, 0.26), 7)

func _meter_background() -> StyleBoxFlat:
	return _panel_style(Color(0.04, 0.11, 0.17, 0.72), Color(0.70, 0.90, 1.0, 0.18), 6)

func _meter_fill(fill_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.set_corner_radius_all(6)
	return style

func _badge_style() -> StyleBoxFlat:
	return _badge_style_alt(Color("#9ff0ff"))

func _badge_style_alt(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(1, 1, 1, 0.55)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 4
	style.content_margin_right = 4
	style.content_margin_top = 1
	style.content_margin_bottom = 1
	return style
