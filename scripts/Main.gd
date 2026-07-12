extends Control

## Frostfall Homestead — Whiteout Survival-style mobile city UI.

const GameStateScript := preload("res://scripts/GameState.gd")
const BackgroundScript := preload("res://scripts/PolishedBackground.gd")
const SnowOverlayScript := preload("res://scripts/SnowOverlay.gd")
const FloatingTextScript := preload("res://scripts/FloatingText.gd")
const FONT_FUTURE := preload("res://assets/kenney_ui_pack/Font/Kenney Future.ttf")

const TERRAIN_SNOW := preload("res://assets/map_details/tile_snow.png")
const TERRAIN_SNOW_ROUGH := preload("res://assets/map_details/tile_snow_rough.png")
const TERRAIN_ROAD_HORIZONTAL := preload("res://assets/map_details/tile_road_horizontal.png")
const TERRAIN_ROAD_VERTICAL := preload("res://assets/map_details/tile_road_vertical.png")
const TERRAIN_CLEARING := preload("res://assets/map_details/tile_clearing.png")
const TERRAIN_PINE := preload("res://assets/map_details/tile_pine.png")
const TERRAIN_LOGS := preload("res://assets/map_details/tile_logs.png")

const SPRITE_HOMESTEAD_L1 := preload("res://assets/building_upgrades/homestead_l1.png")
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
const ICON_GEAR := preload("res://assets/kenney_game_icons/PNG/White/2x/gear.png")
const ICON_STAR := preload("res://assets/kenney_game_icons/PNG/White/2x/star.png")
const ICON_SINGLE := preload("res://assets/kenney_game_icons/PNG/White/2x/singleplayer.png")
const ICON_SAVE := preload("res://assets/kenney_game_icons/PNG/White/2x/save.png")
const ICON_PAUSE := preload("res://assets/kenney_game_icons/PNG/White/2x/pause.png")
const ICON_FF := preload("res://assets/kenney_game_icons/PNG/White/2x/fastForward.png")
const ICON_WARNING := preload("res://assets/kenney_game_icons/PNG/White/2x/warning.png")
const ICON_CHECK := preload("res://assets/kenney_game_icons/PNG/White/2x/checkmark.png")
const ICON_LOCKED := preload("res://assets/kenney_game_icons/PNG/White/2x/locked.png")
const ICON_MENU := preload("res://assets/kenney_game_icons/PNG/White/2x/menuGrid.png")
const ICON_EXCLAIM := preload("res://assets/kenney_game_icons/PNG/White/2x/exclamation.png")

const SFX_CLICK := preload("res://assets/kenney_ui_pack/Sounds/click-a.ogg")
const SFX_TAP := preload("res://assets/kenney_ui_pack/Sounds/tap-a.ogg")
const SFX_SWITCH := preload("res://assets/kenney_ui_pack/Sounds/switch-a.ogg")
const SFX_TAP_B := preload("res://assets/kenney_ui_pack/Sounds/tap-b.ogg")

const TILE_SIZE := 16
const TILE_SCALE := 3
const TILE_PIXEL := TILE_SIZE * TILE_SCALE
const WORLD_COLUMNS := 34
const WORLD_ROWS := 44
const BUILDING_TEXTURE_SCALE := 0.34
const DETAIL_TEXTURE_SCALE := 0.38
const BUILDING_MAX_PX := 96.0
const DETAIL_MAX_PX := 72.0
const KEYBOARD_PAN_STEP := 80
const MIN_BUILDING_GAP := 3
const NAV_HEIGHT := 70.0
const SHEET_HEIGHT_DESKTOP := 248.0
const SHEET_HEIGHT_COMPACT := 280.0
const HUD_MARGIN := 8.0

const BUILDING_SPRITES := {
	"cabin": [SPRITE_HOMESTEAD_L1, SPRITE_CITY_HALL_L2, SPRITE_CITY_HALL_L3],
	"woodlot": [SPRITE_SAWMILL_L1, SPRITE_SAWMILL_L2, SPRITE_SAWMILL_L3],
	"garden": [SPRITE_HUNTERS_LODGE_L1, SPRITE_HUNTERS_LODGE_L2, SPRITE_HUNTERS_LODGE_L3],
	"well": [SPRITE_SHELTERS_L1, SPRITE_SHELTERS_L2, SPRITE_SHELTERS_L3],
	"hunter": [DETAIL_HUNTING, DETAIL_BLIND, DETAIL_CARCASS],
	"workshop": [SPRITE_COAL_MINE_L1, SPRITE_COAL_MINE_L2, SPRITE_COAL_MINE_L3],
	"kitchen": [DETAIL_CAMP, DETAIL_TIMBER_CAMP, DETAIL_SAWMILL],
	"warehouse": [DETAIL_ROCKS, DETAIL_ORE, DETAIL_QUARRY],
	"root_cellar": [DETAIL_CAVE, DETAIL_ROCKS, DETAIL_QUARRY],
	"smokehouse": [DETAIL_TIMBER_CAMP, DETAIL_BLIND, DETAIL_SAWMILL],
	"coop": [DETAIL_CAMP, DETAIL_OUTPOST, DETAIL_CARCASS],
	"infirmary": [SPRITE_SHELTERS_L2, SPRITE_SHELTERS_L3, SPRITE_CITY_HALL_L1],
	"watchtower": [DETAIL_OUTPOST, DETAIL_BLIND, SPRITE_CITY_HALL_L2],
}

const RESOURCE_ORDER := ["food", "wood", "water", "coal", "iron", "tools", "seed"]
const RESOURCE_COLORS := {
	"food": Color("#f3b05a"), "wood": Color("#9b6a4a"), "water": Color("#55bde8"),
	"tools": Color("#d8e0e8"), "seed": Color("#90d06f"), "coal": Color("#6a6a78"),
	"iron": Color("#b8c4d4"),
}
const RESOURCE_LABELS := {
	"food": "FOOD", "wood": "WOOD", "water": "H2O", "tools": "TOOL",
	"seed": "SEED", "coal": "COAL", "iron": "IRON",
}

const MAP_DETAILS := [
	{"id": "timber_stand", "name": "Frozen Timber", "texture": DETAIL_TIMBER, "cell": Vector2i(3, 3), "message": "Timber stand marked.", "reward": {"wood": 28}},
	{"id": "stone_outcrop", "name": "Stone Outcrop", "texture": DETAIL_STONE, "cell": Vector2i(30, 3), "message": "Stone outcrop scouted.", "reward": {"iron": 3, "tools": 1}},
	{"id": "hunting_trail", "name": "Hunting Trail", "texture": DETAIL_HUNTING, "cell": Vector2i(3, 38), "message": "Fresh tracks found.", "reward": {"food": 24}},
	{"id": "abandoned_camp", "name": "Abandoned Camp", "texture": DETAIL_CAMP, "cell": Vector2i(30, 38), "message": "Abandoned camp logged.", "reward": {"food": 12, "coal": 4}},
	{"id": "ice_cave", "name": "Ice Cave", "texture": DETAIL_CAVE, "cell": Vector2i(31, 20), "message": "Ice cave discovered.", "reward": {"water": 28, "coal": 3}},
	{"id": "ridge_outpost", "name": "Ridge Outpost", "texture": DETAIL_OUTPOST, "cell": Vector2i(2, 20), "message": "Ridge outpost marked.", "reward": {"morale": 5, "wood": 14}},
	{"id": "coal_seam", "name": "Coal Seam", "texture": DETAIL_ORE, "cell": Vector2i(16, 40), "message": "Coal seam surveyed.", "reward": {"coal": 12}},
]

var game: GameState
var resource_labels := {}
var resource_bars := {}
var building_rows := {}
var building_buttons := {}
var building_badges := {}
var bubble_buttons := {}
var map_tiles: Array[TextureButton] = []
var map_detail_buttons: Array[TextureButton] = []
var building_positions := {"cabin": Vector2i(16, 12)}

var world_grid: Control
var map_scroll: ScrollContainer
var snow_overlay: Control
var overlay_root: Control
var top_bar: PanelContainer
var bottom_nav: PanelContainer
var sheet_panel: PanelContainer
var storm_banner: PanelContainer
var mission_strip: PanelContainer
var toast_label: Label
var map_status_label: Label

var day_label: Label
var season_label: Label
var power_label: Label
var people_label: Label
var heat_bar: ProgressBar
var fuel_bar: ProgressBar
var morale_bar: ProgressBar
var day_progress: ProgressBar
var furnace_label: Label

var selected_title: Label
var selected_detail: Label
var selected_preview: TextureRect
var selected_role: Label
var selected_output: Label
var selected_risk: Label
var condition_bar: ProgressBar
var readiness_bar: ProgressBar
var ability_list: HFlowContainer
var ability_scroll: ScrollContainer
var worker_minus: Button
var worker_plus: Button
var collect_btn: Button
var upgrade_btn: Button
var move_btn: Button
var worker_count_label: Label
var sheet_body: VBoxContainer

var build_panel: PanelContainer
var survivors_panel: PanelContainer
var missions_panel: PanelContainer
var more_panel: PanelContainer
var build_list: VBoxContainer
var survivor_list: VBoxContainer
var mission_list: VBoxContainer
var log_list: VBoxContainer
var mission_strip_list: HBoxContainer

var pause_btn: Button
var speed_btn: Button
var nav_buttons := {}

var selected_building := "cabin"
var placing_building_id := ""
var placement_cell := Vector2i.ZERO
var move_mode := false
var placement_layer: Control
var placement_preview: TextureRect
var ability_rebuild_queued := false
var world_rebuild_queued := false
var ui_ready := false
var compact_layout := false
var active_tab := ""
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
var _bubble_pulse := 0.0
var _toast_timer := 0.0
var _map_dragging := false
var _map_drag_last := Vector2.ZERO
var _hud_bottom := 120.0
var _sheet_open := true

func _ready() -> void:
	randomize()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	clip_contents = false
	game = GameStateScript.new()
	_build_interface()
	resized.connect(_apply_responsive_layout)
	game.changed.connect(_refresh)
	game.choice_requested.connect(_on_choice_requested)
	game.game_ended.connect(_on_game_ended)
	game.tutorial_step.connect(_on_tutorial_step)
	game.resources_collected.connect(_on_resources_collected)
	game.storm_warning.connect(_on_storm_warning)
	game.toast.connect(_show_toast)
	if game.has_save():
		game.set_paused(true)
		_show_toast("Welcome back — open More → Load City")
	else:
		game.start_new_game()
	call_deferred("_center_map_on_cabin")
	call_deferred("_apply_responsive_layout")
	_refresh()

