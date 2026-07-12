extends Control

## Frostfall Homestead — Whiteout Survival-style mobile city client.
## Map-first chrome: slim top bar, big bottom dock, tap-to-inspect sheets.

const GameStateScript := preload("res://scripts/GameState.gd")
const BackgroundScript := preload("res://scripts/PolishedBackground.gd")
const SnowOverlayScript := preload("res://scripts/SnowOverlay.gd")
const FloatingTextScript := preload("res://scripts/FloatingText.gd")
const FONT := preload("res://assets/kenney_ui_pack/Font/Kenney Future.ttf")

const TERRAIN_SNOW := preload("res://assets/map_details/tile_snow.png")
const TERRAIN_SNOW_ROUGH := preload("res://assets/map_details/tile_snow_rough.png")
const TERRAIN_ROAD_H := preload("res://assets/map_details/tile_road_horizontal.png")
const TERRAIN_ROAD_V := preload("res://assets/map_details/tile_road_vertical.png")
const TERRAIN_CLEARING := preload("res://assets/map_details/tile_clearing.png")
const TERRAIN_PINE := preload("res://assets/map_details/tile_pine.png")
const TERRAIN_LOGS := preload("res://assets/map_details/tile_logs.png")

const SPR_HOME_L1 := preload("res://assets/building_upgrades/homestead_l1.png")
const SPR_HALL_L1 := preload("res://assets/building_upgrades/city_hall_l1.png")
const SPR_HALL_L2 := preload("res://assets/building_upgrades/city_hall_l2.png")
const SPR_HALL_L3 := preload("res://assets/building_upgrades/city_hall_l3.png")
const SPR_LODGE_L1 := preload("res://assets/building_upgrades/hunters_lodge_l1.png")
const SPR_LODGE_L2 := preload("res://assets/building_upgrades/hunters_lodge_l2.png")
const SPR_LODGE_L3 := preload("res://assets/building_upgrades/hunters_lodge_l3.png")
const SPR_SAW_L1 := preload("res://assets/building_upgrades/sawmill_l1.png")
const SPR_SAW_L2 := preload("res://assets/building_upgrades/sawmill_l2.png")
const SPR_SAW_L3 := preload("res://assets/building_upgrades/sawmill_l3.png")
const SPR_MINE_L1 := preload("res://assets/building_upgrades/coal_mine_l1.png")
const SPR_MINE_L2 := preload("res://assets/building_upgrades/coal_mine_l2.png")
const SPR_MINE_L3 := preload("res://assets/building_upgrades/coal_mine_l3.png")
const SPR_SHEL_L1 := preload("res://assets/building_upgrades/shelters_l1.png")
const SPR_SHEL_L2 := preload("res://assets/building_upgrades/shelters_l2.png")
const SPR_SHEL_L3 := preload("res://assets/building_upgrades/shelters_l3.png")

const DET_TIMBER := preload("res://assets/map_details/timber_forest_l1.png")
const DET_STONE := preload("res://assets/map_details/stone_rocks_l1.png")
const DET_HUNT := preload("res://assets/map_details/hunting_tracks_l1.png")
const DET_CAMP := preload("res://assets/map_details/camp_poi.png")
const DET_CAVE := preload("res://assets/map_details/ice_cave.png")
const DET_OUTPOST := preload("res://assets/map_details/outpost.png")
const DET_QUARRY := preload("res://assets/map_details/quarry_l3.png")
const DET_ORE := preload("res://assets/map_details/ore_mine_l2.png")
const DET_ROCKS := preload("res://assets/map_details/stone_rocks_l1.png")
const DET_BLIND := preload("res://assets/map_details/hunting_blind_l3.png")
const DET_CARCASS := preload("res://assets/map_details/hunting_carcass_l2.png")
const DET_CAMP2 := preload("res://assets/map_details/timber_camp_l2.png")
const DET_SAW := preload("res://assets/map_details/timber_sawmill_l3.png")

const ICO_HOME := preload("res://assets/kenney_game_icons/PNG/White/2x/home.png")
const ICO_PLUS := preload("res://assets/kenney_game_icons/PNG/White/2x/plus.png")
const ICO_MINUS := preload("res://assets/kenney_game_icons/PNG/White/2x/minus.png")
const ICO_WRENCH := preload("res://assets/kenney_game_icons/PNG/White/2x/wrench.png")
const ICO_TARGET := preload("res://assets/kenney_game_icons/PNG/White/2x/target.png")
const ICO_STAR := preload("res://assets/kenney_game_icons/PNG/White/2x/star.png")
const ICO_USER := preload("res://assets/kenney_game_icons/PNG/White/2x/singleplayer.png")
const ICO_MENU := preload("res://assets/kenney_game_icons/PNG/White/2x/menuGrid.png")
const ICO_CHECK := preload("res://assets/kenney_game_icons/PNG/White/2x/checkmark.png")
const ICO_PAUSE := preload("res://assets/kenney_game_icons/PNG/White/2x/pause.png")
const ICO_FF := preload("res://assets/kenney_game_icons/PNG/White/2x/fastForward.png")
const ICO_SAVE := preload("res://assets/kenney_game_icons/PNG/White/2x/save.png")
const ICO_LOCK := preload("res://assets/kenney_game_icons/PNG/White/2x/locked.png")
const ICO_WARN := preload("res://assets/kenney_game_icons/PNG/White/2x/warning.png")
const ICO_CROSS := preload("res://assets/kenney_game_icons/PNG/White/2x/cross.png")

const SFX_CLICK := preload("res://assets/kenney_ui_pack/Sounds/click-a.ogg")
const SFX_TAP := preload("res://assets/kenney_ui_pack/Sounds/tap-a.ogg")
const SFX_SWITCH := preload("res://assets/kenney_ui_pack/Sounds/switch-a.ogg")
const SFX_COLLECT := preload("res://assets/kenney_ui_pack/Sounds/tap-b.ogg")

const TILE := 48
const COLS := 28
const ROWS := 36
const BLD_MAX := 88.0
const POI_MAX := 64.0
const GAP := 3
const DOCK_H := 78.0
const MARGIN := 8.0

const SPRITES := {
	"cabin": [SPR_HOME_L1, SPR_HALL_L2, SPR_HALL_L3],
	"woodlot": [SPR_SAW_L1, SPR_SAW_L2, SPR_SAW_L3],
	"garden": [SPR_LODGE_L1, SPR_LODGE_L2, SPR_LODGE_L3],
	"well": [SPR_SHEL_L1, SPR_SHEL_L2, SPR_SHEL_L3],
	"hunter": [DET_HUNT, DET_BLIND, DET_CARCASS],
	"workshop": [SPR_MINE_L1, SPR_MINE_L2, SPR_MINE_L3],
	"kitchen": [DET_CAMP, DET_CAMP2, DET_SAW],
	"warehouse": [DET_ROCKS, DET_ORE, DET_QUARRY],
	"root_cellar": [DET_CAVE, DET_ROCKS, DET_QUARRY],
	"smokehouse": [DET_CAMP2, DET_BLIND, DET_SAW],
	"coop": [DET_CAMP, DET_OUTPOST, DET_CARCASS],
	"infirmary": [SPR_SHEL_L2, SPR_SHEL_L3, SPR_HALL_L1],
	"watchtower": [DET_OUTPOST, DET_BLIND, SPR_HALL_L2],
}

const RES_ORDER := ["food", "wood", "water", "coal", "iron", "tools", "seed"]
const RES_SHORT := {
	"food": "🍖", "wood": "🪵", "water": "💧", "coal": "⬛",
	"iron": "⚙", "tools": "🔧", "seed": "🌱",
}
const RES_COLOR := {
	"food": Color("#f0a85a"), "wood": Color("#b07848"), "water": Color("#4eb8e8"),
	"coal": Color("#7a7a88"), "iron": Color("#b0bcc8"), "tools": Color("#d0d8e0"),
	"seed": Color("#88c868"),
}
const RES_NAME := {
	"food": "Food", "wood": "Wood", "water": "Water", "coal": "Coal",
	"iron": "Iron", "tools": "Tools", "seed": "Seed",
}

const POIS := [
	{"id": "timber", "name": "Timber Stand", "tex": DET_TIMBER, "cell": Vector2i(2, 2), "msg": "Timber marked.", "reward": {"wood": 28}},
	{"id": "stone", "name": "Stone Ridge", "tex": DET_STONE, "cell": Vector2i(25, 2), "msg": "Stone scouted.", "reward": {"iron": 3, "tools": 1}},
	{"id": "hunt", "name": "Hunt Trail", "tex": DET_HUNT, "cell": Vector2i(2, 32), "msg": "Tracks found.", "reward": {"food": 24}},
	{"id": "camp", "name": "Lost Camp", "tex": DET_CAMP, "cell": Vector2i(25, 32), "msg": "Camp logged.", "reward": {"food": 12, "coal": 4}},
	{"id": "cave", "name": "Ice Cave", "tex": DET_CAVE, "cell": Vector2i(25, 17), "msg": "Cave found.", "reward": {"water": 28, "coal": 3}},
	{"id": "ridge", "name": "Ridge Post", "tex": DET_OUTPOST, "cell": Vector2i(2, 17), "msg": "Post marked.", "reward": {"morale": 5, "wood": 14}},
	{"id": "coal", "name": "Coal Seam", "tex": DET_ORE, "cell": Vector2i(14, 33), "msg": "Coal surveyed.", "reward": {"coal": 12}},
]