func _process(delta: float) -> void:
	if game == null:
		return
	game.tick(delta)
	_bubble_pulse += delta
	if day_progress:
		day_progress.value = game.DAY_LENGTH - game.seconds_until_day
	if _toast_timer > 0.0:
		_toast_timer -= delta
		if _toast_timer <= 0.0 and toast_label:
			toast_label.visible = false
	_update_bubble_pulse()
	_update_storm_visuals()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var ke := event as InputEventKey
	if not ke.pressed or ke.echo:
		return
	if ke.keycode == KEY_P and placing_building_id == "":
		game.toggle_pause()
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return
	if ke.keycode == KEY_1:
		game.set_time_scale(1.0)
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return
	if ke.keycode == KEY_2:
		game.set_time_scale(2.0)
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return
	if ke.keycode == KEY_3:
		game.set_time_scale(3.0)
		_play_sfx(SFX_SWITCH)
		get_viewport().set_input_as_handled()
		return
	if ke.keycode == KEY_C and placing_building_id == "":
		_on_collect_all()
		get_viewport().set_input_as_handled()
		return

	var direction := Vector2i.ZERO
	match ke.physical_keycode:
		KEY_W, KEY_UP: direction = Vector2i.UP
		KEY_S, KEY_DOWN: direction = Vector2i.DOWN
		KEY_A, KEY_LEFT: direction = Vector2i.LEFT
		KEY_D, KEY_RIGHT: direction = Vector2i.RIGHT

	if placing_building_id != "" and direction != Vector2i.ZERO:
		placement_cell = Vector2i(
			clampi(placement_cell.x + direction.x, 0, WORLD_COLUMNS - 1),
			clampi(placement_cell.y + direction.y, 0, WORLD_ROWS - 1)
		)
		_update_placement_preview_for_cell(placement_cell)
		get_viewport().set_input_as_handled()
	elif placing_building_id != "" and (ke.keycode == KEY_ENTER or ke.keycode == KEY_KP_ENTER or ke.keycode == KEY_SPACE):
		_handle_map_cell_pressed(placement_cell)
		get_viewport().set_input_as_handled()
	elif placing_building_id != "" and ke.keycode == KEY_ESCAPE:
		_cancel_build_placement()
		get_viewport().set_input_as_handled()
	elif ke.keycode == KEY_ESCAPE:
		_close_all_panels()
		get_viewport().set_input_as_handled()
	elif direction != Vector2i.ZERO and map_scroll:
		var step := KEYBOARD_PAN_STEP * (3 if ke.shift_pressed else 1)
		map_scroll.scroll_horizontal += direction.x * step
		map_scroll.scroll_vertical += direction.y * step
		get_viewport().set_input_as_handled()

# =============================================================================
# INTERFACE BUILD
# =============================================================================

func _build_interface() -> void:
	add_theme_font_override("font", FONT_FUTURE)
	sfx_player = AudioStreamPlayer.new()
	sfx_player.volume_db = -6.0
	add_child(sfx_player)

	var bg: Control = BackgroundScript.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var map_root := Control.new()
	map_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	map_root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(map_root)

	map_scroll = ScrollContainer.new()
	map_scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	map_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	map_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	map_scroll.gui_input.connect(_on_map_gui_input)
	map_root.add_child(map_scroll)

	world_grid = Control.new()
	world_grid.custom_minimum_size = Vector2(WORLD_COLUMNS * TILE_PIXEL, WORLD_ROWS * TILE_PIXEL)
	world_grid.mouse_filter = Control.MOUSE_FILTER_STOP
	map_scroll.add_child(world_grid)
	_build_world_grid(world_grid)

	snow_overlay = SnowOverlayScript.new()
	snow_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	snow_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_root.add_child(snow_overlay)

	overlay_root = Control.new()
	overlay_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay_root.z_index = 10
	add_child(overlay_root)

	_build_top_hud()
	_build_storm_banner()
	_build_mission_strip()
	_build_sheet()
	_build_bottom_nav()
	_build_side_panels()
	_build_toasts()
	_build_modals()

	ui_ready = true
	_apply_responsive_layout()

func _build_top_hud() -> void:
	top_bar = PanelContainer.new()
	top_bar.mouse_filter = Control.MOUSE_FILTER_STOP
	top_bar.z_index = 30
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_bar.offset_left = HUD_MARGIN
	top_bar.offset_top = HUD_MARGIN
	top_bar.offset_right = -HUD_MARGIN
	top_bar.offset_bottom = 0
	top_bar.grow_vertical = Control.GROW_DIRECTION_BEGIN
	top_bar.add_theme_stylebox_override("panel", _style(Color(0.02, 0.08, 0.14, 0.94), Color(0.45, 0.78, 0.95, 0.45), 12))
	overlay_root.add_child(top_bar)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 5)
	top_bar.add_child(root)

	var row1 := HBoxContainer.new()
	row1.add_theme_constant_override("separation", 6)
	root.add_child(row1)

	var title := Label.new()
	title.text = "FROSTFALL"
	title.add_theme_color_override("font_color", Color("#f4fbff"))
	title.add_theme_font_size_override("font_size", 16)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row1.add_child(title)

	day_label = _chip("D1")
	row1.add_child(day_label)
	season_label = _chip("EARLY")
	row1.add_child(season_label)
	people_label = _chip("0/8")
	people_label.tooltip_text = "Idle / total survivors"
	row1.add_child(people_label)
	power_label = _chip("P0")
	power_label.tooltip_text = "Settlement power"
	row1.add_child(power_label)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row1.add_child(spacer)

	pause_btn = _icon_btn(ICON_PAUSE, _on_pause)
	pause_btn.tooltip_text = "Pause (P)"
	row1.add_child(pause_btn)
	speed_btn = _icon_btn(ICON_FF, _on_speed)
	speed_btn.tooltip_text = "Cycle speed (1/2/3)"
	row1.add_child(speed_btn)

	day_progress = ProgressBar.new()
	day_progress.min_value = 0
	day_progress.max_value = 24
	day_progress.custom_minimum_size = Vector2(72, 18)
	day_progress.show_percentage = false
	day_progress.tooltip_text = "Day progress"
	day_progress.add_theme_stylebox_override("background", _meter_bg())
	day_progress.add_theme_stylebox_override("fill", _meter_fill(Color("#5ec4f0")))
	row1.add_child(day_progress)

	# Resources as wrap flow — no clip overflow
	var row2 := HFlowContainer.new()
	row2.add_theme_constant_override("separation", 4)
	row2.add_theme_constant_override("v_separation", 4)
	root.add_child(row2)
	for res in RESOURCE_ORDER:
		var chip := PanelContainer.new()
		chip.custom_minimum_size = Vector2(78, 26)
		chip.add_theme_stylebox_override("panel", _style_tight(Color(0.06, 0.14, 0.2, 0.95), RESOURCE_COLORS[res], 6))
		row2.add_child(chip)
		var lbl := Label.new()
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.add_theme_color_override("font_color", Color("#eef8ff"))
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.text = "%s 0" % RESOURCE_LABELS[res]
		chip.add_child(lbl)
		resource_labels[res] = lbl
		resource_bars[res] = chip

	var row3 := HBoxContainer.new()
	row3.add_theme_constant_override("separation", 6)
	root.add_child(row3)

	furnace_label = Label.new()
	furnace_label.text = "Heat"
	furnace_label.add_theme_color_override("font_color", Color("#f0c080"))
	furnace_label.add_theme_font_size_override("font_size", 11)
	furnace_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	furnace_label.custom_minimum_size = Vector2(40, 0)
	row3.add_child(furnace_label)

	heat_bar = _named_bar("Furnace heat", Color("#f0a44a"))
	heat_bar.custom_minimum_size = Vector2(80, 22)
	row3.add_child(heat_bar)
	fuel_bar = _named_bar("Furnace fuel", Color("#c47a3a"))
	fuel_bar.custom_minimum_size = Vector2(80, 22)
	row3.add_child(fuel_bar)
	morale_bar = _named_bar("City morale", Color("#77d37b"))
	morale_bar.custom_minimum_size = Vector2(80, 22)
	row3.add_child(morale_bar)

func _build_storm_banner() -> void:
	storm_banner = PanelContainer.new()
	storm_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	storm_banner.visible = false
	storm_banner.z_index = 28
	storm_banner.anchor_left = 0.0
	storm_banner.anchor_right = 1.0
	storm_banner.offset_left = HUD_MARGIN + 20
	storm_banner.offset_right = -(HUD_MARGIN + 20)
	storm_banner.add_theme_stylebox_override("panel", _style_tight(Color(0.4, 0.12, 0.1, 0.94), Color("#ff8a6a"), 8))
	overlay_root.add_child(storm_banner)
	var lbl := Label.new()
	lbl.name = "StormText"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.add_theme_color_override("font_color", Color("#ffe8e0"))
	lbl.add_theme_font_size_override("font_size", 12)
	storm_banner.add_child(lbl)

func _build_mission_strip() -> void:
	mission_strip = PanelContainer.new()
	mission_strip.mouse_filter = Control.MOUSE_FILTER_STOP
	mission_strip.z_index = 27
	mission_strip.anchor_left = 0.0
	mission_strip.anchor_right = 1.0
	mission_strip.offset_left = HUD_MARGIN
	mission_strip.offset_right = -HUD_MARGIN
	mission_strip.custom_minimum_size = Vector2(0, 36)
	mission_strip.add_theme_stylebox_override("panel", _style_tight(Color(0.04, 0.12, 0.18, 0.88), Color(0.5, 0.85, 1.0, 0.3), 8))
	overlay_root.add_child(mission_strip)
	var scroll := ScrollContainer.new()
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.custom_minimum_size = Vector2(0, 28)
	mission_strip.add_child(scroll)
	mission_strip_list = HBoxContainer.new()
	mission_strip_list.add_theme_constant_override("separation", 6)
	scroll.add_child(mission_strip_list)