var game: GameState

# UI roots
var map_scroll: ScrollContainer
var world: Control
var snow: Control
var chrome: Control
var top_panel: PanelContainer
var dock: PanelContainer
var sheet: PanelContainer
var sheet_dim: ColorRect
var menu_dim: ColorRect
var menu_panel: PanelContainer
var menu_title: Label
var menu_body: VBoxContainer
var toast: Label
var mission_pill: PanelContainer
var mission_label: Label
var storm_pill: PanelContainer
var storm_label: Label
var fab_collect: Button
var sfx: AudioStreamPlayer

# Top HUD
var res_labels := {}
var day_lbl: Label
var heat_bar: ProgressBar
var fuel_bar: ProgressBar
var morale_bar: ProgressBar
var pause_btn: Button
var speed_btn: Button

# Sheet
var sheet_title: Label
var sheet_sub: Label
var sheet_preview: TextureRect
var sheet_stats: Label
var sheet_hp: ProgressBar
var sheet_ready: ProgressBar
var sheet_workers: Label
var sheet_actions: HFlowContainer
var btn_minus: Button
var btn_plus: Button
var btn_upgrade: Button
var btn_collect: Button
var btn_move: Button
var btn_close_sheet: Button

# Map
var tiles: Array[TextureButton] = []
var bld_btns := {}
var bld_badges := {}
var bld_bubbles := {}
var poi_btns: Array[TextureButton] = []
var positions := {"cabin": Vector2i(13, 12)}
var place_layer: Control
var place_preview: TextureRect

# State
var selected := "cabin"
var placing := ""
var place_cell := Vector2i.ZERO
var move_mode := false
var menu_mode := "" # build | people | missions | more
var sheet_open := false
var ready_ui := false
var drag := false
var drag_last := Vector2.ZERO
var pulse := 0.0
var toast_t := 0.0
var rebuild_world_q := false
var rebuild_actions_q := false

func _ready() -> void:
	randomize()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game = GameStateScript.new()
	_build_ui()
	resized.connect(_layout)
	game.changed.connect(_refresh)
	game.choice_requested.connect(_on_choice)
	game.game_ended.connect(_on_end)
	game.tutorial_step.connect(_on_tutorial)
	game.resources_collected.connect(_on_collected)
	game.storm_warning.connect(func(d, i): _toast("Storm: %s in %sd" % [i, d]))
	game.toast.connect(_toast)
	if game.has_save():
		game.set_paused(true)
		_toast("Welcome back — More → Load")
	else:
		game.start_new_game()
	call_deferred("_center_city")
	call_deferred("_layout")
	_refresh()

func _process(delta: float) -> void:
	if game == null:
		return
	game.tick(delta)
	pulse += delta
	if toast_t > 0.0:
		toast_t -= delta
		if toast_t <= 0.0:
			toast.visible = false
	_pulse_bubbles()
	if snow and snow.has_method("set_storm_intensity"):
		var f := 0.0
		if game.storm_active_days > 0:
			f = 1.0
		elif game.days_until_storm() <= 2:
			f = 0.5
		elif game.days_until_storm() <= 4:
			f = 0.2
		snow.set_storm_intensity(f)

func _input(e: InputEvent) -> void:
	if not e is InputEventKey:
		return
	var k := e as InputEventKey
	if not k.pressed or k.echo:
		return
	match k.keycode:
		KEY_P:
			if placing == "":
				game.toggle_pause()
				_sfx(SFX_SWITCH)
				get_viewport().set_input_as_handled()
		KEY_1:
			game.set_time_scale(1.0)
			_sfx(SFX_SWITCH)
		KEY_2:
			game.set_time_scale(2.0)
			_sfx(SFX_SWITCH)
		KEY_3:
			game.set_time_scale(3.0)
			_sfx(SFX_SWITCH)
		KEY_C:
			if placing == "":
				_collect_all()
		KEY_ESCAPE:
			if placing != "":
				_cancel_place()
			elif move_mode:
				_cancel_move()
			elif sheet_open:
				_close_sheet()
			elif menu_mode != "":
				_close_menu()
			get_viewport().set_input_as_handled()
		KEY_W, KEY_UP:
			_pan(0, -1, k.shift_pressed)
		KEY_S, KEY_DOWN:
			_pan(0, 1, k.shift_pressed)
		KEY_A, KEY_LEFT:
			_pan(-1, 0, k.shift_pressed)
		KEY_D, KEY_RIGHT:
			_pan(1, 0, k.shift_pressed)
		KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
			if placing != "":
				_commit_cell(place_cell)
				get_viewport().set_input_as_handled()

func _pan(dx: int, dy: int, fast: bool) -> void:
	if map_scroll == null:
		return
	var s := 90 if fast else 48
	map_scroll.scroll_horizontal += dx * s
	map_scroll.scroll_vertical += dy * s
	get_viewport().set_input_as_handled()

# =============================================================================
# BUILD UI
# =============================================================================

func _build_ui() -> void:
	add_theme_font_override("font", FONT)
	sfx = AudioStreamPlayer.new()
	sfx.volume_db = -7.0
	add_child(sfx)

	var bg: Control = BackgroundScript.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# --- MAP ---
	var map_host := Control.new()
	map_host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(map_host)

	map_scroll = ScrollContainer.new()
	map_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	map_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	map_scroll.gui_input.connect(_map_input)
	map_host.add_child(map_scroll)

	world = Control.new()
	world.custom_minimum_size = Vector2(COLS * TILE, ROWS * TILE)
	world.mouse_filter = Control.MOUSE_FILTER_STOP
	map_scroll.add_child(world)
	_rebuild_world()

	snow = SnowOverlayScript.new()
	snow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	snow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_host.add_child(snow)

	# --- CHROME ---
	chrome = Control.new()
	chrome.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	chrome.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chrome.z_index = 20
	add_child(chrome)

	_build_top()
	_build_pills()
	_build_dock()
	_build_fab()
	_build_sheet()
	_build_menu()
	_build_toast()
	_build_modals()

	ready_ui = true
	_layout()

func _build_top() -> void:
	top_panel = PanelContainer.new()
	top_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	top_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_panel.offset_left = MARGIN
	top_panel.offset_top = MARGIN
	top_panel.offset_right = -MARGIN
	top_panel.add_theme_stylebox_override("panel", _glass(Color(0.04, 0.10, 0.16, 0.92), Color(0.55, 0.82, 1.0, 0.35), 14))
	chrome.add_child(top_panel)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 4)
	top_panel.add_child(col)

	# Row: day + meters + controls
	var r1 := HBoxContainer.new()
	r1.add_theme_constant_override("separation", 6)
	col.add_child(r1)

	day_lbl = Label.new()
	day_lbl.add_theme_color_override("font_color", Color("#e8f6ff"))
	day_lbl.add_theme_font_size_override("font_size", 13)
	day_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	day_lbl.custom_minimum_size = Vector2(110, 0)
	r1.add_child(day_lbl)

	heat_bar = _bar(Color("#f0a44a"), "Heat")
	r1.add_child(heat_bar)
	fuel_bar = _bar(Color("#c47a3a"), "Fuel")
	r1.add_child(fuel_bar)
	morale_bar = _bar(Color("#6fd07a"), "Morale")
	r1.add_child(morale_bar)

	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r1.add_child(sp)

	pause_btn = _icon(ICO_PAUSE, func(): game.toggle_pause(); _sfx(SFX_SWITCH))
	pause_btn.tooltip_text = "Pause"
	r1.add_child(pause_btn)
	speed_btn = _icon(ICO_FF, func(): game.cycle_time_scale(); _sfx(SFX_SWITCH); _toast("Speed %sx" % game.time_scale))
	speed_btn.tooltip_text = "Speed"
	r1.add_child(speed_btn)

	# Resource strip
	var r2 := HBoxContainer.new()
	r2.add_theme_constant_override("separation", 3)
	col.add_child(r2)
	for key in RES_ORDER:
		var chip := PanelContainer.new()
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chip.custom_minimum_size = Vector2(0, 28)
		chip.add_theme_stylebox_override("panel", _glass(Color(0.07, 0.14, 0.2, 0.95), RES_COLOR[key], 8))
		r2.add_child(chip)
		var lb := Label.new()
		lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lb.add_theme_color_override("font_color", Color("#f2f8ff"))
		lb.add_theme_font_size_override("font_size", 11)
		lb.text = RES_NAME[key].substr(0, 1) + " 0"
		chip.add_child(lb)
		res_labels[key] = lb