func _build_sheet() -> void:
	sheet_panel = PanelContainer.new()
	sheet_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	sheet_panel.z_index = 25
	sheet_panel.clip_contents = true
	sheet_panel.anchor_left = 0.0
	sheet_panel.anchor_right = 1.0
	sheet_panel.anchor_top = 1.0
	sheet_panel.anchor_bottom = 1.0
	sheet_panel.add_theme_stylebox_override("panel", _style(Color(0.03, 0.09, 0.14, 0.96), Color(0.55, 0.88, 1.0, 0.4), 12))
	overlay_root.add_child(sheet_panel)

	sheet_body = VBoxContainer.new()
	sheet_body.add_theme_constant_override("separation", 5)
	sheet_panel.add_child(sheet_body)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	sheet_body.add_child(header)

	selected_preview = TextureRect.new()
	selected_preview.custom_minimum_size = Vector2(56, 48)
	selected_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	selected_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	selected_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	header.add_child(selected_preview)

	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(titles)
	selected_title = Label.new()
	selected_title.add_theme_color_override("font_color", Color("#f5fbff"))
	selected_title.add_theme_font_size_override("font_size", 16)
	selected_title.clip_text = true
	titles.add_child(selected_title)
	selected_detail = Label.new()
	selected_detail.add_theme_color_override("font_color", Color("#9fd0e4"))
	selected_detail.add_theme_font_size_override("font_size", 11)
	selected_detail.clip_text = true
	titles.add_child(selected_detail)

	collect_btn = _action_btn("COLLECT", ICON_STAR, _on_collect_selected, Color("#1f8a6a"))
	collect_btn.custom_minimum_size = Vector2(96, 42)
	collect_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	header.add_child(collect_btn)

	# Compact stats row — one line role, meters
	var info := HBoxContainer.new()
	info.add_theme_constant_override("separation", 8)
	sheet_body.add_child(info)

	var text_col := VBoxContainer.new()
	text_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(text_col)
	selected_role = Label.new()
	selected_role.add_theme_color_override("font_color", Color("#e8f6ff"))
	selected_role.add_theme_font_size_override("font_size", 11)
	selected_role.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_role.max_lines_visible = 1
	text_col.add_child(selected_role)
	selected_output = Label.new()
	selected_output.add_theme_color_override("font_color", Color("#8fd0a8"))
	selected_output.add_theme_font_size_override("font_size", 10)
	selected_output.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_output.max_lines_visible = 1
	text_col.add_child(selected_output)
	selected_risk = Label.new()
	selected_risk.add_theme_color_override("font_color", Color("#f0c080"))
	selected_risk.add_theme_font_size_override("font_size", 10)
	selected_risk.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_risk.max_lines_visible = 1
	text_col.add_child(selected_risk)

	condition_bar = _named_bar("Building condition", Color("#75d4d0"))
	condition_bar.custom_minimum_size = Vector2(88, 28)
	condition_bar.size_flags_horizontal = Control.SIZE_SHRINK_END
	info.add_child(condition_bar)
	readiness_bar = _named_bar("Order readiness", Color("#7cc8ff"))
	readiness_bar.custom_minimum_size = Vector2(88, 28)
	readiness_bar.size_flags_horizontal = Control.SIZE_SHRINK_END
	info.add_child(readiness_bar)

	var workers := HBoxContainer.new()
	workers.add_theme_constant_override("separation", 6)
	sheet_body.add_child(workers)
	var wl := Label.new()
	wl.text = "Crew"
	wl.add_theme_color_override("font_color", Color("#cfe9f5"))
	wl.add_theme_font_size_override("font_size", 12)
	wl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	workers.add_child(wl)
	worker_minus = _icon_btn(ICON_MINUS, func() -> void:
		_play_sfx(SFX_TAP)
		game.assign_worker(selected_building, -1)
	)
	worker_minus.tooltip_text = "Remove worker"
	workers.add_child(worker_minus)
	worker_count_label = Label.new()
	worker_count_label.custom_minimum_size = Vector2(48, 0)
	worker_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	worker_count_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	worker_count_label.add_theme_color_override("font_color", Color("#e8f6ff"))
	worker_count_label.add_theme_font_size_override("font_size", 13)
	workers.add_child(worker_count_label)
	worker_plus = _icon_btn(ICON_PLUS, func() -> void:
		_play_sfx(SFX_TAP)
		game.assign_worker(selected_building, 1)
	)
	worker_plus.tooltip_text = "Assign worker"
	workers.add_child(worker_plus)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	workers.add_child(spacer)

	upgrade_btn = _action_btn("Upgrade", ICON_WRENCH, func() -> void:
		_play_sfx(SFX_CLICK)
		game.upgrade(selected_building)
	, Color("#a36a25"))
	upgrade_btn.custom_minimum_size = Vector2(100, 38)
	upgrade_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	workers.add_child(upgrade_btn)
	move_btn = _action_btn("Move", ICON_TARGET, _toggle_move_mode, Color("#6a5a9b"))
	move_btn.custom_minimum_size = Vector2(84, 38)
	move_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	workers.add_child(move_btn)

	ability_scroll = ScrollContainer.new()
	ability_scroll.custom_minimum_size = Vector2(0, 72)
	ability_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ability_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sheet_body.add_child(ability_scroll)
	ability_list = HFlowContainer.new()
	ability_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ability_list.add_theme_constant_override("separation", 6)
	ability_list.add_theme_constant_override("v_separation", 6)
	ability_scroll.add_child(ability_list)

func _build_bottom_nav() -> void:
	bottom_nav = PanelContainer.new()
	bottom_nav.mouse_filter = Control.MOUSE_FILTER_STOP
	bottom_nav.z_index = 30
	bottom_nav.anchor_left = 0.0
	bottom_nav.anchor_right = 1.0
	bottom_nav.anchor_top = 1.0
	bottom_nav.anchor_bottom = 1.0
	bottom_nav.offset_left = HUD_MARGIN
	bottom_nav.offset_right = -HUD_MARGIN
	bottom_nav.offset_top = -NAV_HEIGHT
	bottom_nav.offset_bottom = -HUD_MARGIN
	bottom_nav.add_theme_stylebox_override("panel", _style(Color(0.02, 0.07, 0.12, 0.97), Color(0.4, 0.75, 0.95, 0.35), 12))
	overlay_root.add_child(bottom_nav)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	bottom_nav.add_child(row)

	nav_buttons["build"] = _nav_btn("Build", ICON_PLUS, Color("#1f7fab"), _toggle_build)
	nav_buttons["survivors"] = _nav_btn("People", ICON_SINGLE, Color("#3a6b8a"), _toggle_survivors)
	nav_buttons["missions"] = _nav_btn("Missions", ICON_STAR, Color("#356b5f"), _toggle_missions)
	nav_buttons["collect"] = _nav_btn("Collect", ICON_CHECK, Color("#1f8a5a"), _on_collect_all)
	nav_buttons["more"] = _nav_btn("More", ICON_MENU, Color("#5a5f75"), _toggle_more)
	for k in ["build", "survivors", "missions", "collect", "more"]:
		row.add_child(nav_buttons[k])

func _build_side_panels() -> void:
	build_panel = _make_panel("BUILD CITY", 0)
	build_list = build_panel.get_meta("list")
	for building_id in game.building_ids():
		var row := _make_building_row(building_id)
		building_rows[building_id] = row
		build_list.add_child(row["container"])

	survivors_panel = _make_panel("SURVIVORS", 1)
	survivor_list = survivors_panel.get_meta("list")

	missions_panel = _make_panel("MISSIONS & LOG", 2)
	mission_list = VBoxContainer.new()
	mission_list.add_theme_constant_override("separation", 6)
	missions_panel.get_meta("list").add_child(mission_list)
	var log_h := Label.new()
	log_h.text = "Dispatch Log"
	log_h.add_theme_color_override("font_color", Color("#153247"))
	log_h.add_theme_font_size_override("font_size", 14)
	missions_panel.get_meta("list").add_child(log_h)
	log_list = VBoxContainer.new()
	log_list.add_theme_constant_override("separation", 4)
	missions_panel.get_meta("list").add_child(log_list)

	more_panel = _make_panel("COMMAND", 3)
	var more_list: VBoxContainer = more_panel.get_meta("list")
	more_list.add_child(_action_btn("Save City", ICON_SAVE, _on_save, Color("#356b5f")))
	more_list.add_child(_action_btn("Load City", ICON_HOME, _on_load, Color("#425f75")))
	more_list.add_child(_action_btn("New Game", ICON_PLUS, _on_new_game, Color("#7a4a3a")))
	more_list.add_child(_action_btn("Expedition", ICON_TARGET, func() -> void:
		_play_sfx(SFX_CLICK)
		game.send_expedition()
	, Color("#2f6b62")))
	more_list.add_child(_action_btn("Stoke Furnace (Wood)", ICON_WRENCH, func() -> void:
		_play_sfx(SFX_CLICK)
		game.repair_hearth()
	, Color("#a36a25")))
	map_status_label = Label.new()
	map_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	map_status_label.add_theme_color_override("font_color", Color("#2a4a5c"))
	map_status_label.add_theme_font_size_override("font_size", 12)
	map_status_label.text = "WASD pan · P pause · 1/2/3 speed · C collect all · Esc close"
	more_list.add_child(map_status_label)

func _build_toasts() -> void:
	toast_label = Label.new()
	toast_label.visible = false
	toast_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast_label.z_index = 40
	toast_label.anchor_left = 0.15
	toast_label.anchor_right = 0.85
	toast_label.offset_top = 170
	toast_label.offset_bottom = 200
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	toast_label.add_theme_color_override("font_color", Color("#fff8e0"))
	toast_label.add_theme_font_size_override("font_size", 13)
	toast_label.add_theme_stylebox_override("normal", _style_tight(Color(0.05, 0.14, 0.12, 0.94), Color("#9ff0c8"), 8))
	overlay_root.add_child(toast_label)

func _make_panel(title_text: String, _idx: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.visible = false
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.z_index = 35
	panel.clip_contents = true
	panel.anchor_left = 0.0
	panel.anchor_right = 1.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_left = HUD_MARGIN
	panel.offset_right = -HUD_MARGIN
	panel.offset_top = 120
	panel.offset_bottom = -(NAV_HEIGHT + HUD_MARGIN)
	panel.add_theme_stylebox_override("panel", _style(Color(0.95, 0.98, 1.0, 0.99), Color(1, 1, 1, 0.75), 12))
	overlay_root.add_child(panel)

	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 8)
	panel.add_child(outer)

	var head := HBoxContainer.new()
	outer.add_child(head)
	var title := Label.new()
	title.text = title_text
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", Color("#153247"))
	title.add_theme_font_size_override("font_size", 18)
	head.add_child(title)
	var close := _icon_btn(ICON_MINUS, _close_all_panels)
	close.tooltip_text = "Close"
	head.add_child(close)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer.add_child(scroll)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 8)
	scroll.add_child(list)
	panel.set_meta("list", list)
	return panel