func _build_pills() -> void:
	storm_pill = PanelContainer.new()
	storm_pill.visible = false
	storm_pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	storm_pill.anchor_left = 0.1
	storm_pill.anchor_right = 0.9
	storm_pill.add_theme_stylebox_override("panel", _glass(Color(0.45, 0.12, 0.1, 0.94), Color("#ff8a6a"), 10))
	chrome.add_child(storm_pill)
	storm_label = Label.new()
	storm_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	storm_label.add_theme_color_override("font_color", Color("#ffe8e0"))
	storm_label.add_theme_font_size_override("font_size", 12)
	storm_pill.add_child(storm_label)

	mission_pill = PanelContainer.new()
	mission_pill.mouse_filter = Control.MOUSE_FILTER_STOP
	mission_pill.anchor_left = 0.0
	mission_pill.anchor_right = 0.0
	mission_pill.custom_minimum_size = Vector2(200, 0)
	mission_pill.add_theme_stylebox_override("panel", _glass(Color(0.05, 0.16, 0.22, 0.9), Color("#5ec8f0"), 10))
	mission_pill.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed:
			_open_menu("missions")
	)
	chrome.add_child(mission_pill)
	mission_label = Label.new()
	mission_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mission_label.add_theme_color_override("font_color", Color("#d8f2ff"))
	mission_label.add_theme_font_size_override("font_size", 11)
	mission_pill.add_child(mission_label)

func _build_dock() -> void:
	dock = PanelContainer.new()
	dock.mouse_filter = Control.MOUSE_FILTER_STOP
	dock.anchor_left = 0.0
	dock.anchor_right = 1.0
	dock.anchor_top = 1.0
	dock.anchor_bottom = 1.0
	dock.add_theme_stylebox_override("panel", _glass(Color(0.03, 0.08, 0.13, 0.96), Color(0.4, 0.75, 0.95, 0.4), 18))
	chrome.add_child(dock)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	dock.add_child(row)

	row.add_child(_dock_btn("Build", ICO_PLUS, Color("#1a7aa8"), func(): _open_menu("build")))
	row.add_child(_dock_btn("People", ICO_USER, Color("#2f6d8a"), func(): _open_menu("people")))
	row.add_child(_dock_btn("Missions", ICO_STAR, Color("#2d6b5c"), func(): _open_menu("missions")))
	row.add_child(_dock_btn("Collect", ICO_CHECK, Color("#1f8a58"), _collect_all))
	row.add_child(_dock_btn("More", ICO_MENU, Color("#4a5670"), func(): _open_menu("more")))

func _build_fab() -> void:
	fab_collect = Button.new()
	fab_collect.text = "↓"
	fab_collect.tooltip_text = "Collect all"
	fab_collect.custom_minimum_size = Vector2(54, 54)
	fab_collect.add_theme_font_size_override("font_size", 22)
	fab_collect.add_theme_stylebox_override("normal", _glass(Color(0.12, 0.55, 0.38, 0.95), Color("#9ff0c8"), 27))
	fab_collect.add_theme_stylebox_override("hover", _glass(Color(0.16, 0.65, 0.45, 0.98), Color("#c8ffe0"), 27))
	fab_collect.add_theme_stylebox_override("pressed", _glass(Color(0.1, 0.4, 0.28, 0.98), Color("#7fd8b0"), 27))
	fab_collect.add_theme_color_override("font_color", Color.WHITE)
	fab_collect.pressed.connect(_collect_all)
	fab_collect.anchor_left = 1.0
	fab_collect.anchor_right = 1.0
	fab_collect.anchor_top = 1.0
	fab_collect.anchor_bottom = 1.0
	chrome.add_child(fab_collect)

func _build_sheet() -> void:
	sheet_dim = ColorRect.new()
	sheet_dim.color = Color(0, 0, 0, 0.35)
	sheet_dim.visible = false
	sheet_dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sheet_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	sheet_dim.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed:
			_close_sheet()
	)
	chrome.add_child(sheet_dim)

	sheet = PanelContainer.new()
	sheet.visible = false
	sheet.mouse_filter = Control.MOUSE_FILTER_STOP
	sheet.clip_contents = true
	sheet.anchor_left = 0.0
	sheet.anchor_right = 1.0
	sheet.anchor_top = 1.0
	sheet.anchor_bottom = 1.0
	sheet.add_theme_stylebox_override("panel", _glass(Color(0.05, 0.11, 0.17, 0.98), Color(0.55, 0.88, 1.0, 0.45), 18))
	chrome.add_child(sheet)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	sheet.add_child(box)

	# Handle bar
	var handle := ColorRect.new()
	handle.color = Color(1, 1, 1, 0.25)
	handle.custom_minimum_size = Vector2(48, 4)
	handle.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	box.add_child(handle)

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	box.add_child(head)

	sheet_preview = TextureRect.new()
	sheet_preview.custom_minimum_size = Vector2(64, 56)
	sheet_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sheet_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sheet_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	head.add_child(sheet_preview)

	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(titles)
	sheet_title = Label.new()
	sheet_title.add_theme_color_override("font_color", Color("#f5fbff"))
	sheet_title.add_theme_font_size_override("font_size", 18)
	titles.add_child(sheet_title)
	sheet_sub = Label.new()
	sheet_sub.add_theme_color_override("font_color", Color("#9ecde0"))
	sheet_sub.add_theme_font_size_override("font_size", 12)
	titles.add_child(sheet_sub)

	btn_collect = _btn("Collect", ICO_CHECK, Color("#1f8a58"), _collect_selected)
	btn_collect.custom_minimum_size = Vector2(100, 44)
	head.add_child(btn_collect)
	btn_close_sheet = _icon(ICO_CROSS, _close_sheet)
	head.add_child(btn_close_sheet)

	sheet_stats = Label.new()
	sheet_stats.add_theme_color_override("font_color", Color("#d0e8f4"))
	sheet_stats.add_theme_font_size_override("font_size", 11)
	sheet_stats.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(sheet_stats)

	var meters := HBoxContainer.new()
	meters.add_theme_constant_override("separation", 8)
	box.add_child(meters)
	sheet_hp = _bar(Color("#70d0cc"), "Condition")
	sheet_hp.custom_minimum_size = Vector2(0, 26)
	meters.add_child(sheet_hp)
	sheet_ready = _bar(Color("#78c4ff"), "Ready")
	sheet_ready.custom_minimum_size = Vector2(0, 26)
	meters.add_child(sheet_ready)

	var crew := HBoxContainer.new()
	crew.add_theme_constant_override("separation", 8)
	box.add_child(crew)
	var cl := Label.new()
	cl.text = "Crew"
	cl.add_theme_color_override("font_color", Color("#cfe9f5"))
	cl.add_theme_font_size_override("font_size", 13)
	cl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	crew.add_child(cl)
	btn_minus = _icon(ICO_MINUS, func(): game.assign_worker(selected, -1); _sfx(SFX_TAP))
	crew.add_child(btn_minus)
	sheet_workers = Label.new()
	sheet_workers.custom_minimum_size = Vector2(56, 0)
	sheet_workers.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sheet_workers.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sheet_workers.add_theme_color_override("font_color", Color.WHITE)
	sheet_workers.add_theme_font_size_override("font_size", 14)
	crew.add_child(sheet_workers)
	btn_plus = _icon(ICO_PLUS, func(): game.assign_worker(selected, 1); _sfx(SFX_TAP))
	crew.add_child(btn_plus)
	var sp2 := Control.new()
	sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crew.add_child(sp2)
	btn_upgrade = _btn("Upgrade", ICO_WRENCH, Color("#a36a25"), func(): game.upgrade(selected); _sfx(SFX_CLICK))
	btn_upgrade.custom_minimum_size = Vector2(110, 40)
	crew.add_child(btn_upgrade)
	btn_move = _btn("Move", ICO_TARGET, Color("#6a5a9b"), _toggle_move)
	btn_move.custom_minimum_size = Vector2(90, 40)
	crew.add_child(btn_move)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 88)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	sheet_actions = HFlowContainer.new()
	sheet_actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sheet_actions.add_theme_constant_override("separation", 6)
	sheet_actions.add_theme_constant_override("v_separation", 6)
	scroll.add_child(sheet_actions)