# =============================================================================
# WORLD MAP
# =============================================================================

func _build_world_grid(board: Control) -> void:
	building_buttons.clear()
	building_badges.clear()
	bubble_buttons.clear()
	map_tiles.clear()
	map_detail_buttons.clear()
	placement_layer = null
	placement_preview = null
	var terrain := _make_terrain()

	for y in range(WORLD_ROWS):
		for x in range(WORLD_COLUMNS):
			var pos := Vector2i(x, y)
			var tile := TextureButton.new()
			tile.position = Vector2(x * TILE_PIXEL, y * TILE_PIXEL)
			tile.custom_minimum_size = Vector2(TILE_PIXEL, TILE_PIXEL)
			tile.size = Vector2(TILE_PIXEL, TILE_PIXEL)
			tile.stretch_mode = TextureButton.STRETCH_SCALE
			tile.texture_normal = _terrain_texture(terrain[y][x])
			var base_mod := _terrain_modulate(terrain[y][x])
			tile.modulate = base_mod
			tile.set_meta("cell", pos)
			tile.set_meta("base_modulate", base_mod)
			tile.disabled = not _placement_active()
			tile.pressed.connect(_handle_map_cell_pressed.bind(pos))
			map_tiles.append(tile)
			board.add_child(tile)

	for detail in MAP_DETAILS:
		_add_map_detail(board, detail)
	for building_id in building_positions.keys():
		if game.has_building(building_id):
			_add_building_sprite(board, building_id)
	_add_placement_layer(board)

func _add_map_detail(board: Control, detail: Dictionary) -> void:
	var cell: Vector2i = detail["cell"]
	var tex: Texture2D = detail["texture"]
	var draw_size := _capped_tex_size(tex, DETAIL_TEXTURE_SCALE, DETAIL_MAX_PX)
	var center := Vector2(cell.x * TILE_PIXEL + TILE_PIXEL * 0.5, cell.y * TILE_PIXEL + TILE_PIXEL * 0.5)
	var btn := TextureButton.new()
	btn.position = center - draw_size * 0.5
	btn.custom_minimum_size = draw_size
	btn.size = draw_size
	btn.ignore_texture_size = true
	btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	btn.texture_normal = tex
	btn.tooltip_text = "Scout: %s" % detail["name"]
	btn.pressed.connect(_handle_map_detail_pressed.bind(detail))
	btn.z_index = 1
	map_detail_buttons.append(btn)
	board.add_child(btn)

func _add_building_sprite(board: Control, building_id: String) -> void:
	var tex := _building_texture(building_id)
	var level := int(game.buildings[building_id]["level"])
	var tier := mini(level - 1, 2)
	var scale := BUILDING_TEXTURE_SCALE + float(tier) * 0.04
	var sprite_size := _capped_tex_size(tex, scale, BUILDING_MAX_PX)
	var plot: Vector2i = building_positions[building_id]
	var center := Vector2(plot.x * TILE_PIXEL + TILE_PIXEL * 0.5, plot.y * TILE_PIXEL + TILE_PIXEL * 0.5)

	var btn := TextureButton.new()
	btn.position = center - sprite_size * 0.5
	btn.custom_minimum_size = sprite_size
	btn.size = sprite_size
	btn.ignore_texture_size = true
	btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	btn.texture_normal = tex
	btn.tooltip_text = game.buildings[building_id]["name"]
	btn.pressed.connect(_select_building.bind(building_id))
	btn.z_index = 3
	building_buttons[building_id] = btn
	board.add_child(btn)

	var badge := Label.new()
	badge.text = ""
	badge.visible = false
	badge.position = Vector2(btn.position.x, btn.position.y + sprite_size.y - 4)
	badge.custom_minimum_size = Vector2(maxi(40, int(sprite_size.x * 0.7)), 16)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_color_override("font_color", Color("#0b2534"))
	badge.add_theme_font_size_override("font_size", 9)
	badge.add_theme_stylebox_override("normal", _badge(Color("#9ff0ff")))
	badge.z_index = 5
	building_badges[building_id] = badge
	board.add_child(badge)

	# Collection bubble — top-right of building, never covers badge
	var bubble := Button.new()
	bubble.text = "+"
	bubble.visible = false
	bubble.focus_mode = Control.FOCUS_NONE
	bubble.position = Vector2(btn.position.x + sprite_size.x - 18, btn.position.y - 10)
	bubble.custom_minimum_size = Vector2(40, 26)
	bubble.add_theme_font_size_override("font_size", 10)
	bubble.add_theme_stylebox_override("normal", _style_tight(Color(0.08, 0.42, 0.28, 0.96), Color("#9ff0c8"), 12))
	bubble.add_theme_stylebox_override("hover", _style_tight(Color(0.12, 0.55, 0.36, 0.98), Color("#c8ffe0"), 12))
	bubble.add_theme_stylebox_override("pressed", _style_tight(Color(0.06, 0.32, 0.22, 0.98), Color("#7fd8b0"), 12))
	bubble.add_theme_color_override("font_color", Color.WHITE)
	bubble.z_index = 7
	bubble.pressed.connect(_on_collect_building.bind(building_id))
	bubble_buttons[building_id] = bubble
	board.add_child(bubble)

func _add_placement_layer(board: Control) -> void:
	placement_layer = Control.new()
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
	placement_preview.visible = false
	placement_layer.add_child(placement_preview)

func _make_terrain() -> Array:
	var terrain := []
	for y in range(WORLD_ROWS):
		var row := []
		for x in range(WORLD_COLUMNS):
			var id := 0
			if x == 16 and y >= 8 and y <= 28:
				id = 4  # vertical road
			elif y == 16 and x >= 8 and x <= 26:
				id = 2  # horizontal road
			elif x >= 14 and x <= 18 and y >= 10 and y <= 14:
				id = 3  # clearing plaza
			elif (x + y * 3) % 11 == 0:
				id = 1
			row.append(id)
		terrain.append(row)
	for p in [Vector2i(2, 2), Vector2i(6, 4), Vector2i(27, 3), Vector2i(30, 8), Vector2i(3, 30), Vector2i(28, 32)]:
		if p.y < WORLD_ROWS and p.x < WORLD_COLUMNS:
			terrain[p.y][p.x] = 10
	for p in [Vector2i(13, 14), Vector2i(14, 14), Vector2i(15, 14), Vector2i(19, 15), Vector2i(20, 15)]:
		terrain[p.y][p.x] = 70
	return terrain

func _terrain_texture(id: int) -> Texture2D:
	match id:
		1: return TERRAIN_SNOW_ROUGH
		2: return TERRAIN_ROAD_HORIZONTAL
		3: return TERRAIN_CLEARING
		4: return TERRAIN_ROAD_VERTICAL
		10: return TERRAIN_PINE
		70: return TERRAIN_LOGS
	return TERRAIN_SNOW

func _terrain_modulate(id: int) -> Color:
	match id:
		0: return Color("#e5f4f8")
		1: return Color("#f6fbff")
	return Color.WHITE

# =============================================================================
# REFRESH
# =============================================================================

func _refresh() -> void:
	if not ui_ready:
		return
	_ensure_selected_building()
	_sync_building_positions()

	day_label.text = "D%s" % game.day
	season_label.text = game.season.replace(" Winter", "").to_upper()
	people_label.text = "%s/%s" % [game.available_workers, game.homesteaders]
	power_label.text = "P%s" % game.settlement_power()
	day_progress.max_value = game.DAY_LENGTH
	day_progress.value = game.DAY_LENGTH - game.seconds_until_day
	heat_bar.value = game.heat
	fuel_bar.value = game.furnace_fuel
	morale_bar.value = game.morale
	furnace_label.text = "FURN %.0f°" % game.heat

	if pause_btn:
		pause_btn.modulate = Color(1.3, 1.1, 0.7) if game.paused else Color.WHITE
	if speed_btn:
		speed_btn.tooltip_text = "%sx" % game.time_scale

	for res in RESOURCE_ORDER:
		var amt := int(game.resources.get(res, 0))
		var cap := int(game.storage_capacity(res))
		resource_labels[res].text = "%s %s" % [RESOURCE_LABELS[res], amt]
		resource_labels[res].tooltip_text = "%s: %s / %s capacity" % [res.capitalize(), amt, cap]
		var low := amt < maxi(1, int(cap * 0.2))
		resource_bars[res].add_theme_stylebox_override("panel", _style_tight(
			Color(0.38, 0.14, 0.1, 0.95) if low else Color(0.06, 0.14, 0.2, 0.95),
			RESOURCE_COLORS[res], 6
		))

	# Storm + mission strip content
	var days_storm := game.days_until_storm()
	var storm_txt: Label = storm_banner.get_node_or_null("StormText")
	if storm_txt:
		if game.storm_active_days > 0:
			storm_banner.visible = true
			storm_txt.text = "⚠ %s ACTIVE — stoke the furnace!" % game.storm_intensity.to_upper()
		elif days_storm >= 0 and days_storm <= 2:
			storm_banner.visible = true
			storm_txt.text = "⚠ %s in %s day(s) — stock fuel & food" % [game.storm_intensity.to_upper(), days_storm]
		else:
			storm_banner.visible = false

	for c in mission_strip_list.get_children():
		c.queue_free()
	for goal in game.active_missions():
		var chip := Label.new()
		chip.text = " %s · %s " % [goal["title"], goal["progress"]]
		chip.add_theme_color_override("font_color", Color("#e8f8ff"))
		chip.add_theme_font_size_override("font_size", 11)
		chip.add_theme_stylebox_override("normal", _style_tight(Color(0.08, 0.25, 0.32, 0.92), Color("#6ad0f0"), 6))
		mission_strip_list.add_child(chip)
	if mission_strip_list.get_child_count() == 0:
		var chip := Label.new()
		chip.text = " All chapter missions clear "
		chip.add_theme_color_override("font_color", Color("#c8f0d8"))
		chip.add_theme_font_size_override("font_size", 11)
		mission_strip_list.add_child(chip)

	_layout_hud_stack()

	if not game.has_building(selected_building):
		return

	var b: Dictionary = game.buildings[selected_building]
	selected_preview.texture = _building_texture(selected_building)
	selected_title.text = String(b["name"])
	selected_detail.text = "Lv%s · %s/%s crew · %s" % [
		b["level"], b["workers"], b["max_workers"], game.building_status_text(selected_building)
	]
	var details := game.building_details(selected_building)
	selected_role.text = details["role"]
	selected_output.text = "%s · %s" % [details["output"], _fmt_prod(game.production_preview(selected_building))]
	selected_risk.text = details["risk"]
	condition_bar.value = float(b["condition"])
	readiness_bar.value = float(b["readiness"])
	var op := game.is_building_operational(selected_building)
	if worker_count_label:
		worker_count_label.text = "%s/%s" % [b["workers"], b["max_workers"]]
	worker_plus.disabled = game.game_over or not op or game.available_workers <= 0 or int(b["workers"]) >= int(b["max_workers"])
	worker_minus.disabled = game.game_over or not op or int(b["workers"]) <= 0
	var bubble_sel := game.bubble_total(selected_building)
	collect_btn.disabled = bubble_sel < 1.0
	collect_btn.text = "Collect" if bubble_sel < 1.0 else "Take %.0f" % bubble_sel
	if upgrade_btn:
		upgrade_btn.disabled = not game.can_upgrade(selected_building)
		var uc := game.upgrade_cost(selected_building)
		upgrade_btn.tooltip_text = "Upgrade: %s" % _fmt_cost(uc)
	if move_btn:
		move_btn.disabled = game.game_over or not op
		move_btn.text = "Moving…" if move_mode else "Move"
	_queue_ability_rebuild()

	# Build rows
	for building_id in building_rows.keys():
		var row: Dictionary = building_rows[building_id]
		if game.has_building(building_id):
			var bb: Dictionary = game.buildings[building_id]
			var cost := game.upgrade_cost(building_id)
			row["icon"].texture = _building_texture(building_id)
			row["icon"].modulate = Color.WHITE
			row["info"].text = "%s%s L%s\n%s/%s · %s%% HP\n%s · Up %sw %st" % [
				"> " if building_id == selected_building else "",
				bb["name"], bb["level"], bb["workers"], bb["max_workers"], int(bb["condition"]),
				game.building_status_text(building_id), cost.get("wood", 0), cost.get("tools", 0),
			]
			row["plus"].visible = true
			row["minus"].visible = true
			row["upgrade"].visible = true
			row["build"].visible = false
			row["plus"].disabled = not game.is_building_operational(building_id) or game.available_workers <= 0 or int(bb["workers"]) >= int(bb["max_workers"])
			row["minus"].disabled = not game.is_building_operational(building_id) or int(bb["workers"]) <= 0
			row["upgrade"].disabled = not game.can_upgrade(building_id)
		else:
			row["icon"].texture = _blueprint_texture(building_id)
			row["icon"].modulate = Color(0.7, 0.82, 0.9, 0.65)
			row["info"].text = "%s\n%s\nCost: %s" % [
				game.building_name(building_id), game.building_status_text(building_id), _fmt_cost(game.build_cost(building_id))
			]
			row["plus"].visible = false
			row["minus"].visible = false
			row["upgrade"].visible = false
			row["build"].visible = true
			row["build"].disabled = not game.can_build(building_id)
			row["build"].icon = ICON_LOCKED if not game.is_building_unlocked(building_id) else ICON_PLUS

	# Map building visuals
	for building_id in building_buttons.keys():
		if not game.has_building(building_id):
			continue
		var bb: Dictionary = game.buildings[building_id]
		var btn: TextureButton = building_buttons[building_id]
		var badge: Label = building_badges[building_id]
		btn.texture_normal = _building_texture(building_id)
		var bubble_amt := game.bubble_total(building_id)
		if bubble_buttons.has(building_id):
			var bub: Button = bubble_buttons[building_id]
			bub.visible = bubble_amt >= 1.0
			if bub.visible:
				var parts: Array[String] = []
				var amounts := game.bubble_amounts(building_id)
				for k in amounts.keys():
					if float(amounts[k]) >= 1.0:
						parts.append("%s%s" % [int(amounts[k]), RESOURCE_LABELS.get(str(k), str(k))[0]])
				bub.text = " ".join(parts) if not parts.is_empty() else "●"
		var under := bool(bb.get("under_construction", false))
		var upgrading: bool = str(game.active_project.get("building_id", "")) == building_id
		if under or upgrading:
			badge.visible = true
			badge.text = "%s%%" % int(game.project_progress() * 100.0)
			badge.add_theme_stylebox_override("normal", _badge(Color("#f0c36a")))
			btn.modulate = Color(0.85, 0.9, 1.0, 0.78)
		elif float(bb["condition"]) < 30.0:
			badge.visible = true
			badge.text = "WEAK"
			badge.add_theme_stylebox_override("normal", _badge(Color("#f08a6a")))
			btn.modulate = Color(1.12, 0.86, 0.82)
		elif float(bb["readiness"]) >= 100.0 and bubble_amt < 1.0:
			badge.visible = true
			badge.text = "ORDER"
			badge.add_theme_stylebox_override("normal", _badge(Color("#9ff0ff")))
			btn.modulate = Color("#d8fff1") if building_id != selected_building else Color(1.35, 1.35, 1.35)
		else:
			# Bubble handles collect; badge stays hidden to avoid double clutter
			badge.visible = false
			btn.modulate = Color(1.35, 1.35, 1.35) if building_id == selected_building else Color(0.96, 1.0, 1.04)

	for i in range(map_detail_buttons.size()):
		if i >= MAP_DETAILS.size():
			break
		var d: Dictionary = MAP_DETAILS[i]
		var db: TextureButton = map_detail_buttons[i]
		if game.scouted_sites.has(d["id"]):
			db.modulate = Color(0.5, 0.6, 0.65, 0.5)
			db.tooltip_text = "%s (scouted)" % d["name"]
		else:
			db.modulate = Color.WHITE
			db.tooltip_text = d["name"]

	# Survivors panel
	if survivors_panel.visible:
		_rebuild_survivor_list()

	# Missions + log
	for c in mission_list.get_children():
		c.queue_free()
	for goal in game.survival_goals():
		mission_list.add_child(_goal_card(goal))
	for c in log_list.get_children():
		c.queue_free()
	for i in range(mini(10, game.event_log.size())):
		log_list.add_child(_event_card(game.event_log[i], i))

	if game.game_over:
		sheet_panel.modulate = Color(0.75, 0.75, 0.75)
	else:
		sheet_panel.modulate = Color.WHITE

	# Collect nav highlight when bubbles waiting
	if nav_buttons.has("collect"):
		nav_buttons["collect"].modulate = Color(1.25, 1.35, 1.15) if game.has_any_bubbles() else Color.WHITE

func _rebuild_survivor_list() -> void:
	for c in survivor_list.get_children():
		c.queue_free()
	var summary := Label.new()
	summary.text = "Idle %s · Sick %s · Total %s" % [game.idle_survivor_count(), game.sick_survivor_count(), game.homesteaders]
	summary.add_theme_color_override("font_color", Color("#153247"))
	summary.add_theme_font_size_override("font_size", 13)
	survivor_list.add_child(summary)
	for s in game.survivor_list():
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel", _style(Color(1, 1, 1, 0.9), Color(0.5, 0.7, 0.85, 0.3), 6))
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		card.add_child(row)
		var info := Label.new()
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info.text = "%s\n%s · HP %s%%" % [s["name"], s.get("role", "Idle"), int(s.get("health", 100))]
		info.add_theme_color_override("font_color", Color("#153247"))
		info.add_theme_font_size_override("font_size", 12)
		row.add_child(info)
		var sid := int(s["id"])
		var idle_b := _action_btn("Idle", ICON_MINUS, game.assign_survivor.bind(sid, ""), Color("#5a6a73"))
		idle_b.custom_minimum_size = Vector2(70, 36)
		idle_b.disabled = str(s.get("building_id", "")) == ""
		row.add_child(idle_b)
		var asg := _action_btn("Job", ICON_PLUS, game.assign_survivor.bind(sid, selected_building), Color("#1f7fab"))
		asg.custom_minimum_size = Vector2(70, 36)
		asg.disabled = not game.is_building_operational(selected_building)
		row.add_child(asg)
		survivor_list.add_child(card)

func _queue_ability_rebuild() -> void:
	if ability_rebuild_queued:
		return
	ability_rebuild_queued = true
	call_deferred("_rebuild_abilities")

func _rebuild_abilities() -> void:
	ability_rebuild_queued = false
	if ability_list == null:
		return
	for c in ability_list.get_children():
		c.queue_free()
	if not game.is_building_operational(selected_building):
		var b := _action_btn(game.building_status_text(selected_building), ICON_WARNING, func() -> void: pass, Color("#425f75"))
		b.disabled = true
		b.custom_minimum_size = Vector2(160, 40)
		ability_list.add_child(b)
		return
	for action in game.building_actions(selected_building):
		var aid: String = action["id"]
		var btn := _action_btn("%s · %s" % [action["name"], action["cost"]], ICON_TARGET, _do_action.bind(aid), Color("#1f6f94"))
		btn.custom_minimum_size = Vector2(132, 40)
		btn.add_theme_font_size_override("font_size", 11)
		btn.disabled = game.game_over or not game.can_perform_building_action(selected_building, aid)
		btn.tooltip_text = "%s\nCost: %s\n%s" % [action["name"], action["cost"], action["effect"]]
		ability_list.add_child(btn)

# =============================================================================
# ACTIONS
# =============================================================================

func _select_building(building_id: String) -> void:
	_play_sfx(SFX_TAP)
	# Tap building with bubble collects first if significant
	if game.bubble_total(building_id) >= 1.0 and selected_building == building_id:
		_on_collect_building(building_id)
		return
	selected_building = building_id
	_close_all_panels()
	sheet_panel.visible = true
	_refresh()

func _on_collect_building(building_id: String) -> void:
	_play_sfx(SFX_TAP_B)
	var gained := game.collect_from_building(building_id)
	if gained.is_empty():
		return
	_spawn_collect_fx(building_id, gained)

func _on_collect_selected() -> void:
	_on_collect_building(selected_building)