func _build_menu() -> void:
	menu_dim = ColorRect.new()
	menu_dim.color = Color(0.01, 0.03, 0.06, 0.55)
	menu_dim.visible = false
	menu_dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	menu_dim.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed:
			_close_menu()
	)
	chrome.add_child(menu_dim)

	menu_panel = PanelContainer.new()
	menu_panel.visible = false
	menu_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	menu_panel.clip_contents = true
	menu_panel.anchor_left = 0.0
	menu_panel.anchor_right = 1.0
	menu_panel.anchor_top = 0.0
	menu_panel.anchor_bottom = 1.0
	menu_panel.add_theme_stylebox_override("panel", _glass(Color(0.96, 0.98, 1.0, 0.99), Color(1, 1, 1, 0.7), 16))
	chrome.add_child(menu_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	menu_panel.add_child(box)

	var head := HBoxContainer.new()
	box.add_child(head)
	menu_title = Label.new()
	menu_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_title.add_theme_color_override("font_color", Color("#153247"))
	menu_title.add_theme_font_size_override("font_size", 20)
	head.add_child(menu_title)
	head.add_child(_icon(ICO_CROSS, _close_menu))

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	menu_body = VBoxContainer.new()
	menu_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_body.add_theme_constant_override("separation", 8)
	scroll.add_child(menu_body)

func _build_toast() -> void:
	toast = Label.new()
	toast.visible = false
	toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast.z_index = 50
	toast.anchor_left = 0.12
	toast.anchor_right = 0.88
	toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	toast.add_theme_color_override("font_color", Color("#fff8e0"))
	toast.add_theme_font_size_override("font_size", 13)
	toast.add_theme_stylebox_override("normal", _glass(Color(0.06, 0.16, 0.14, 0.94), Color("#9ff0c8"), 10))
	chrome.add_child(toast)

var modal_layer: CanvasLayer
var tutorial_panel: PanelContainer
var tutorial_title: Label
var tutorial_body: Label
var choice_panel: PanelContainer
var choice_title: Label
var choice_body: Label
var choice_btns: VBoxContainer
var end_panel: PanelContainer
var end_title: Label
var end_body: Label

func _build_modals() -> void:
	modal_layer = CanvasLayer.new()
	modal_layer.layer = 60
	add_child(modal_layer)

	tutorial_panel = _modal()
	var tb: VBoxContainer = tutorial_panel.get_meta("box")
	tutorial_title = _mlabel(22, Color("#153247"))
	tb.add_child(tutorial_title)
	tutorial_body = _mlabel(15, Color("#2a4a5c"))
	tutorial_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tb.add_child(tutorial_body)
	var tr := HBoxContainer.new()
	tr.add_theme_constant_override("separation", 10)
	tb.add_child(tr)
	tr.add_child(_btn("Skip", ICO_MINUS, Color("#65757c"), func(): tutorial_panel.visible = false; game.skip_tutorial(); _sfx(SFX_SWITCH)))
	tr.add_child(_btn("Next", ICO_PLUS, Color("#1f7fab"), func(): tutorial_panel.visible = false; game.advance_tutorial(); _sfx(SFX_CLICK)))
	modal_layer.add_child(tutorial_panel)

	choice_panel = _modal()
	var cb: VBoxContainer = choice_panel.get_meta("box")
	choice_title = _mlabel(22, Color("#153247"))
	cb.add_child(choice_title)
	choice_body = _mlabel(15, Color("#2a4a5c"))
	choice_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cb.add_child(choice_body)
	choice_btns = VBoxContainer.new()
	choice_btns.add_theme_constant_override("separation", 8)
	cb.add_child(choice_btns)
	modal_layer.add_child(choice_panel)

	end_panel = _modal()
	var eb: VBoxContainer = end_panel.get_meta("box")
	end_title = _mlabel(24, Color("#153247"))
	eb.add_child(end_title)
	end_body = _mlabel(15, Color("#2a4a5c"))
	end_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	eb.add_child(end_body)
	eb.add_child(_btn("New Settlement", ICO_PLUS, Color("#1f7fab"), _new_game))
	modal_layer.add_child(end_panel)

# =============================================================================
# WORLD
# =============================================================================

func _rebuild_world() -> void:
	for c in world.get_children():
		c.queue_free()
	tiles.clear()
	bld_btns.clear()
	bld_badges.clear()
	bld_bubbles.clear()
	poi_btns.clear()
	place_layer = null
	place_preview = null

	var terrain := _terrain()
	for y in ROWS:
		for x in COLS:
			var cell := Vector2i(x, y)
			var t := TextureButton.new()
			t.position = Vector2(x * TILE, y * TILE)
			t.custom_minimum_size = Vector2(TILE, TILE)
			t.size = Vector2(TILE, TILE)
			t.ignore_texture_size = true
			t.stretch_mode = TextureButton.STRETCH_SCALE
			t.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			var tid: int = terrain[y][x]
			t.texture_normal = _tile_tex(tid)
			var base := _tile_mod(tid)
			t.modulate = base
			t.set_meta("cell", cell)
			t.set_meta("base", base)
			t.disabled = not _placing()
			t.pressed.connect(_commit_cell.bind(cell))
			tiles.append(t)
			world.add_child(t)

	for p in POIS:
		_add_poi(p)
	for id in positions.keys():
		if game.has_building(id):
			_add_building(id)
	_add_place_layer()

func _terrain() -> Array:
	var g := []
	for y in ROWS:
		var row := []
		for x in COLS:
			var id := 0
			if x == 13 and y >= 6 and y <= 24:
				id = 4
			elif y == 14 and x >= 6 and x <= 20:
				id = 2
			elif x >= 11 and x <= 15 and y >= 10 and y <= 14:
				id = 3
			elif (x + y * 2) % 10 == 0:
				id = 1
			row.append(id)
		g.append(row)
	for p in [Vector2i(1, 1), Vector2i(5, 3), Vector2i(22, 2), Vector2i(24, 6), Vector2i(3, 28), Vector2i(22, 30)]:
		if p.y < ROWS and p.x < COLS:
			g[p.y][p.x] = 10
	return g

func _tile_tex(id: int) -> Texture2D:
	match id:
		1: return TERRAIN_SNOW_ROUGH
		2: return TERRAIN_ROAD_H
		3: return TERRAIN_CLEARING
		4: return TERRAIN_ROAD_V
		10: return TERRAIN_PINE
		70: return TERRAIN_LOGS
	return TERRAIN_SNOW

func _tile_mod(id: int) -> Color:
	if id == 0:
		return Color("#e8f4f8")
	if id == 1:
		return Color("#f4faff")
	return Color.WHITE

func _add_poi(p: Dictionary) -> void:
	var cell: Vector2i = p["cell"]
	var tex: Texture2D = p["tex"]
	var sz := _cap(tex, 0.36, POI_MAX)
	var center := Vector2(cell.x * TILE + TILE * 0.5, cell.y * TILE + TILE * 0.5)
	var b := TextureButton.new()
	b.position = center - sz * 0.5
	b.custom_minimum_size = sz
	b.size = sz
	b.ignore_texture_size = true
	b.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	b.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	b.texture_normal = tex
	b.tooltip_text = "Scout: %s" % p["name"]
	b.z_index = 1
	b.pressed.connect(func():
		if _placing():
			return
		_sfx(SFX_CLICK)
		game.scout_site(p["id"], p["reward"], p["msg"])
	)
	poi_btns.append(b)
	world.add_child(b)

func _add_building(id: String) -> void:
	var tex := _spr(id)
	var lvl := int(game.buildings[id]["level"])
	var sz := _cap(tex, 0.32 + mini(lvl - 1, 2) * 0.03, BLD_MAX)
	var plot: Vector2i = positions[id]
	var center := Vector2(plot.x * TILE + TILE * 0.5, plot.y * TILE + TILE * 0.5)

	var b := TextureButton.new()
	b.position = center - sz * 0.5
	b.custom_minimum_size = sz
	b.size = sz
	b.ignore_texture_size = true
	b.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	b.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	b.texture_normal = tex
	b.tooltip_text = game.buildings[id]["name"]
	b.z_index = 3
	b.pressed.connect(_tap_building.bind(id))
	bld_btns[id] = b
	world.add_child(b)

	var badge := Label.new()
	badge.visible = false
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.position = Vector2(b.position.x, b.position.y + sz.y - 2)
	badge.custom_minimum_size = Vector2(maxi(36, int(sz.x * 0.65)), 16)
	badge.add_theme_color_override("font_color", Color("#0b2534"))
	badge.add_theme_font_size_override("font_size", 9)
	badge.add_theme_stylebox_override("normal", _pill(Color("#9ff0ff")))
	badge.z_index = 5
	bld_badges[id] = badge
	world.add_child(badge)

	var bubble := Button.new()
	bubble.visible = false
	bubble.focus_mode = Control.FOCUS_NONE
	bubble.text = "+"
	bubble.position = Vector2(b.position.x + sz.x - 16, b.position.y - 12)
	bubble.custom_minimum_size = Vector2(42, 28)
	bubble.add_theme_font_size_override("font_size", 11)
	bubble.add_theme_stylebox_override("normal", _glass(Color(0.1, 0.5, 0.32, 0.96), Color("#9ff0c8"), 14))
	bubble.add_theme_stylebox_override("hover", _glass(Color(0.14, 0.6, 0.4, 0.98), Color("#c8ffe0"), 14))
	bubble.add_theme_color_override("font_color", Color.WHITE)
	bubble.z_index = 7
	bubble.pressed.connect(_collect_building.bind(id))
	bld_bubbles[id] = bubble
	world.add_child(bubble)

func _add_place_layer() -> void:
	place_layer = Control.new()
	place_layer.custom_minimum_size = Vector2(COLS * TILE, ROWS * TILE)
	place_layer.size = place_layer.custom_minimum_size
	place_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place_layer.visible = false
	place_layer.z_index = 12
	place_layer.gui_input.connect(_place_input)
	world.add_child(place_layer)
	place_preview = TextureRect.new()
	place_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	place_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	place_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	place_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place_preview.visible = false
	place_layer.add_child(place_preview)

# =============================================================================
# LAYOUT
# =============================================================================

func _layout() -> void:
	if not ready_ui:
		return
	var vp := get_viewport_rect().size
	var compact := vp.x < 860.0 or vp.y > vp.x

	top_panel.offset_left = MARGIN
	top_panel.offset_top = MARGIN
	top_panel.offset_right = -MARGIN
	top_panel.reset_size()
	var top_h := maxf(top_panel.get_combined_minimum_size().y, 78.0)
	top_panel.offset_bottom = MARGIN + top_h
	var y := MARGIN + top_h + 6.0

	if storm_pill.visible:
		storm_pill.offset_left = MARGIN * 2
		storm_pill.offset_right = -MARGIN * 2
		storm_pill.offset_top = y
		storm_pill.offset_bottom = y + 28.0
		y += 32.0

	mission_pill.offset_left = MARGIN
	mission_pill.offset_right = MARGIN + (220.0 if not compact else minf(vp.x - MARGIN * 2, 280.0))
	mission_pill.offset_top = y
	mission_pill.offset_bottom = y + 40.0

	toast.offset_top = y + 46.0
	toast.offset_bottom = y + 76.0

	dock.offset_left = MARGIN
	dock.offset_right = -MARGIN
	dock.offset_top = -DOCK_H
	dock.offset_bottom = -MARGIN

	fab_collect.offset_left = -70
	fab_collect.offset_right = -MARGIN - 4
	fab_collect.offset_top = -(DOCK_H + 70)
	fab_collect.offset_bottom = -(DOCK_H + 16)

	var sheet_h := 300.0 if compact else 270.0
	sheet.offset_left = MARGIN
	sheet.offset_right = -MARGIN
	sheet.offset_top = -(sheet_h + DOCK_H + 2)
	sheet.offset_bottom = -(DOCK_H + 2)

	menu_panel.offset_left = MARGIN
	menu_panel.offset_right = -MARGIN
	menu_panel.offset_top = MARGIN + top_h + 8
	menu_panel.offset_bottom = -(DOCK_H + MARGIN)

# =============================================================================
# REFRESH
# =============================================================================

func _refresh() -> void:
	if not ready_ui or game == null:
		return
	_sync_positions()
	_ensure_selected()

	day_lbl.text = "Day %s · %s" % [game.day, game.season.replace(" Winter", "")]
	heat_bar.value = game.heat
	fuel_bar.value = game.furnace_fuel
	morale_bar.value = game.morale
	pause_btn.modulate = Color(1.4, 1.15, 0.7) if game.paused else Color.WHITE
	speed_btn.tooltip_text = "Speed %sx" % game.time_scale

	for key in RES_ORDER:
		var amt := int(game.resources.get(key, 0))
		var cap := int(game.storage_capacity(key))
		res_labels[key].text = "%s %s" % [RES_NAME[key].substr(0, 1), amt]
		res_labels[key].tooltip_text = "%s %s / %s" % [RES_NAME[key], amt, cap]
		var low := amt < maxi(1, int(cap * 0.18))
		res_labels[key].get_parent().add_theme_stylebox_override("panel", _glass(
			Color(0.4, 0.14, 0.1, 0.95) if low else Color(0.07, 0.14, 0.2, 0.95),
			RES_COLOR[key], 8
		))

	var ds := game.days_until_storm()
	if game.storm_active_days > 0:
		storm_pill.visible = true
		storm_label.text = "⚠ %s ACTIVE — feed the furnace" % game.storm_intensity.to_upper()
	elif ds >= 0 and ds <= 2:
		storm_pill.visible = true
		storm_label.text = "⚠ %s in %s day(s)" % [game.storm_intensity.to_upper(), ds]
	else:
		storm_pill.visible = false

	var missions := game.active_missions()
	if missions.is_empty():
		mission_label.text = "Ch.%s · All missions clear\nPower %s" % [game.current_chapter, game.settlement_power()]
	else:
		var g: Dictionary = missions[0]
		mission_label.text = "▶ %s\n%s" % [g["title"], g["progress"]]

	fab_collect.visible = game.has_any_bubbles() and menu_mode == "" and not sheet_open
	fab_collect.modulate = Color(1.15, 1.25, 1.1)

	# Buildings
	for id in bld_btns.keys():
		if not game.has_building(id):
			continue
		var bb: Dictionary = game.buildings[id]
		var btn: TextureButton = bld_btns[id]
		var badge: Label = bld_badges[id]
		btn.texture_normal = _spr(id)
		var bubble_n := game.bubble_total(id)
		if bld_bubbles.has(id):
			var bub: Button = bld_bubbles[id]
			bub.visible = bubble_n >= 1.0
			if bub.visible:
				var parts: Array[String] = []
				var am := game.bubble_amounts(id)
				for k in am.keys():
					if float(am[k]) >= 1.0:
						parts.append(str(int(am[k])))
				bub.text = "+%s" % ("/".join(parts) if not parts.is_empty() else "")
		var under := bool(bb.get("under_construction", false))
		var upg: bool = str(game.active_project.get("building_id", "")) == id
		if under or upg:
			badge.visible = true
			badge.text = "%s%%" % int(game.project_progress() * 100.0)
			badge.add_theme_stylebox_override("normal", _pill(Color("#f0c36a")))
			btn.modulate = Color(0.85, 0.9, 1.0, 0.8)
		elif float(bb["condition"]) < 30.0:
			badge.visible = true
			badge.text = "WEAK"
			badge.add_theme_stylebox_override("normal", _pill(Color("#f08a6a")))
			btn.modulate = Color(1.12, 0.85, 0.82)
		elif float(bb["readiness"]) >= 100.0 and bubble_n < 1.0:
			badge.visible = true
			badge.text = "READY"
			badge.add_theme_stylebox_override("normal", _pill(Color("#9ff0ff")))
			btn.modulate = Color(1.3, 1.3, 1.3) if id == selected and sheet_open else Color("#d8fff1")
		else:
			badge.visible = false
			btn.modulate = Color(1.3, 1.3, 1.3) if id == selected and sheet_open else Color(0.97, 1.0, 1.04)

	for i in poi_btns.size():
		if i >= POIS.size():
			break
		var p: Dictionary = POIS[i]
		var b: TextureButton = poi_btns[i]
		if game.scouted_sites.has(p["id"]):
			b.modulate = Color(0.5, 0.58, 0.62, 0.45)
			b.tooltip_text = "%s (scouted)" % p["name"]
		else:
			b.modulate = Color.WHITE
			b.tooltip_text = "Scout: %s" % p["name"]

	if sheet_open and game.has_building(selected):
		_refresh_sheet()
	if menu_mode != "":
		_fill_menu()

	_layout()

func _refresh_sheet() -> void:
	var b: Dictionary = game.buildings[selected]
	sheet_preview.texture = _spr(selected)
	sheet_title.text = String(b["name"])
	sheet_sub.text = "Lv.%s  ·  %s  ·  %s idle" % [b["level"], game.building_status_text(selected), game.available_workers]
	var d := game.building_details(selected)
	var prod := _fmt_prod(game.production_preview(selected))
	sheet_stats.text = "%s\n%s · %s\n⚠ %s" % [d["role"], d["output"], prod, d["risk"]]
	sheet_hp.value = float(b["condition"])
	sheet_ready.value = float(b["readiness"])
	sheet_workers.text = "%s/%s" % [b["workers"], b["max_workers"]]
	var op := game.is_building_operational(selected)
	btn_plus.disabled = game.game_over or not op or game.available_workers <= 0 or int(b["workers"]) >= int(b["max_workers"])
	btn_minus.disabled = game.game_over or not op or int(b["workers"]) <= 0
	var bn := game.bubble_total(selected)
	btn_collect.disabled = bn < 1.0
	btn_collect.text = "Collect" if bn < 1.0 else "Take %.0f" % bn
	btn_upgrade.disabled = not game.can_upgrade(selected)
	btn_upgrade.tooltip_text = "Cost: %s" % _fmt_cost(game.upgrade_cost(selected))
	btn_move.disabled = game.game_over or not op
	btn_move.text = "Moving" if move_mode else "Move"
	_queue_actions()

func _queue_actions() -> void:
	if rebuild_actions_q:
		return
	rebuild_actions_q = true
	call_deferred("_rebuild_actions")

func _rebuild_actions() -> void:
	rebuild_actions_q = false
	for c in sheet_actions.get_children():
		c.queue_free()
	if not game.is_building_operational(selected):
		var b := _btn(game.building_status_text(selected), ICO_WARN, Color("#425f75"), func(): pass)
		b.disabled = true
		sheet_actions.add_child(b)
		return
	for a in game.building_actions(selected):
		var aid: String = a["id"]
		var btn := _btn("%s" % a["name"], ICO_TARGET, Color("#1f6f94"), func():
			_sfx(SFX_CLICK)
			game.perform_building_action(selected, aid)
		)
		btn.custom_minimum_size = Vector2(120, 40)
		btn.add_theme_font_size_override("font_size", 11)
		btn.disabled = game.game_over or not game.can_perform_building_action(selected, aid)
		btn.tooltip_text = "%s\nCost: %s\n%s" % [a["name"], a["cost"], a["effect"]]
		sheet_actions.add_child(btn)

# =============================================================================
# MENUS
# =============================================================================

func _open_menu(mode: String) -> void:
	_sfx(SFX_SWITCH)
	_close_sheet()
	if menu_mode == mode:
		_close_menu()
		return
	menu_mode = mode
	menu_dim.visible = true
	menu_panel.visible = true
	fab_collect.visible = false
	_fill_menu()
	_layout()

func _close_menu() -> void:
	menu_mode = ""
	menu_dim.visible = false
	menu_panel.visible = false
	_layout()
	_refresh()

func _fill_menu() -> void:
	for c in menu_body.get_children():
		c.queue_free()
	match menu_mode:
		"build":
			menu_title.text = "Build City"
			for id in game.building_ids():
				menu_body.add_child(_build_row(id))
		"people":
			menu_title.text = "Survivors"
			var s := Label.new()
			s.text = "Idle %s · Sick %s · Total %s · Power %s" % [
				game.idle_survivor_count(), game.sick_survivor_count(), game.homesteaders, game.settlement_power()
			]
			s.add_theme_color_override("font_color", Color("#153247"))
			s.add_theme_font_size_override("font_size", 13)
			menu_body.add_child(s)
			for person in game.survivor_list():
				menu_body.add_child(_person_row(person))
		"missions":
			menu_title.text = "Missions"
			for g in game.survival_goals():
				menu_body.add_child(_goal_card(g))
			var h := Label.new()
			h.text = "City Log"
			h.add_theme_color_override("font_color", Color("#153247"))
			h.add_theme_font_size_override("font_size", 15)
			menu_body.add_child(h)
			for i in mini(8, game.event_log.size()):
				menu_body.add_child(_log_card(game.event_log[i]))
		"more":
			menu_title.text = "Command"
			menu_body.add_child(_btn("Save City", ICO_SAVE, Color("#356b5f"), _save))
			menu_body.add_child(_btn("Load City", ICO_HOME, Color("#425f75"), _load))
			menu_body.add_child(_btn("New Game", ICO_PLUS, Color("#7a4a3a"), _new_game))
			menu_body.add_child(_btn("Expedition", ICO_TARGET, Color("#2f6b62"), func(): game.send_expedition(); _sfx(SFX_CLICK)))
			menu_body.add_child(_btn("Stoke Furnace", ICO_WRENCH, Color("#a36a25"), func(): game.repair_hearth(); _sfx(SFX_CLICK)))
			var tip := Label.new()
			tip.text = "Drag map · P pause · 1/2/3 speed · C collect · Esc close\nTap buildings to open. Green + bubbles = collect."
			tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			tip.add_theme_color_override("font_color", Color("#2a4a5c"))
			tip.add_theme_font_size_override("font_size", 12)
			menu_body.add_child(tip)

func _build_row(id: String) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _glass(Color(1, 1, 1, 0.95), Color(0.55, 0.75, 0.88, 0.35), 10))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	card.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _blueprint(id)
	icon.custom_minimum_size = Vector2(56, 48)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	row.add_child(icon)

	var info := Label.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_theme_color_override("font_color", Color("#153247"))
	info.add_theme_font_size_override("font_size", 12)
	row.add_child(info)

	if game.has_building(id):
		var b: Dictionary = game.buildings[id]
		info.text = "%s  Lv.%s\n%s/%s crew · %s%% HP\n%s" % [
			b["name"], b["level"], b["workers"], b["max_workers"], int(b["condition"]),
			game.building_status_text(id)
		]
		icon.modulate = Color.WHITE
		var open := _btn("Open", ICO_HOME, Color("#1f7fab"), func():
			_close_menu()
			_open_sheet(id)
		)
		open.custom_minimum_size = Vector2(80, 40)
		row.add_child(open)
		var up := _icon(ICO_WRENCH, func(): game.upgrade(id); _sfx(SFX_CLICK))
		up.disabled = not game.can_upgrade(id)
		row.add_child(up)
	else:
		info.text = "%s\n%s\n%s" % [game.building_name(id), game.building_status_text(id), _fmt_cost(game.build_cost(id))]
		icon.modulate = Color(0.7, 0.82, 0.9, 0.7)
		var place := _btn("Place", ICO_PLUS if game.is_building_unlocked(id) else ICO_LOCK, Color("#1f7fab"), func():
			_begin_place(id)
		)
		place.custom_minimum_size = Vector2(88, 40)
		place.disabled = not game.can_build(id)
		row.add_child(place)
	return card