func _on_collect_all() -> void:
	_play_sfx(SFX_TAP_B)
	var gained := game.collect_all()
	if gained.is_empty():
		_show_toast("No bubbles to collect")
		return
	var parts: Array[String] = []
	for k in gained.keys():
		parts.append("+%s %s" % [int(gained[k]), k])
	_show_toast("Collected " + ", ".join(parts))
	if building_buttons.has("cabin"):
		var btn: Control = building_buttons["cabin"]
		FloatingTextScript.spawn(self, btn.get_global_position() + btn.size * 0.5, "COLLECT ALL", Color("#9ff0c8"))

func _on_resources_collected(building_id: String, amounts: Dictionary) -> void:
	_spawn_collect_fx(building_id, amounts)

func _spawn_collect_fx(building_id: String, amounts: Dictionary) -> void:
	if not building_buttons.has(building_id):
		return
	var btn: Control = building_buttons[building_id]
	var pos := btn.get_global_position() + btn.size * 0.5
	var y_off := 0.0
	for k in amounts.keys():
		var col: Color = RESOURCE_COLORS.get(str(k), Color.WHITE)
		FloatingTextScript.spawn(self, pos + Vector2(0, y_off), "+%s %s" % [int(amounts[k]), k], col)
		y_off -= 16.0

func _do_action(action_id: String) -> void:
	_play_sfx(SFX_CLICK)
	game.perform_building_action(selected_building, action_id)

func _toggle_build() -> void:
	_play_sfx(SFX_SWITCH)
	_toggle_tab("build", build_panel)

func _toggle_survivors() -> void:
	_play_sfx(SFX_SWITCH)
	_toggle_tab("survivors", survivors_panel)
	if survivors_panel.visible:
		_rebuild_survivor_list()

func _toggle_missions() -> void:
	_play_sfx(SFX_SWITCH)
	_toggle_tab("missions", missions_panel)

func _toggle_more() -> void:
	_play_sfx(SFX_SWITCH)
	_toggle_tab("more", more_panel)

func _toggle_tab(name: String, panel: Control) -> void:
	var open := not panel.visible
	_close_all_panels()
	if open:
		panel.visible = true
		sheet_panel.visible = false
		active_tab = name
		_layout_hud_stack()
	else:
		active_tab = ""
		sheet_panel.visible = true
		_apply_responsive_layout()

func _close_all_panels() -> void:
	build_panel.visible = false
	survivors_panel.visible = false
	missions_panel.visible = false
	more_panel.visible = false
	active_tab = ""
	if placing_building_id != "":
		_cancel_build_placement()
	if move_mode:
		_cancel_move_mode()
	if sheet_panel:
		sheet_panel.visible = true
	_apply_responsive_layout()

func _on_pause() -> void:
	_play_sfx(SFX_SWITCH)
	game.toggle_pause()

func _on_speed() -> void:
	_play_sfx(SFX_SWITCH)
	game.cycle_time_scale()
	_show_toast("Speed %sx" % game.time_scale)

func _on_save() -> void:
	_play_sfx(SFX_CLICK)
	_store_layout()
	if game.save_game():
		_show_toast("City saved")
	else:
		_show_toast("Save failed")

func _on_load() -> void:
	_play_sfx(SFX_CLICK)
	if not game.has_save():
		_show_toast("No save found")
		return
	if game.load_game():
		placing_building_id = ""
		move_mode = false
		_set_map_tiles_enabled(false)
		_close_all_panels()
		_hide_modals_except_end(false)
		_restore_layout()
		_center_map_on_cabin()
		_show_toast("Loaded day %s" % game.day)
		_refresh()

func _on_new_game() -> void:
	_play_sfx(SFX_CLICK)
	_hide_modals_except_end(false)
	if end_panel:
		end_panel.visible = false
	placing_building_id = ""
	move_mode = false
	building_positions = {"cabin": Vector2i(16, 12)}
	game.start_new_game()
	_queue_world_rebuild()
	_center_map_on_cabin()
	_refresh()

func _toggle_move_mode() -> void:
	_play_sfx(SFX_SWITCH)
	placing_building_id = ""
	move_mode = not move_mode
	_set_map_tiles_enabled(move_mode)
	_show_toast("Move mode ON — tap empty plot" if move_mode else "Move mode OFF")

func _cancel_move_mode() -> void:
	move_mode = false
	_set_map_tiles_enabled(false)

func _begin_build_placement(building_id: String) -> void:
	if game.has_building(building_id):
		selected_building = building_id
		_refresh()
		return
	if not game.can_build(building_id):
		game.add_log("Cannot place %s now." % game.building_name(building_id))
		return
	move_mode = false
	placing_building_id = building_id
	placement_cell = _initial_placement_cell()
	build_panel.visible = false
	survivors_panel.visible = false
	missions_panel.visible = false
	more_panel.visible = false
	active_tab = ""
	sheet_panel.visible = true
	_set_map_tiles_enabled(true)
	_apply_responsive_layout()
	_update_placement_preview_for_cell(placement_cell)
	_show_toast("Place %s — green tiles OK · Enter confirm · Esc cancel" % game.building_name(building_id))

func _place_pending_building(cell: Vector2i) -> void:
	if _is_occupied(cell):
		_show_toast("Tile occupied — pick empty snow")
		return
	if _too_close_to_any(cell):
		_show_toast("Too close to another building")
		return
	var building_id := placing_building_id
	if game.build(building_id):
		building_positions[building_id] = cell
		selected_building = building_id
		_queue_world_rebuild()
		_show_toast("%s construction started" % game.building_name(building_id))
	placing_building_id = ""
	_set_map_tiles_enabled(false)

func _cancel_build_placement() -> void:
	placing_building_id = ""
	_set_map_tiles_enabled(false)
	_show_toast("Placement canceled")

func _handle_map_cell_pressed(cell: Vector2i) -> void:
	if placing_building_id != "":
		_place_pending_building(cell)
		return
	if not move_mode:
		return
	if _is_occupied(cell) and building_positions.get(selected_building, Vector2i(-99, -99)) != cell:
		_show_toast("Occupied")
		return
	# Temporarily ignore self when checking gap
	var saved: Vector2i = building_positions.get(selected_building, cell)
	building_positions.erase(selected_building)
	var blocked := _too_close_to_any(cell) or _is_occupied(cell)
	if blocked:
		building_positions[selected_building] = saved
		_show_toast("Need more space between buildings")
		return
	building_positions[selected_building] = cell
	move_mode = false
	_set_map_tiles_enabled(false)
	_queue_world_rebuild()
	_show_toast("Relocated %s" % game.building_name(selected_building))

func _handle_map_detail_pressed(detail: Dictionary) -> void:
	if move_mode or placing_building_id != "":
		return
	_play_sfx(SFX_CLICK)
	game.scout_site(detail["id"], detail["reward"], detail["message"])

func _placement_active() -> bool:
	return move_mode or placing_building_id != ""

func _set_map_tiles_enabled(enabled: bool) -> void:
	for tile in map_tiles:
		if is_instance_valid(tile):
			tile.disabled = not enabled
			var base: Color = tile.get_meta("base_modulate")
			if enabled:
				var cell: Vector2i = tile.get_meta("cell")
				var bad := _is_occupied(cell) or _too_close_to_any(cell)
				tile.modulate = Color(1.0, 0.55, 0.5, 0.85) if bad else Color(0.72, 1.0, 0.95, 1.0)
			else:
				tile.modulate = base
	for db in map_detail_buttons:
		if is_instance_valid(db):
			db.mouse_filter = Control.MOUSE_FILTER_IGNORE if enabled else Control.MOUSE_FILTER_STOP
	if placement_layer:
		placement_layer.visible = enabled
		placement_layer.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE
	if placement_preview:
		placement_preview.visible = enabled and placing_building_id != ""
		if placing_building_id != "":
			_update_placement_preview_for_cell(placement_cell)

func _handle_placement_layer_input(event: InputEvent) -> void:
	if not _placement_active():
		return
	if event is InputEventMouseMotion:
		_update_placement_preview((event as InputEventMouseMotion).position)
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_handle_map_cell_pressed(_cell_from_pos(mb.position))
			placement_layer.accept_event()
	elif event is InputEventScreenDrag:
		_update_placement_preview((event as InputEventScreenDrag).position)
	elif event is InputEventScreenTouch:
		var st := event as InputEventScreenTouch
		if st.pressed:
			_handle_map_cell_pressed(_cell_from_pos(st.position))
			placement_layer.accept_event()

func _update_placement_preview(local_pos: Vector2) -> void:
	placement_cell = _cell_from_pos(local_pos)
	_update_placement_preview_for_cell(placement_cell)

func _update_placement_preview_for_cell(cell: Vector2i) -> void:
	if placement_preview == null or placing_building_id == "":
		return
	var tex := _blueprint_texture(placing_building_id)
	var sz := _capped_tex_size(tex, BUILDING_TEXTURE_SCALE, BUILDING_MAX_PX)
	var center := Vector2(cell.x * TILE_PIXEL + TILE_PIXEL * 0.5, cell.y * TILE_PIXEL + TILE_PIXEL * 0.5)
	placement_preview.texture = tex
	placement_preview.custom_minimum_size = sz
	placement_preview.size = sz
	placement_preview.position = center - sz * 0.5
	var bad := _is_occupied(cell) or _too_close_to_any(cell)
	placement_preview.modulate = Color(1.0, 0.45, 0.4, 0.72) if bad else Color(0.65, 1.0, 1.0, 0.78)
	placement_preview.visible = true

func _initial_placement_cell() -> Vector2i:
	return _find_open_near_cabin()

func _cell_from_pos(local_pos: Vector2) -> Vector2i:
	return Vector2i(
		clampi(int(floor(local_pos.x / TILE_PIXEL)), 0, WORLD_COLUMNS - 1),
		clampi(int(floor(local_pos.y / TILE_PIXEL)), 0, WORLD_ROWS - 1)
	)

func _is_occupied(cell: Vector2i) -> bool:
	for p in building_positions.values():
		if p == cell:
			return true
	# Block landmark cells so buildings don't cover POIs
	for detail in MAP_DETAILS:
		if detail["cell"] == cell:
			return true
	return false

func _sync_building_positions() -> void:
	var missing := false
	for building_id in game.buildings.keys():
		if not building_positions.has(building_id):
			building_positions[building_id] = _find_open_near_cabin()
			missing = true
	var stale: Array[String] = []
	for building_id in building_positions.keys():
		if not game.has_building(building_id):
			stale.append(building_id)
	for building_id in stale:
		building_positions.erase(building_id)
		missing = true
	# Ensure map has sprites for all buildings
	for building_id in game.buildings.keys():
		if not building_buttons.has(building_id):
			missing = true
	if missing:
		_queue_world_rebuild()