func _person_row(p: Dictionary) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _glass(Color(1, 1, 1, 0.95), Color(0.55, 0.75, 0.88, 0.3), 10))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	card.add_child(row)
	var info := Label.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.text = "%s\n%s · HP %s%%" % [p["name"], p.get("role", "Idle"), int(p.get("health", 100))]
	info.add_theme_color_override("font_color", Color("#153247"))
	info.add_theme_font_size_override("font_size", 12)
	row.add_child(info)
	var sid := int(p["id"])
	var idle := _btn("Idle", ICO_MINUS, Color("#5a6a73"), func(): game.assign_survivor(sid, ""); _sfx(SFX_TAP))
	idle.custom_minimum_size = Vector2(70, 36)
	idle.disabled = str(p.get("building_id", "")) == ""
	row.add_child(idle)
	var job := _btn("Assign", ICO_PLUS, Color("#1f7fab"), func():
		if sheet_open:
			game.assign_survivor(sid, selected)
		else:
			game.assign_survivor(sid, "cabin")
		_sfx(SFX_TAP)
	)
	job.custom_minimum_size = Vector2(80, 36)
	row.add_child(job)
	return card

func _goal_card(g: Dictionary) -> Control:
	var done := bool(g["complete"])
	var active := bool(g.get("active", false))
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _glass(
		Color(0.78, 1.0, 0.88, 0.9) if done else Color(1, 1, 1, 0.95),
		Color("#7be7aa") if done else Color(0.55, 0.75, 0.88, 0.3), 10
	))
	var box := VBoxContainer.new()
	card.add_child(box)
	var t := Label.new()
	t.text = "%s %s" % ["✓" if done else ("▶" if active else "·"), g["title"]]
	t.add_theme_color_override("font_color", Color("#0d4b35") if done else Color("#123247"))
	t.add_theme_font_size_override("font_size", 13)
	box.add_child(t)
	var d := Label.new()
	d.text = "%s\n%s\n%s" % [g.get("chapter_title", ""), g["detail"], g["progress"]]
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	d.add_theme_color_override("font_color", Color("#3c6b58") if done else Color("#315265"))
	d.add_theme_font_size_override("font_size", 11)
	box.add_child(d)
	return card

func _log_card(msg: String) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _glass(Color(0.06, 0.16, 0.24, 0.92), Color(0.5, 0.8, 1.0, 0.2), 8))
	var l := Label.new()
	l.text = msg
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_color_override("font_color", Color("#d8edf7"))
	l.add_theme_font_size_override("font_size", 12)
	card.add_child(l)
	return card

# =============================================================================
# ACTIONS
# =============================================================================

func _tap_building(id: String) -> void:
	_sfx(SFX_TAP)
	if game.bubble_total(id) >= 1.0 and selected == id and sheet_open:
		_collect_building(id)
		return
	_open_sheet(id)

func _open_sheet(id: String) -> void:
	if not game.has_building(id):
		return
	selected = id
	sheet_open = true
	sheet.visible = true
	sheet_dim.visible = true
	fab_collect.visible = false
	_refresh_sheet()
	_layout()

func _close_sheet() -> void:
	sheet_open = false
	sheet.visible = false
	sheet_dim.visible = false
	if move_mode:
		_cancel_move()
	_layout()
	_refresh()

func _collect_building(id: String) -> void:
	_sfx(SFX_COLLECT)
	var gained := game.collect_from_building(id)
	if gained.is_empty():
		return
	_fx(id, gained)

func _collect_selected() -> void:
	_collect_building(selected)