func _find_open_near_cabin() -> Vector2i:
	var origin: Vector2i = building_positions.get("cabin", Vector2i(16, 12))
	for r in range(MIN_BUILDING_GAP, 14):
		for dy in range(-r, r + 1):
			for dx in range(-r, r + 1):
				var c := Vector2i(origin.x + dx, origin.y + dy)
				if c.x > 2 and c.y > 2 and c.x < WORLD_COLUMNS - 3 and c.y < WORLD_ROWS - 3:
					if not _is_occupied(c) and not _too_close_to_any(c):
						return c
	return Vector2i(clampi(origin.x + MIN_BUILDING_GAP, 2, WORLD_COLUMNS - 3), clampi(origin.y + MIN_BUILDING_GAP, 2, WORLD_ROWS - 3))

func _too_close_to_any(cell: Vector2i) -> bool:
	for p in building_positions.values():
		var other: Vector2i = p
		if absi(other.x - cell.x) < MIN_BUILDING_GAP and absi(other.y - cell.y) < MIN_BUILDING_GAP:
			return true
	return false

func _store_layout() -> void:
	var layout := {}
	for building_id in building_positions.keys():
		var cell: Vector2i = building_positions[building_id]
		layout[building_id] = {"x": cell.x, "y": cell.y}
	game.layout_data = {"buildings": layout}

func _restore_layout() -> void:
	building_positions = {"cabin": Vector2i(16, 12)}
	var layout: Dictionary = game.layout_data.get("buildings", {})
	for building_id in layout.keys():
		if not game.has_building(building_id):
			continue
		var e: Dictionary = layout[building_id]
		building_positions[building_id] = Vector2i(int(e.get("x", 16)), int(e.get("y", 12)))
	for building_id in game.buildings.keys():
		if not building_positions.has(building_id):
			building_positions[building_id] = _find_open_near_cabin()
	_queue_world_rebuild()

func _queue_world_rebuild() -> void:
	if world_rebuild_queued:
		return
	world_rebuild_queued = true
	call_deferred("_rebuild_world")

func _rebuild_world() -> void:
	world_rebuild_queued = false
	for child in world_grid.get_children():
		child.queue_free()
	call_deferred("_build_world_grid", world_grid)
	call_deferred("_refresh")

func _center_map_on_cabin() -> void:
	await get_tree().process_frame
	if map_scroll == null:
		return
	var cell: Vector2i = building_positions.get("cabin", Vector2i(16, 12))
	var target := Vector2(cell.x * TILE_PIXEL - map_scroll.size.x * 0.5, cell.y * TILE_PIXEL - map_scroll.size.y * 0.4)
	map_scroll.scroll_horizontal = int(maxi(0, int(target.x)))
	map_scroll.scroll_vertical = int(maxi(0, int(target.y)))

func _ensure_selected_building() -> void:
	if game.has_building(selected_building):
		return
	for building_id in game.building_ids():
		if game.has_building(building_id):
			selected_building = building_id
			return

func _update_bubble_pulse() -> void:
	var s := 1.0 + sin(_bubble_pulse * 4.0) * 0.06
	for building_id in bubble_buttons.keys():
		var bub: Button = bubble_buttons[building_id]
		if is_instance_valid(bub) and bub.visible:
			bub.scale = Vector2(s, s)

func _update_storm_visuals() -> void:
	if snow_overlay and snow_overlay.has_method("set_storm_intensity"):
		var f := 0.0
		if game.storm_active_days > 0:
			f = 1.0
		elif game.days_until_storm() <= 2:
			f = 0.45
		elif game.days_until_storm() <= 4:
			f = 0.2
		snow_overlay.set_storm_intensity(f)

# =============================================================================
# MODALS
# =============================================================================

func _build_modals() -> void:
	modal_layer = CanvasLayer.new()
	modal_layer.layer = 50
	add_child(modal_layer)

	tutorial_panel = _modal_shell()
	var tb: VBoxContainer = tutorial_panel.get_meta("content")
	tutorial_title = Label.new()
	tutorial_title.add_theme_color_override("font_color", Color("#153247"))
	tutorial_title.add_theme_font_size_override("font_size", 22)
	tb.add_child(tutorial_title)
	tutorial_body = Label.new()
	tutorial_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tutorial_body.add_theme_color_override("font_color", Color("#2a4a5c"))
	tutorial_body.add_theme_font_size_override("font_size", 15)
	tb.add_child(tutorial_body)
	var tr := HBoxContainer.new()
	tr.add_theme_constant_override("separation", 10)
	tb.add_child(tr)
	tr.add_child(_action_btn("Skip", ICON_MINUS, _on_tutorial_skip, Color("#65757c")))
	tr.add_child(_action_btn("Next", ICON_PLUS, _on_tutorial_next, Color("#1f7fab")))
	modal_layer.add_child(tutorial_panel)

	choice_panel = _modal_shell()
	var cb: VBoxContainer = choice_panel.get_meta("content")
	choice_title = Label.new()
	choice_title.add_theme_color_override("font_color", Color("#153247"))
	choice_title.add_theme_font_size_override("font_size", 22)
	cb.add_child(choice_title)
	choice_body = Label.new()
	choice_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	choice_body.add_theme_color_override("font_color", Color("#2a4a5c"))
	choice_body.add_theme_font_size_override("font_size", 15)
	cb.add_child(choice_body)
	choice_buttons = VBoxContainer.new()
	choice_buttons.add_theme_constant_override("separation", 8)
	cb.add_child(choice_buttons)
	modal_layer.add_child(choice_panel)

	end_panel = _modal_shell()
	var eb: VBoxContainer = end_panel.get_meta("content")
	end_title = Label.new()
	end_title.add_theme_color_override("font_color", Color("#153247"))
	end_title.add_theme_font_size_override("font_size", 24)
	eb.add_child(end_title)
	end_body = Label.new()
	end_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	end_body.add_theme_color_override("font_color", Color("#2a4a5c"))
	end_body.add_theme_font_size_override("font_size", 15)
	eb.add_child(end_body)
	eb.add_child(_action_btn("New Settlement", ICON_PLUS, _on_new_game, Color("#1f7fab")))
	modal_layer.add_child(end_panel)

func _modal_shell() -> PanelContainer:
	var dim := PanelContainer.new()
	dim.visible = false
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.add_theme_stylebox_override("panel", _style(Color(0.01, 0.04, 0.08, 0.7), Color(0, 0, 0, 0), 0))
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(400, 0)
	card.add_theme_stylebox_override("panel", _style(Color(0.96, 0.99, 1.0, 0.99), Color(1, 1, 1, 0.75), 14))
	center.add_child(card)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	card.add_child(box)
	dim.set_meta("content", box)
	return dim

func _on_tutorial_step(_s: int, title: String, body: String) -> void:
	tutorial_title.text = title
	tutorial_body.text = body
	tutorial_panel.visible = true

func _on_tutorial_next() -> void:
	_play_sfx(SFX_CLICK)
	tutorial_panel.visible = false
	game.advance_tutorial()

func _on_tutorial_skip() -> void:
	_play_sfx(SFX_SWITCH)
	tutorial_panel.visible = false
	game.skip_tutorial()

func _on_choice_requested(_id: String, title: String, body: String, options: Array) -> void:
	choice_title.text = title
	choice_body.text = body
	for c in choice_buttons.get_children():
		c.queue_free()
	for option in options:
		var oid := str(option.get("id", ""))
		var btn := _action_btn(str(option.get("label", "Choose")), ICON_TARGET, _resolve_choice.bind(oid), Color("#1f6f94"))
		btn.custom_minimum_size = Vector2(280, 48)
		choice_buttons.add_child(btn)
	choice_panel.visible = true

func _resolve_choice(oid: String) -> void:
	_play_sfx(SFX_CLICK)
	choice_panel.visible = false
	game.resolve_choice(oid)
	if not game.game_over:
		game.set_paused(false)

func _on_game_ended(won: bool, summary: String) -> void:
	end_title.text = "CITY SECURED" if won else "CITY FALLEN"
	end_body.text = (
		"Frostfall outlasted the whiteout. Your settlement is a true winter fortress.\n\n%s" if won
		else "The storm and shortages broke Frostfall. Rebuild smarter.\n\n%s"
	) % summary
	end_panel.visible = true
	_play_sfx(SFX_SWITCH)

func _on_storm_warning(days_until: int, intensity: String) -> void:
	_show_toast("Storm: %s in %s day(s)" % [intensity, days_until])

func _hide_modals_except_end(hide_end: bool) -> void:
	if tutorial_panel:
		tutorial_panel.visible = false
	if choice_panel:
		choice_panel.visible = false
	if hide_end and end_panel:
		end_panel.visible = false

func _show_toast(msg: String) -> void:
	if toast_label == null:
		return
	toast_label.text = "  %s  " % msg
	toast_label.visible = true
	_toast_timer = 2.4

# =============================================================================
# WIDGETS
# =============================================================================

func _make_building_row(building_id: String) -> Dictionary:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(Color(1, 1, 1, 0.92), Color(0.55, 0.73, 0.84, 0.3), 8))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	panel.add_child(row)
	var icon := TextureRect.new()
	icon.texture = _blueprint_texture(building_id)
	icon.custom_minimum_size = Vector2(56, 48)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)
	var info := Label.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_theme_color_override("font_color", Color("#153247"))
	info.add_theme_font_size_override("font_size", 12)
	row.add_child(info)
	var minus := _icon_btn(ICON_MINUS, func() -> void: game.assign_worker(building_id, -1))
	row.add_child(minus)
	var plus := _icon_btn(ICON_PLUS, func() -> void: game.assign_worker(building_id, 1))
	row.add_child(plus)
	var upgrade := _icon_btn(ICON_WRENCH, func() -> void: game.upgrade(building_id))
	row.add_child(upgrade)
	var build := _action_btn("Place", ICON_PLUS, _begin_build_placement.bind(building_id), Color("#1f7fab"))
	build.custom_minimum_size = Vector2(84, 40)
	row.add_child(build)
	return {"container": panel, "icon": icon, "info": info, "minus": minus, "plus": plus, "upgrade": upgrade, "build": build}

func _goal_card(goal: Dictionary) -> Control:
	var complete := bool(goal["complete"])
	var active := bool(goal.get("active", false))
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(
		Color(0.78, 1.0, 0.88, 0.8) if complete else Color(1, 1, 1, 0.85),
		Color("#7be7aa") if complete else Color(0.6, 0.78, 0.88, 0.3), 7
	))
	var box := VBoxContainer.new()
	panel.add_child(box)
	var t := Label.new()
	t.text = "%s %s" % ["✓" if complete else ("▶" if active else "·"), goal["title"]]
	t.add_theme_color_override("font_color", Color("#0d4b35") if complete else Color("#123247"))
	t.add_theme_font_size_override("font_size", 13)
	box.add_child(t)
	var d := Label.new()
	d.text = "%s\n%s\n%s" % [goal.get("chapter_title", ""), goal["detail"], goal["progress"]]
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	d.add_theme_color_override("font_color", Color("#3c6b58") if complete else Color("#315265"))
	d.add_theme_font_size_override("font_size", 11)
	box.add_child(d)
	return panel

func _event_card(msg: String, index: int) -> Control:
	var panel := PanelContainer.new()
	var a := 0.85 - minf(float(index) * 0.07, 0.35)
	panel.add_theme_stylebox_override("panel", _style(Color(0.05, 0.16, 0.24, a), Color(0.5, 0.8, 1.0, 0.2), 6))
	var l := Label.new()
	l.text = msg
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_color_override("font_color", Color("#d8edf7"))
	l.add_theme_font_size_override("font_size", 12)
	panel.add_child(l)
	return panel

func _chip(text: String) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.custom_minimum_size = Vector2(52, 26)
	l.add_theme_color_override("font_color", Color("#eef8ff"))
	l.add_theme_font_size_override("font_size", 11)
	l.add_theme_stylebox_override("normal", _style(Color(0.08, 0.22, 0.32, 0.95), Color(0.6, 0.9, 1.0, 0.3), 6))
	return l

func _named_bar(tip: String, fill: Color) -> ProgressBar:
	var p := ProgressBar.new()
	p.min_value = 0
	p.max_value = 100
	p.show_percentage = true
	p.tooltip_text = tip
	p.custom_minimum_size = Vector2(100, 28)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("background", _meter_bg())
	p.add_theme_stylebox_override("fill", _meter_fill(fill))
	p.add_theme_color_override("font_color", Color("#f7fbff"))
	p.add_theme_font_size_override("font_size", 10)
	return p

func _nav_btn(text: String, icon: Texture2D, color: Color, cb: Callable) -> Button:
	var b := _action_btn(text, icon, cb, color)
	b.custom_minimum_size = Vector2(0, 52)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_font_size_override("font_size", 12)
	return b

func _action_btn(text: String, icon: Texture2D, cb: Callable, color: Color) -> Button:
	var b := Button.new()
	b.text = text
	b.icon = icon
	b.expand_icon = true
	b.custom_minimum_size = Vector2(120, 44)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_stylebox_override("normal", _btn_style(color))
	b.add_theme_stylebox_override("hover", _btn_style(color.lightened(0.12)))
	b.add_theme_stylebox_override("pressed", _btn_style(color.darkened(0.12)))
	b.add_theme_stylebox_override("disabled", _btn_style(Color("#5a6a73")))
	b.add_theme_color_override("font_color", Color.WHITE)
	b.add_theme_font_size_override("font_size", 13)
	b.pressed.connect(cb)
	return b

func _icon_btn(icon: Texture2D, cb: Callable) -> Button:
	var b := Button.new()
	b.icon = icon
	b.expand_icon = true
	b.custom_minimum_size = Vector2(40, 36)
	b.add_theme_stylebox_override("normal", _btn_style(Color("#1d6d93")))
	b.add_theme_stylebox_override("hover", _btn_style(Color("#2588b4")))
	b.add_theme_stylebox_override("pressed", _btn_style(Color("#165675")))
	b.add_theme_stylebox_override("disabled", _btn_style(Color("#65757c")))
	b.pressed.connect(cb)
	return b

func _style(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(1)
	s.set_corner_radius_all(radius)
	s.content_margin_left = 10
	s.content_margin_top = 8
	s.content_margin_right = 10
	s.content_margin_bottom = 8
	s.shadow_color = Color(0, 0.04, 0.08, 0.25)
	s.shadow_size = 6
	s.shadow_offset = Vector2(0, 3)
	return s

func _btn_style(bg: Color) -> StyleBoxFlat:
	var s := _style(bg, Color(1, 1, 1, 0.28), 8)
	s.content_margin_left = 8
	s.content_margin_top = 6
	s.content_margin_right = 8
	s.content_margin_bottom = 6
	return s

func _meter_bg() -> StyleBoxFlat:
	return _style(Color(0.04, 0.11, 0.17, 0.75), Color(0.5, 0.8, 1.0, 0.15), 6)

func _meter_fill(c: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = c
	s.set_corner_radius_all(6)
	return s

func _badge(bg: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = Color(1, 1, 1, 0.5)
	s.set_border_width_all(1)
	s.set_corner_radius_all(5)
	s.content_margin_left = 4
	s.content_margin_right = 4
	s.content_margin_top = 1
	s.content_margin_bottom = 1
	return s

func _building_texture(building_id: String) -> Texture2D:
	var opts: Array = BUILDING_SPRITES[building_id]
	var level := int(game.buildings[building_id]["level"]) if game.has_building(building_id) else 1
	return opts[clampi(level - 1, 0, opts.size() - 1)]

func _blueprint_texture(building_id: String) -> Texture2D:
	return BUILDING_SPRITES[building_id][0]

func _tex_size(tex: Texture2D, scale: float) -> Vector2:
	return Vector2(tex.get_width(), tex.get_height()) * scale

func _capped_tex_size(tex: Texture2D, scale: float, max_px: float) -> Vector2:
	var size := _tex_size(tex, scale)
	var longest := maxf(size.x, size.y)
	if longest > max_px and longest > 0.0:
		size *= max_px / longest
	return size

func _on_map_gui_input(event: InputEvent) -> void:
	if placing_building_id != "" or move_mode:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_map_dragging = true
				_map_drag_last = mb.position
			else:
				_map_dragging = false
		elif mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			map_scroll.scroll_vertical -= 48
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			map_scroll.scroll_vertical += 48
	elif event is InputEventMouseMotion and _map_dragging:
		var mm := event as InputEventMouseMotion
		var delta: Vector2 = _map_drag_last - mm.position
		map_scroll.scroll_horizontal += int(delta.x)
		map_scroll.scroll_vertical += int(delta.y)
		_map_drag_last = mm.position
	elif event is InputEventScreenDrag:
		var sd := event as InputEventScreenDrag
		map_scroll.scroll_horizontal -= int(sd.relative.x)
		map_scroll.scroll_vertical -= int(sd.relative.y)

func _layout_hud_stack() -> void:
	if not ui_ready or top_bar == null:
		return
	# Force top bar to size to content
	top_bar.reset_size()
	var top_h := maxf(top_bar.get_combined_minimum_size().y, top_bar.size.y)
	if top_h < 90.0:
		top_h = 96.0
	top_bar.offset_bottom = HUD_MARGIN + top_h
	_hud_bottom = HUD_MARGIN + top_h + 4.0

	var y := _hud_bottom
	if storm_banner and storm_banner.visible:
		storm_banner.offset_top = y
		storm_banner.offset_bottom = y + 30.0
		y += 34.0
	if mission_strip:
		mission_strip.offset_top = y
		mission_strip.offset_bottom = y + 36.0
		y += 40.0

	# Side panels sit under HUD stack, above nav
	for panel in [build_panel, survivors_panel, missions_panel, more_panel]:
		if panel == null:
			continue
		panel.offset_top = y + 4.0
		panel.offset_bottom = -(NAV_HEIGHT + HUD_MARGIN)

	# Toast just under mission strip
	if toast_label:
		toast_label.offset_top = y + 6.0
		toast_label.offset_bottom = y + 34.0

func _fmt_prod(prod: Dictionary) -> String:
	var parts: Array[String] = []
	for k in prod.keys():
		if str(k) == "heat_gen":
			continue
		parts.append("+%.1f %s/day" % [float(prod[k]), k])
	return ", ".join(parts) if not parts.is_empty() else "support"

func _fmt_cost(cost: Dictionary) -> String:
	var parts: Array[String] = []
	for k in ["wood", "tools", "coal", "iron", "seed", "food"]:
		if cost.has(k) and int(cost[k]) > 0:
			parts.append("%s %s" % [int(cost[k]), k])
	return ", ".join(parts) if not parts.is_empty() else "free"

func _play_sfx(stream: AudioStream) -> void:
	if sfx_player == null or game == null or not game.sfx_enabled:
		return
	sfx_player.stream = stream
	sfx_player.play()

func _style_tight(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var s := _style(bg, border, radius)
	s.content_margin_left = 6
	s.content_margin_top = 4
	s.content_margin_right = 6
	s.content_margin_bottom = 4
	s.shadow_size = 2
	s.shadow_offset = Vector2(0, 1)
	return s

func _apply_responsive_layout() -> void:
	if not ui_ready:
		return
	var sz := get_viewport_rect().size
	compact_layout = sz.x < 900.0 or sz.y > sz.x

	bottom_nav.offset_top = -NAV_HEIGHT
	bottom_nav.offset_bottom = -HUD_MARGIN
	bottom_nav.offset_left = HUD_MARGIN
	bottom_nav.offset_right = -HUD_MARGIN

	var sheet_h := SHEET_HEIGHT_COMPACT if compact_layout else SHEET_HEIGHT_DESKTOP
	# Sheet sits above nav with a small gap
	var sheet_bottom := NAV_HEIGHT + 4.0
	sheet_panel.offset_left = HUD_MARGIN
	sheet_panel.offset_right = -HUD_MARGIN
	if _sheet_open and active_tab == "":
		sheet_panel.visible = true
		sheet_panel.offset_top = -(sheet_h + sheet_bottom)
		sheet_panel.offset_bottom = -sheet_bottom
	elif active_tab != "":
		sheet_panel.visible = false
	else:
		sheet_panel.visible = true
		sheet_panel.offset_top = -(sheet_h + sheet_bottom)
		sheet_panel.offset_bottom = -sheet_bottom

	if ability_scroll:
		ability_scroll.custom_minimum_size = Vector2(0, 64 if compact_layout else 78)

	_layout_hud_stack()