func _collect_all() -> void:
	_sfx(SFX_COLLECT)
	var gained := game.collect_all()
	if gained.is_empty():
		_toast("Nothing to collect")
		return
	var parts: Array[String] = []
	for k in gained.keys():
		parts.append("+%s %s" % [int(gained[k]), k])
	_toast("Collected " + ", ".join(parts))
	if bld_btns.has("cabin"):
		FloatingTextScript.spawn(self, bld_btns["cabin"].get_global_position() + bld_btns["cabin"].size * 0.5, "COLLECT", Color("#9ff0c8"))

func _on_collected(id: String, amounts: Dictionary) -> void:
	_fx(id, amounts)

func _fx(id: String, amounts: Dictionary) -> void:
	if not bld_btns.has(id):
		return
	var b: Control = bld_btns[id]
	var pos := b.get_global_position() + b.size * 0.5
	var y := 0.0
	for k in amounts.keys():
		FloatingTextScript.spawn(self, pos + Vector2(0, y), "+%s %s" % [int(amounts[k]), k], RES_COLOR.get(str(k), Color.WHITE))
		y -= 16.0

func _toggle_move() -> void:
	_sfx(SFX_SWITCH)
	placing = ""
	move_mode = not move_mode
	_set_place_tiles(move_mode)
	_toast("Tap empty snow to move" if move_mode else "Move canceled")

func _cancel_move() -> void:
	move_mode = false
	_set_place_tiles(false)

func _begin_place(id: String) -> void:
	if game.has_building(id):
		_close_menu()
		_open_sheet(id)
		return
	if not game.can_build(id):
		_toast("Can't place that yet")
		return
	_sfx(SFX_SWITCH)
	_close_menu()
	move_mode = false
	placing = id
	place_cell = _find_spot()
	_set_place_tiles(true)
	_update_place_preview(place_cell)
	_toast("Place %s — green OK · Enter confirm" % game.building_name(id))

func _cancel_place() -> void:
	placing = ""
	_set_place_tiles(false)
	_toast("Placement canceled")

func _commit_cell(cell: Vector2i) -> void:
	if placing != "":
		if _blocked(cell) or _too_close(cell):
			_toast("Need clear space")
			return
		var id := placing
		if game.build(id):
			positions[id] = cell
			selected = id
			_queue_world()
			_toast("%s building…" % game.building_name(id))
			call_deferred("_open_sheet", id)
		placing = ""
		_set_place_tiles(false)
		return
	if move_mode:
		var saved: Vector2i = positions.get(selected, cell)
		positions.erase(selected)
		if _blocked(cell) or _too_close(cell):
			positions[selected] = saved
			_toast("Need clear space")
			return
		positions[selected] = cell
		move_mode = false
		_set_place_tiles(false)
		_queue_world()
		_toast("Moved %s" % game.building_name(selected))

func _set_place_tiles(on: bool) -> void:
	for t in tiles:
		if not is_instance_valid(t):
			continue
		t.disabled = not on
		var base: Color = t.get_meta("base")
		if on:
			var cell: Vector2i = t.get_meta("cell")
			var bad := false
			if move_mode:
				var saved_pos: Vector2i = positions.get(selected, Vector2i(-99, -99))
				var occupied_other := false
				for id in positions.keys():
					if id != selected and positions[id] == cell:
						occupied_other = true
						break
				for p in POIS:
					if p["cell"] == cell:
						occupied_other = true
						break
				bad = occupied_other or _too_close_except(cell, selected)
				if saved_pos == cell:
					bad = false
			else:
				bad = _blocked(cell) or _too_close(cell)
			t.modulate = Color(1.0, 0.55, 0.5, 0.85) if bad else Color(0.7, 1.0, 0.95, 1.0)
		else:
			t.modulate = base
	for p in poi_btns:
		if is_instance_valid(p):
			p.mouse_filter = Control.MOUSE_FILTER_IGNORE if on else Control.MOUSE_FILTER_STOP
	if place_layer:
		place_layer.visible = on
		place_layer.mouse_filter = Control.MOUSE_FILTER_STOP if on else Control.MOUSE_FILTER_IGNORE
	if place_preview:
		place_preview.visible = on and placing != ""

func _place_input(ev: InputEvent) -> void:
	if not _placing():
		return
	if ev is InputEventMouseMotion:
		_update_place_preview(_cell((ev as InputEventMouseMotion).position))
	elif ev is InputEventMouseButton:
		var mb := ev as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_commit_cell(_cell(mb.position))
			place_layer.accept_event()
	elif ev is InputEventScreenDrag:
		_update_place_preview(_cell((ev as InputEventScreenDrag).position))
	elif ev is InputEventScreenTouch:
		var st := ev as InputEventScreenTouch
		if st.pressed:
			_commit_cell(_cell(st.position))
			place_layer.accept_event()

func _update_place_preview(cell: Vector2i) -> void:
	place_cell = cell
	if place_preview == null or placing == "":
		return
	var tex := _blueprint(placing)
	var sz := _cap(tex, 0.32, BLD_MAX)
	var center := Vector2(cell.x * TILE + TILE * 0.5, cell.y * TILE + TILE * 0.5)
	place_preview.texture = tex
	place_preview.custom_minimum_size = sz
	place_preview.size = sz
	place_preview.position = center - sz * 0.5
	var bad := _blocked(cell) or _too_close(cell)
	place_preview.modulate = Color(1.0, 0.45, 0.4, 0.7) if bad else Color(0.65, 1.0, 1.0, 0.78)
	place_preview.visible = true

func _placing() -> bool:
	return placing != "" or move_mode

func _blocked(cell: Vector2i) -> bool:
	for p in positions.values():
		if p == cell:
			return true
	for p in POIS:
		if p["cell"] == cell:
			return true
	return false

func _too_close(cell: Vector2i) -> bool:
	return _too_close_except(cell, "" if placing != "" else selected)

func _too_close_except(cell: Vector2i, except_id: String) -> bool:
	for id in positions.keys():
		if except_id != "" and id == except_id:
			continue
		var o: Vector2i = positions[id]
		if absi(o.x - cell.x) < GAP and absi(o.y - cell.y) < GAP:
			return true
	return false

func _find_spot() -> Vector2i:
	var origin: Vector2i = positions.get("cabin", Vector2i(13, 12))
	for r in range(GAP, 12):
		for dy in range(-r, r + 1):
			for dx in range(-r, r + 1):
				var c := Vector2i(origin.x + dx, origin.y + dy)
				if c.x > 2 and c.y > 2 and c.x < COLS - 3 and c.y < ROWS - 3:
					if not _blocked(c) and not _too_close(c):
						return c
	return Vector2i(origin.x + GAP, origin.y + GAP)

func _cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		clampi(int(floor(pos.x / TILE)), 0, COLS - 1),
		clampi(int(floor(pos.y / TILE)), 0, ROWS - 1)
	)

func _sync_positions() -> void:
	var miss := false
	for id in game.buildings.keys():
		if not positions.has(id):
			positions[id] = _find_spot()
			miss = true
	var stale: Array[String] = []
	for id in positions.keys():
		if not game.has_building(id):
			stale.append(id)
	for id in stale:
		positions.erase(id)
		miss = true
	for id in game.buildings.keys():
		if not bld_btns.has(id):
			miss = true
	if miss:
		_queue_world()

func _queue_world() -> void:
	if rebuild_world_q:
		return
	rebuild_world_q = true
	call_deferred("_do_rebuild_world")

func _do_rebuild_world() -> void:
	rebuild_world_q = false
	_rebuild_world()
	_refresh()

func _ensure_selected() -> void:
	if game.has_building(selected):
		return
	for id in game.building_ids():
		if game.has_building(id):
			selected = id
			return

func _center_city() -> void:
	await get_tree().process_frame
	if map_scroll == null:
		return
	var c: Vector2i = positions.get("cabin", Vector2i(13, 12))
	map_scroll.scroll_horizontal = maxi(0, int(c.x * TILE - map_scroll.size.x * 0.5))
	map_scroll.scroll_vertical = maxi(0, int(c.y * TILE - map_scroll.size.y * 0.45))

func _map_input(ev: InputEvent) -> void:
	if _placing():
		return
	if ev is InputEventMouseButton:
		var mb := ev as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			drag = mb.pressed
			drag_last = mb.position
		elif mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			map_scroll.scroll_vertical -= 56
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			map_scroll.scroll_vertical += 56
	elif ev is InputEventMouseMotion and drag:
		var mm := ev as InputEventMouseMotion
		var d: Vector2 = drag_last - mm.position
		map_scroll.scroll_horizontal += int(d.x)
		map_scroll.scroll_vertical += int(d.y)
		drag_last = mm.position
	elif ev is InputEventScreenDrag:
		var sd := ev as InputEventScreenDrag
		map_scroll.scroll_horizontal -= int(sd.relative.x)
		map_scroll.scroll_vertical -= int(sd.relative.y)

func _pulse_bubbles() -> void:
	var s := 1.0 + sin(pulse * 4.0) * 0.07
	for id in bld_bubbles.keys():
		var b: Button = bld_bubbles[id]
		if is_instance_valid(b) and b.visible:
			b.scale = Vector2(s, s)

func _store_layout() -> void:
	var layout := {}
	for id in positions.keys():
		var c: Vector2i = positions[id]
		layout[id] = {"x": c.x, "y": c.y}
	game.layout_data = {"buildings": layout}

func _restore_layout() -> void:
	positions = {"cabin": Vector2i(13, 12)}
	var layout: Dictionary = game.layout_data.get("buildings", {})
	for id in layout.keys():
		if not game.has_building(id):
			continue
		var e: Dictionary = layout[id]
		positions[id] = Vector2i(int(e.get("x", 13)), int(e.get("y", 12)))
	for id in game.buildings.keys():
		if not positions.has(id):
			positions[id] = _find_spot()
	_queue_world()

func _save() -> void:
	_sfx(SFX_CLICK)
	_store_layout()
	_toast("City saved" if game.save_game() else "Save failed")

func _load() -> void:
	_sfx(SFX_CLICK)
	if not game.has_save():
		_toast("No save found")
		return
	if game.load_game():
		placing = ""
		move_mode = false
		_set_place_tiles(false)
		_close_menu()
		_close_sheet()
		if tutorial_panel:
			tutorial_panel.visible = false
		if choice_panel:
			choice_panel.visible = false
		if end_panel:
			end_panel.visible = false
		_restore_layout()
		call_deferred("_center_city")
		_toast("Loaded day %s" % game.day)
		_refresh()

func _new_game() -> void:
	_sfx(SFX_CLICK)
	if tutorial_panel:
		tutorial_panel.visible = false
	if choice_panel:
		choice_panel.visible = false
	if end_panel:
		end_panel.visible = false
	placing = ""
	move_mode = false
	_set_place_tiles(false)
	_close_menu()
	_close_sheet()
	positions = {"cabin": Vector2i(13, 12)}
	game.start_new_game()
	_queue_world()
	call_deferred("_center_city")
	_refresh()

func _on_tutorial(_s: int, title: String, body: String) -> void:
	tutorial_title.text = title
	tutorial_body.text = body
	tutorial_panel.visible = true

func _on_choice(_id: String, title: String, body: String, options: Array) -> void:
	choice_title.text = title
	choice_body.text = body
	for c in choice_btns.get_children():
		c.queue_free()
	for o in options:
		var oid := str(o.get("id", ""))
		var b := _btn(str(o.get("label", "Choose")), ICO_TARGET, Color("#1f6f94"), func():
			_sfx(SFX_CLICK)
			choice_panel.visible = false
			game.resolve_choice(oid)
			if not game.game_over:
				game.set_paused(false)
		)
		b.custom_minimum_size = Vector2(280, 48)
		choice_btns.add_child(b)
	choice_panel.visible = true

func _on_end(won: bool, summary: String) -> void:
	end_title.text = "CITY SECURED" if won else "CITY FALLEN"
	end_body.text = (
		"Frostfall outlasted the whiteout.\n\n%s" if won else "The storm broke Frostfall.\n\n%s"
	) % summary
	end_panel.visible = true
	_sfx(SFX_SWITCH)

func _toast(msg: String) -> void:
	if toast == null:
		return
	toast.text = "  %s  " % msg
	toast.visible = true
	toast_t = 2.3

func _sfx(stream: AudioStream) -> void:
	if sfx == null or game == null or not game.sfx_enabled:
		return
	sfx.stream = stream
	sfx.play()

# =============================================================================
# WIDGETS
# =============================================================================

func _spr(id: String) -> Texture2D:
	var opts: Array = SPRITES[id]
	var lvl := int(game.buildings[id]["level"]) if game.has_building(id) else 1
	return opts[clampi(lvl - 1, 0, opts.size() - 1)]

func _blueprint(id: String) -> Texture2D:
	return SPRITES[id][0]

func _cap(tex: Texture2D, scale: float, max_px: float) -> Vector2:
	var s := Vector2(tex.get_width(), tex.get_height()) * scale
	var m := maxf(s.x, s.y)
	if m > max_px and m > 0.0:
		s *= max_px / m
	return s

func _fmt_prod(prod: Dictionary) -> String:
	var parts: Array[String] = []
	for k in prod.keys():
		if str(k) == "heat_gen":
			continue
		parts.append("+%.1f %s/d" % [float(prod[k]), k])
	return ", ".join(parts) if not parts.is_empty() else "support"

func _fmt_cost(cost: Dictionary) -> String:
	var parts: Array[String] = []
	for k in ["wood", "tools", "coal", "iron", "seed", "food"]:
		if cost.has(k) and int(cost[k]) > 0:
			parts.append("%s %s" % [int(cost[k]), k])
	return ", ".join(parts) if not parts.is_empty() else "free"

func _glass(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(1)
	s.set_corner_radius_all(radius)
	s.content_margin_left = 12
	s.content_margin_top = 10
	s.content_margin_right = 12
	s.content_margin_bottom = 10
	s.shadow_color = Color(0, 0.04, 0.08, 0.28)
	s.shadow_size = 8
	s.shadow_offset = Vector2(0, 3)
	return s

func _pill(bg: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(6)
	s.content_margin_left = 4
	s.content_margin_right = 4
	s.content_margin_top = 1
	s.content_margin_bottom = 1
	return s

func _bar(fill: Color, tip: String) -> ProgressBar:
	var p := ProgressBar.new()
	p.min_value = 0
	p.max_value = 100
	p.show_percentage = true
	p.tooltip_text = tip
	p.custom_minimum_size = Vector2(70, 20)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("background", _glass(Color(0.04, 0.1, 0.15, 0.8), Color(0.4, 0.7, 0.9, 0.15), 6))
	var f := StyleBoxFlat.new()
	f.bg_color = fill
	f.set_corner_radius_all(6)
	p.add_theme_stylebox_override("fill", f)
	p.add_theme_color_override("font_color", Color("#f7fbff"))
	p.add_theme_font_size_override("font_size", 9)
	return p

func _btn(text: String, icon: Texture2D, color: Color, cb: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.icon = icon
	b.expand_icon = true
	b.custom_minimum_size = Vector2(120, 44)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_stylebox_override("normal", _glass(color, Color(1, 1, 1, 0.28), 10))
	b.add_theme_stylebox_override("hover", _glass(color.lightened(0.12), Color(1, 1, 1, 0.4), 10))
	b.add_theme_stylebox_override("pressed", _glass(color.darkened(0.12), Color(1, 1, 1, 0.2), 10))
	b.add_theme_stylebox_override("disabled", _glass(Color("#5a6a73"), Color(1, 1, 1, 0.12), 10))
	b.add_theme_color_override("font_color", Color.WHITE)
	b.add_theme_font_size_override("font_size", 13)
	b.pressed.connect(cb)
	return b

func _icon(icon: Texture2D, cb: Callable) -> Button:
	var b := Button.new()
	b.icon = icon
	b.expand_icon = true
	b.custom_minimum_size = Vector2(40, 36)
	b.add_theme_stylebox_override("normal", _glass(Color("#1d6d93"), Color(1, 1, 1, 0.25), 8))
	b.add_theme_stylebox_override("hover", _glass(Color("#2588b4"), Color(1, 1, 1, 0.35), 8))
	b.add_theme_stylebox_override("pressed", _glass(Color("#165675"), Color(1, 1, 1, 0.2), 8))
	b.add_theme_stylebox_override("disabled", _glass(Color("#65757c"), Color(1, 1, 1, 0.12), 8))
	b.pressed.connect(cb)
	return b

func _dock_btn(text: String, icon: Texture2D, color: Color, cb: Callable) -> Button:
	var b := _btn(text, icon, color, cb)
	b.custom_minimum_size = Vector2(0, 58)
	b.add_theme_font_size_override("font_size", 12)
	return b

func _mlabel(size: int, color: Color) -> Label:
	var l := Label.new()
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_size_override("font_size", size)
	return l

func _modal() -> PanelContainer:
	var dim := PanelContainer.new()
	dim.visible = false
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_theme_stylebox_override("panel", _glass(Color(0.01, 0.04, 0.08, 0.72), Color(0, 0, 0, 0), 0))
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(380, 0)
	card.add_theme_stylebox_override("panel", _glass(Color(0.97, 0.99, 1.0, 0.99), Color(1, 1, 1, 0.75), 16))
	center.add_child(card)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	card.add_child(box)
	dim.set_meta("box", box)
	return dim
