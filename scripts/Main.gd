extends Control

## Frostfall — Whiteout Survival visual layout.
## Pure snow camp, central fire, ring buildings, green footprint, build cards tray.

const GS := preload("res://scripts/GameState.gd")
const BG := preload("res://scripts/PolishedBackground.gd")
const SNOW := preload("res://scripts/SnowOverlay.gd")
const FIRE := preload("res://scripts/Campfire.gd")
const FLOAT := preload("res://scripts/FloatingText.gd")
const FONT := preload("res://assets/kenney_ui_pack/Font/Kenney Future.ttf")

const T_SNOW := preload("res://assets/map_details/snow_plain.png")
const T_SNOW2 := preload("res://assets/map_details/tile_snow.png")
const T_ROUGH := preload("res://assets/map_details/snow_rough.png")
const T_DRIFT := preload("res://assets/map_details/snow_drifts.png")
const T_PINE := preload("res://assets/map_details/tile_pine.png")
const T_CLEAR := preload("res://assets/map_details/tile_clearing.png")

const SPR_HOME := preload("res://assets/building_upgrades/homestead_l1.png")
const SPR_H2 := preload("res://assets/building_upgrades/city_hall_l2.png")
const SPR_H3 := preload("res://assets/building_upgrades/city_hall_l3.png")
const SPR_L1 := preload("res://assets/building_upgrades/hunters_lodge_l1.png")
const SPR_L2 := preload("res://assets/building_upgrades/hunters_lodge_l2.png")
const SPR_L3 := preload("res://assets/building_upgrades/hunters_lodge_l3.png")
const SPR_S1 := preload("res://assets/building_upgrades/sawmill_l1.png")
const SPR_S2 := preload("res://assets/building_upgrades/sawmill_l2.png")
const SPR_S3 := preload("res://assets/building_upgrades/sawmill_l3.png")
const SPR_M1 := preload("res://assets/building_upgrades/coal_mine_l1.png")
const SPR_M2 := preload("res://assets/building_upgrades/coal_mine_l2.png")
const SPR_M3 := preload("res://assets/building_upgrades/coal_mine_l3.png")
const SPR_W1 := preload("res://assets/building_upgrades/shelters_l1.png")
const SPR_W2 := preload("res://assets/building_upgrades/shelters_l2.png")
const SPR_W3 := preload("res://assets/building_upgrades/shelters_l3.png")

const D_TIMBER := preload("res://assets/map_details/timber_forest_l1.png")
const D_STONE := preload("res://assets/map_details/stone_rocks_l1.png")
const D_HUNT := preload("res://assets/map_details/hunting_tracks_l1.png")
const D_CAMP := preload("res://assets/map_details/camp_poi.png")
const D_CAVE := preload("res://assets/map_details/ice_cave.png")
const D_OUT := preload("res://assets/map_details/outpost.png")
const D_QUAR := preload("res://assets/map_details/quarry_l3.png")
const D_ORE := preload("res://assets/map_details/ore_mine_l2.png")
const D_ROCK := preload("res://assets/map_details/stone_rocks_l1.png")
const D_BLIND := preload("res://assets/map_details/hunting_blind_l3.png")
const D_CARC := preload("res://assets/map_details/hunting_carcass_l2.png")
const D_TCAMP := preload("res://assets/map_details/timber_camp_l2.png")
const D_SAW := preload("res://assets/map_details/timber_sawmill_l3.png")

const I_PLUS := preload("res://assets/kenney_game_icons/PNG/White/2x/plus.png")
const I_MINUS := preload("res://assets/kenney_game_icons/PNG/White/2x/minus.png")
const I_WRENCH := preload("res://assets/kenney_game_icons/PNG/White/2x/wrench.png")
const I_TARGET := preload("res://assets/kenney_game_icons/PNG/White/2x/target.png")
const I_STAR := preload("res://assets/kenney_game_icons/PNG/White/2x/star.png")
const I_USER := preload("res://assets/kenney_game_icons/PNG/White/2x/singleplayer.png")
const I_MENU := preload("res://assets/kenney_game_icons/PNG/White/2x/menuGrid.png")
const I_CHECK := preload("res://assets/kenney_game_icons/PNG/White/2x/checkmark.png")
const I_PAUSE := preload("res://assets/kenney_game_icons/PNG/White/2x/pause.png")
const I_FF := preload("res://assets/kenney_game_icons/PNG/White/2x/fastForward.png")
const I_SAVE := preload("res://assets/kenney_game_icons/PNG/White/2x/save.png")
const I_HOME := preload("res://assets/kenney_game_icons/PNG/White/2x/home.png")
const I_LOCK := preload("res://assets/kenney_game_icons/PNG/White/2x/locked.png")
const I_X := preload("res://assets/kenney_game_icons/PNG/White/2x/cross.png")
const I_WARN := preload("res://assets/kenney_game_icons/PNG/White/2x/warning.png")

const SFX_A := preload("res://assets/kenney_ui_pack/Sounds/click-a.ogg")
const SFX_B := preload("res://assets/kenney_ui_pack/Sounds/tap-a.ogg")
const SFX_C := preload("res://assets/kenney_ui_pack/Sounds/switch-a.ogg")
const SFX_D := preload("res://assets/kenney_ui_pack/Sounds/tap-b.ogg")

const TILE := 56
const COLS := 24
const ROWS := 24
const CX := 12
const CY := 12
const BMAX := 100.0
const PMAX := 70.0
const GAP := 2
const TRAY_H := 148.0
const DOCK_H := 72.0

const SPRITES := {
	"cabin": [SPR_HOME, SPR_H2, SPR_H3],
	"woodlot": [SPR_S1, SPR_S2, SPR_S3],
	"garden": [SPR_L1, SPR_L2, SPR_L3],
	"well": [SPR_W1, SPR_W2, SPR_W3],
	"hunter": [D_HUNT, D_BLIND, D_CARC],
	"workshop": [SPR_M1, SPR_M2, SPR_M3],
	"kitchen": [D_CAMP, D_TCAMP, D_SAW],
	"warehouse": [D_ROCK, D_ORE, D_QUAR],
	"root_cellar": [D_CAVE, D_ROCK, D_QUAR],
	"smokehouse": [D_TCAMP, D_BLIND, D_SAW],
	"coop": [D_CAMP, D_OUT, D_CARC],
	"infirmary": [SPR_W2, SPR_W3, SPR_HOME],
	"watchtower": [D_OUT, D_BLIND, SPR_H2],
}

# Ring slots around central fire (Whiteout camp layout)
const RING := [
	Vector2i(12, 9), Vector2i(15, 10), Vector2i(16, 12), Vector2i(15, 14),
	Vector2i(12, 15), Vector2i(9, 14), Vector2i(8, 12), Vector2i(9, 10),
	Vector2i(14, 8), Vector2i(16, 14), Vector2i(10, 16), Vector2i(7, 11),
	Vector2i(17, 11),
]

const POIS := [
	{"id": "t1", "name": "Timber", "tex": D_TIMBER, "cell": Vector2i(2, 2), "msg": "Timber found.", "reward": {"wood": 28}},
	{"id": "s1", "name": "Stone", "tex": D_STONE, "cell": Vector2i(21, 2), "msg": "Stone found.", "reward": {"iron": 3}},
	{"id": "h1", "name": "Hunt", "tex": D_HUNT, "cell": Vector2i(2, 21), "msg": "Tracks found.", "reward": {"food": 24}},
	{"id": "c1", "name": "Camp", "tex": D_CAMP, "cell": Vector2i(21, 21), "msg": "Camp found.", "reward": {"food": 12, "coal": 4}},
	{"id": "v1", "name": "Cave", "tex": D_CAVE, "cell": Vector2i(21, 12), "msg": "Cave found.", "reward": {"water": 26}},
	{"id": "o1", "name": "Post", "tex": D_OUT, "cell": Vector2i(2, 12), "msg": "Post marked.", "reward": {"morale": 4, "wood": 12}},
]

const RES := ["food", "wood", "water", "coal", "iron", "tools", "seed"]
const RES_C := {
	"food": Color("#e8a050"), "wood": Color("#a06840"), "water": Color("#48b0e0"),
	"coal": Color("#606070"), "iron": Color("#a8b4c0"), "tools": Color("#c8d0d8"), "seed": Color("#78b858"),
}
const RES_N := {
	"food": "Food", "wood": "Wood", "water": "Water", "coal": "Coal",
	"iron": "Iron", "tools": "Tools", "seed": "Seed",
}
const CARD_TINT := {
	"cabin": Color("#6a9fd4"), "woodlot": Color("#c4a05a"), "garden": Color("#7cbc6a"),
	"well": Color("#5ab0d0"), "hunter": Color("#d09050"), "workshop": Color("#8a8a98"),
	"kitchen": Color("#d08060"), "warehouse": Color("#9098a8"), "root_cellar": Color("#708898"),
	"smokehouse": Color("#b07850"), "coop": Color("#90b868"), "infirmary": Color("#e08090"),
	"watchtower": Color("#7080a0"),
}

var game: GameState
var scroll: ScrollContainer
var world: Control
var snow: Control
var fire: Control
var chrome: Control
var sfx: AudioStreamPlayer

var top_bar: PanelContainer
var res_lbl := {}
var day_lbl: Label
var heat_bar: ProgressBar
var fuel_bar: ProgressBar
var morale_bar: ProgressBar
var pause_btn: Button
var speed_btn: Button

var dock: PanelContainer
var tray: PanelContainer
var tray_scroll: ScrollContainer
var tray_row: HBoxContainer
var tray_visible := false

var sheet: PanelContainer
var sheet_dim: ColorRect
var sheet_title: Label
var sheet_sub: Label
var sheet_prev: TextureRect
var sheet_stats: Label
var sheet_hp: ProgressBar
var sheet_rd: ProgressBar
var sheet_crew: Label
var sheet_acts: HFlowContainer
var b_minus: Button
var b_plus: Button
var b_up: Button
var b_col: Button
var b_move: Button

var menu_dim: ColorRect
var menu: PanelContainer
var menu_title: Label
var menu_body: VBoxContainer
var menu_mode := ""

var toast: Label
var toast_t := 0.0
var mission_pill: PanelContainer
var mission_lbl: Label
var storm_pill: PanelContainer
var storm_lbl: Label
var fab: Button

var tiles: Array[ColorRect] = []
var tile_meta := {}
var b_btns := {}
var b_timers := {}
var b_bubbles := {}
var poi_btns: Array = []
var positions := {}
var place_layer: Control
var place_foot: Control
var place_prev: TextureRect

var selected := "cabin"
var placing := ""
var place_cell := Vector2i.ZERO
var move_mode := false
var sheet_on := false
var ui_ok := false
var drag := false
var drag_pt := Vector2.ZERO
var pulse := 0.0
var world_q := false
var acts_q := false
var ring_i := 0

var modal: CanvasLayer
var tut: PanelContainer
var tut_t: Label
var tut_b: Label
var choice: PanelContainer
var ch_t: Label
var ch_b: Label
var ch_row: VBoxContainer
var endp: PanelContainer
var end_t: Label
var end_b: Label

func _ready() -> void:
	randomize()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Cabin sits just above the fire (like Furnace Hall near the flame)
	positions = {"cabin": Vector2i(CX, CY - 3)}
	game = GS.new()
	_build()
	resized.connect(_layout)
	game.changed.connect(_refresh)
	game.choice_requested.connect(_on_choice)
	game.game_ended.connect(_on_end)
	game.tutorial_step.connect(_on_tut)
	game.resources_collected.connect(_on_got)
	game.storm_warning.connect(func(d, i): _toast("%s in %sd" % [i, d]))
	game.toast.connect(_toast)
	if game.has_save():
		game.set_paused(true)
		_toast("Welcome — More → Load")
	else:
		game.start_new_game()
	call_deferred("_center")
	call_deferred("_layout")
	_refresh()

func _process(d: float) -> void:
	if game == null:
		return
	game.tick(d)
	pulse += d
	if toast_t > 0.0:
		toast_t -= d
		if toast_t <= 0.0:
			toast.visible = false
	if fire and fire.has_method("set_heat"):
		fire.set_heat(game.heat / 100.0)
	if snow and snow.has_method("set_storm_intensity"):
		var f := 0.0
		if game.storm_active_days > 0:
			f = 0.85
		elif game.days_until_storm() <= 2:
			f = 0.4
		snow.set_storm_intensity(f)
	_pulse()
	# Live construction timers
	if game.project_in_progress():
		_refresh_timers()

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
				_sfx(SFX_C)
		KEY_1: game.set_time_scale(1.0); _sfx(SFX_C)
		KEY_2: game.set_time_scale(2.0); _sfx(SFX_C)
		KEY_3: game.set_time_scale(3.0); _sfx(SFX_C)
		KEY_C:
			if placing == "":
				_collect_all()
		KEY_ESCAPE:
			if placing != "":
				_cancel_place()
			elif move_mode:
				_cancel_move()
			elif sheet_on:
				_close_sheet()
			elif tray_visible:
				_hide_tray()
			elif menu_mode != "":
				_close_menu()
			get_viewport().set_input_as_handled()
		KEY_W, KEY_UP: _pan(0, -1, k.shift_pressed)
		KEY_S, KEY_DOWN: _pan(0, 1, k.shift_pressed)
		KEY_A, KEY_LEFT: _pan(-1, 0, k.shift_pressed)
		KEY_D, KEY_RIGHT: _pan(1, 0, k.shift_pressed)
		KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
			if placing != "":
				_commit(place_cell)
				get_viewport().set_input_as_handled()

func _pan(dx: int, dy: int, fast: bool) -> void:
	if scroll == null:
		return
	var s := 100 if fast else 56
	scroll.scroll_horizontal += dx * s
	scroll.scroll_vertical += dy * s
	get_viewport().set_input_as_handled()

# =============================================================================
# UI BUILD
# =============================================================================

func _build() -> void:
	add_theme_font_override("font", FONT)
	sfx = AudioStreamPlayer.new()
	sfx.volume_db = -7.0
	add_child(sfx)

	# Soft winter sky/ground backdrop
	var backdrop := ColorRect.new()
	backdrop.color = Color("#c8e4f0")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	var bg: Control = BG.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.modulate = Color(1, 1, 1, 0.55)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var map_host := Control.new()
	map_host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(map_host)

	scroll = ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll.gui_input.connect(_map_in)
	map_host.add_child(scroll)

	world = Control.new()
	world.custom_minimum_size = Vector2(COLS * TILE, ROWS * TILE)
	world.mouse_filter = Control.MOUSE_FILTER_STOP
	scroll.add_child(world)
	_rebuild_world()

	snow = SNOW.new()
	snow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	snow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_host.add_child(snow)

	chrome = Control.new()
	chrome.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	chrome.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chrome.z_index = 20
	add_child(chrome)

	_build_top()
	_build_pills()
	_build_dock()
	_build_tray()
	_build_fab()
	_build_sheet()
	_build_menu()
	_build_toast()
	_build_modals()
	ui_ok = true
	_layout()

func _build_top() -> void:
	top_bar = PanelContainer.new()
	top_bar.mouse_filter = Control.MOUSE_FILTER_STOP
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_bar.offset_left = 8
	top_bar.offset_top = 8
	top_bar.offset_right = -8
	top_bar.add_theme_stylebox_override("panel", _style(Color(0.97, 0.99, 1.0, 0.92), Color(0.55, 0.78, 0.92, 0.55), 16))
	chrome.add_child(top_bar)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 4)
	top_bar.add_child(col)

	var r1 := HBoxContainer.new()
	r1.add_theme_constant_override("separation", 6)
	col.add_child(r1)
	day_lbl = Label.new()
	day_lbl.add_theme_color_override("font_color", Color("#1a3a50"))
	day_lbl.add_theme_font_size_override("font_size", 13)
	day_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	day_lbl.custom_minimum_size = Vector2(120, 0)
	r1.add_child(day_lbl)
	heat_bar = _bar(Color("#f09040"), "Heat")
	r1.add_child(heat_bar)
	fuel_bar = _bar(Color("#c07030"), "Fuel")
	r1.add_child(fuel_bar)
	morale_bar = _bar(Color("#58c070"), "Morale")
	r1.add_child(morale_bar)
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r1.add_child(sp)
	pause_btn = _ico(I_PAUSE, func(): game.toggle_pause(); _sfx(SFX_C))
	r1.add_child(pause_btn)
	speed_btn = _ico(I_FF, func(): game.cycle_time_scale(); _sfx(SFX_C); _toast("×%s" % game.time_scale))
	r1.add_child(speed_btn)

	var r2 := HBoxContainer.new()
	r2.add_theme_constant_override("separation", 4)
	col.add_child(r2)
	for k in RES:
		var chip := PanelContainer.new()
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chip.custom_minimum_size = Vector2(0, 30)
		chip.add_theme_stylebox_override("panel", _style(Color(1, 1, 1, 0.95), RES_C[k], 10))
		r2.add_child(chip)
		var lb := Label.new()
		lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lb.add_theme_color_override("font_color", Color("#1a3040"))
		lb.add_theme_font_size_override("font_size", 12)
		chip.add_child(lb)
		res_lbl[k] = lb

func _build_pills() -> void:
	storm_pill = PanelContainer.new()
	storm_pill.visible = false
	storm_pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	storm_pill.anchor_left = 0.12
	storm_pill.anchor_right = 0.88
	storm_pill.add_theme_stylebox_override("panel", _style(Color(0.95, 0.35, 0.28, 0.95), Color("#ffd0c0"), 12))
	chrome.add_child(storm_pill)
	storm_lbl = Label.new()
	storm_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	storm_lbl.add_theme_color_override("font_color", Color.WHITE)
	storm_lbl.add_theme_font_size_override("font_size", 12)
	storm_pill.add_child(storm_lbl)

	mission_pill = PanelContainer.new()
	mission_pill.mouse_filter = Control.MOUSE_FILTER_STOP
	mission_pill.add_theme_stylebox_override("panel", _style(Color(1, 1, 1, 0.94), Color("#4eb0e0"), 12))
	mission_pill.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed:
			_open_menu("missions")
	)
	chrome.add_child(mission_pill)
	mission_lbl = Label.new()
	mission_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mission_lbl.add_theme_color_override("font_color", Color("#1a3a50"))
	mission_lbl.add_theme_font_size_override("font_size", 11)
	mission_pill.add_child(mission_lbl)

func _build_dock() -> void:
	dock = PanelContainer.new()
	dock.mouse_filter = Control.MOUSE_FILTER_STOP
	dock.anchor_left = 0.0
	dock.anchor_right = 1.0
	dock.anchor_top = 1.0
	dock.anchor_bottom = 1.0
	dock.add_theme_stylebox_override("panel", _style(Color(0.98, 0.99, 1.0, 0.96), Color(0.5, 0.75, 0.9, 0.45), 18))
	chrome.add_child(dock)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	dock.add_child(row)
	row.add_child(_dock("Build", I_PLUS, Color("#2a8fc4"), _toggle_tray))
	row.add_child(_dock("People", I_USER, Color("#3a7a9a"), func(): _open_menu("people")))
	row.add_child(_dock("Missions", I_STAR, Color("#2d8a6a"), func(): _open_menu("missions")))
	row.add_child(_dock("Collect", I_CHECK, Color("#2a9a58"), _collect_all))
	row.add_child(_dock("More", I_MENU, Color("#5a6a80"), func(): _open_menu("more")))

func _build_tray() -> void:
	# Whiteout-style horizontal building cards
	tray = PanelContainer.new()
	tray.visible = false
	tray.mouse_filter = Control.MOUSE_FILTER_STOP
	tray.anchor_left = 0.0
	tray.anchor_right = 1.0
	tray.anchor_top = 1.0
	tray.anchor_bottom = 1.0
	tray.add_theme_stylebox_override("panel", _style(Color(0.12, 0.22, 0.32, 0.55), Color(1, 1, 1, 0.15), 0))
	chrome.add_child(tray)

	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 4)
	tray.add_child(outer)

	var head := HBoxContainer.new()
	outer.add_child(head)
	var t := Label.new()
	t.text = "  BUILD"
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.add_theme_color_override("font_color", Color.WHITE)
	t.add_theme_font_size_override("font_size", 14)
	head.add_child(t)
	head.add_child(_ico(I_X, _hide_tray))

	tray_scroll = ScrollContainer.new()
	tray_scroll.custom_minimum_size = Vector2(0, 118)
	tray_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	tray_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	outer.add_child(tray_scroll)
	tray_row = HBoxContainer.new()
	tray_row.add_theme_constant_override("separation", 10)
	tray_scroll.add_child(tray_row)

func _build_fab() -> void:
	fab = Button.new()
	fab.text = "↓"
	fab.tooltip_text = "Collect all"
	fab.custom_minimum_size = Vector2(56, 56)
	fab.add_theme_font_size_override("font_size", 22)
	fab.add_theme_stylebox_override("normal", _style(Color(0.15, 0.65, 0.4, 0.95), Color("#b0ffd8"), 28))
	fab.add_theme_stylebox_override("hover", _style(Color(0.2, 0.75, 0.48, 0.98), Color.WHITE, 28))
	fab.add_theme_color_override("font_color", Color.WHITE)
	fab.pressed.connect(_collect_all)
	fab.anchor_left = 1.0
	fab.anchor_right = 1.0
	fab.anchor_top = 1.0
	fab.anchor_bottom = 1.0
	chrome.add_child(fab)

func _build_sheet() -> void:
	sheet_dim = ColorRect.new()
	sheet_dim.color = Color(0.05, 0.12, 0.18, 0.25)
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
	sheet.add_theme_stylebox_override("panel", _style(Color(0.98, 0.99, 1.0, 0.98), Color(0.5, 0.78, 0.95, 0.5), 20))
	chrome.add_child(sheet)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	sheet.add_child(box)
	var handle := ColorRect.new()
	handle.color = Color(0.6, 0.72, 0.8, 0.5)
	handle.custom_minimum_size = Vector2(44, 4)
	handle.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	box.add_child(handle)

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	box.add_child(head)
	sheet_prev = TextureRect.new()
	sheet_prev.custom_minimum_size = Vector2(64, 56)
	sheet_prev.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sheet_prev.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sheet_prev.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	head.add_child(sheet_prev)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(titles)
	sheet_title = Label.new()
	sheet_title.add_theme_color_override("font_color", Color("#153247"))
	sheet_title.add_theme_font_size_override("font_size", 18)
	titles.add_child(sheet_title)
	sheet_sub = Label.new()
	sheet_sub.add_theme_color_override("font_color", Color("#4a6a80"))
	sheet_sub.add_theme_font_size_override("font_size", 12)
	titles.add_child(sheet_sub)
	b_col = _btn("Collect", I_CHECK, Color("#2a9a58"), _collect_sel)
	b_col.custom_minimum_size = Vector2(100, 42)
	head.add_child(b_col)
	head.add_child(_ico(I_X, _close_sheet))

	sheet_stats = Label.new()
	sheet_stats.add_theme_color_override("font_color", Color("#2a4a5c"))
	sheet_stats.add_theme_font_size_override("font_size", 11)
	sheet_stats.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(sheet_stats)

	var meters := HBoxContainer.new()
	meters.add_theme_constant_override("separation", 8)
	box.add_child(meters)
	sheet_hp = _bar(Color("#50c0b8"), "HP")
	meters.add_child(sheet_hp)
	sheet_rd = _bar(Color("#50a8e8"), "Ready")
	meters.add_child(sheet_rd)

	var crew := HBoxContainer.new()
	crew.add_theme_constant_override("separation", 8)
	box.add_child(crew)
	var cl := Label.new()
	cl.text = "Crew"
	cl.add_theme_color_override("font_color", Color("#153247"))
	cl.add_theme_font_size_override("font_size", 13)
	crew.add_child(cl)
	b_minus = _ico(I_MINUS, func(): game.assign_worker(selected, -1); _sfx(SFX_B))
	crew.add_child(b_minus)
	sheet_crew = Label.new()
	sheet_crew.custom_minimum_size = Vector2(52, 0)
	sheet_crew.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sheet_crew.add_theme_color_override("font_color", Color("#153247"))
	sheet_crew.add_theme_font_size_override("font_size", 14)
	crew.add_child(sheet_crew)
	b_plus = _ico(I_PLUS, func(): game.assign_worker(selected, 1); _sfx(SFX_B))
	crew.add_child(b_plus)
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crew.add_child(sp)
	b_up = _btn("Upgrade", I_WRENCH, Color("#c07820"), func(): game.upgrade(selected); _sfx(SFX_A))
	b_up.custom_minimum_size = Vector2(108, 40)
	crew.add_child(b_up)
	b_move = _btn("Move", I_TARGET, Color("#6a5a9b"), _toggle_move)
	b_move.custom_minimum_size = Vector2(88, 40)
	crew.add_child(b_move)

	var sc := ScrollContainer.new()
	sc.custom_minimum_size = Vector2(0, 80)
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(sc)
	sheet_acts = HFlowContainer.new()
	sheet_acts.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sheet_acts.add_theme_constant_override("separation", 6)
	sheet_acts.add_theme_constant_override("v_separation", 6)
	sc.add_child(sheet_acts)

func _build_menu() -> void:
	menu_dim = ColorRect.new()
	menu_dim.color = Color(0.08, 0.16, 0.24, 0.45)
	menu_dim.visible = false
	menu_dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	menu_dim.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed:
			_close_menu()
	)
	chrome.add_child(menu_dim)
	menu = PanelContainer.new()
	menu.visible = false
	menu.mouse_filter = Control.MOUSE_FILTER_STOP
	menu.clip_contents = true
	menu.anchor_left = 0.0
	menu.anchor_right = 1.0
	menu.anchor_top = 0.0
	menu.anchor_bottom = 1.0
	menu.add_theme_stylebox_override("panel", _style(Color(0.98, 0.99, 1.0, 0.99), Color(0.7, 0.85, 0.95, 0.6), 18))
	chrome.add_child(menu)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	menu.add_child(box)
	var head := HBoxContainer.new()
	box.add_child(head)
	menu_title = Label.new()
	menu_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_title.add_theme_color_override("font_color", Color("#153247"))
	menu_title.add_theme_font_size_override("font_size", 20)
	head.add_child(menu_title)
	head.add_child(_ico(I_X, _close_menu))
	var sc := ScrollContainer.new()
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(sc)
	menu_body = VBoxContainer.new()
	menu_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_body.add_theme_constant_override("separation", 8)
	sc.add_child(menu_body)

func _build_toast() -> void:
	toast = Label.new()
	toast.visible = false
	toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast.z_index = 50
	toast.anchor_left = 0.15
	toast.anchor_right = 0.85
	toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast.add_theme_color_override("font_color", Color("#153247"))
	toast.add_theme_font_size_override("font_size", 13)
	toast.add_theme_stylebox_override("normal", _style(Color(1, 1, 1, 0.95), Color("#7ad0a0"), 12))
	chrome.add_child(toast)

func _build_modals() -> void:
	modal = CanvasLayer.new()
	modal.layer = 60
	add_child(modal)
	tut = _modal()
	var tb: VBoxContainer = tut.get_meta("box")
	tut_t = _lab(22, Color("#153247"))
	tb.add_child(tut_t)
	tut_b = _lab(15, Color("#2a4a5c"))
	tut_b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tb.add_child(tut_b)
	var tr := HBoxContainer.new()
	tr.add_theme_constant_override("separation", 10)
	tb.add_child(tr)
	tr.add_child(_btn("Skip", I_MINUS, Color("#708090"), func(): tut.visible = false; game.skip_tutorial(); _sfx(SFX_C)))
	tr.add_child(_btn("Next", I_PLUS, Color("#2a8fc4"), func(): tut.visible = false; game.advance_tutorial(); _sfx(SFX_A)))
	modal.add_child(tut)

	choice = _modal()
	var cb: VBoxContainer = choice.get_meta("box")
	ch_t = _lab(22, Color("#153247"))
	cb.add_child(ch_t)
	ch_b = _lab(15, Color("#2a4a5c"))
	ch_b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cb.add_child(ch_b)
	ch_row = VBoxContainer.new()
	ch_row.add_theme_constant_override("separation", 8)
	cb.add_child(ch_row)
	modal.add_child(choice)

	endp = _modal()
	var eb: VBoxContainer = endp.get_meta("box")
	end_t = _lab(24, Color("#153247"))
	eb.add_child(end_t)
	end_b = _lab(15, Color("#2a4a5c"))
	end_b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	eb.add_child(end_b)
	eb.add_child(_btn("New Settlement", I_PLUS, Color("#2a8fc4"), _new_game))
	modal.add_child(endp)

# =============================================================================
# WORLD — pure snow + ring camp + fire
# =============================================================================

func _rebuild_world() -> void:
	for c in world.get_children():
		c.queue_free()
	tiles.clear()
	tile_meta.clear()
	b_btns.clear()
	b_timers.clear()
	b_bubbles.clear()
	poi_btns.clear()
	fire = null
	place_layer = null
	place_foot = null
	place_prev = null

	# Pure white snow field (Whiteout look)
	for y in ROWS:
		for x in COLS:
			var cell := Vector2i(x, y)
			var rect := ColorRect.new()
			rect.position = Vector2(x * TILE, y * TILE)
			rect.size = Vector2(TILE + 1, TILE + 1)
			# Soft variation
			var n := float((x * 17 + y * 31) % 7) / 7.0
			rect.color = Color(0.93 + n * 0.05, 0.96 + n * 0.03, 0.99, 1.0)
			# Soft clearing around fire
			var dx := x - CX
			var dy := y - CY
			var dist := sqrt(float(dx * dx + dy * dy))
			if dist < 2.2:
				rect.color = Color(0.90, 0.94, 0.97, 1.0)
			rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			rect.gui_input.connect(_tile_input.bind(cell))
			rect.set_meta("cell", cell)
			rect.set_meta("base", rect.color)
			tiles.append(rect)
			tile_meta[cell] = rect
			world.add_child(rect)

	# Sparse edge trees
	for p in [Vector2i(1, 1), Vector2i(3, 0), Vector2i(20, 1), Vector2i(22, 3), Vector2i(0, 20), Vector2i(2, 22), Vector2i(21, 22), Vector2i(23, 19)]:
		var tree := TextureRect.new()
		tree.texture = T_PINE
		tree.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tree.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tree.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		tree.custom_minimum_size = Vector2(48, 56)
		tree.size = Vector2(48, 56)
		tree.position = Vector2(p.x * TILE + 4, p.y * TILE - 8)
		tree.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tree.modulate = Color(0.95, 0.98, 1.0, 0.9)
		tree.z_index = 1
		world.add_child(tree)

	# Central campfire (Whiteout heart)
	fire = FIRE.new()
	fire.custom_minimum_size = Vector2(110, 110)
	fire.size = Vector2(110, 110)
	fire.position = Vector2(CX * TILE + TILE * 0.5 - 55, CY * TILE + TILE * 0.5 - 55)
	fire.z_index = 4
	fire.mouse_filter = Control.MOUSE_FILTER_STOP
	fire.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and not _placing():
			_open_sheet("cabin")
	)
	world.add_child(fire)

	# Heat label under fire
	var fl := Label.new()
	fl.name = "FireLabel"
	fl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fl.position = Vector2(CX * TILE + TILE * 0.5 - 50, CY * TILE + TILE * 0.5 + 48)
	fl.custom_minimum_size = Vector2(100, 20)
	fl.add_theme_color_override("font_color", Color("#8a4030"))
	fl.add_theme_font_size_override("font_size", 11)
	fl.add_theme_stylebox_override("normal", _style(Color(1, 1, 1, 0.85), Color("#f0a060"), 8))
	fl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fl.z_index = 5
	world.add_child(fl)

	for p in POIS:
		_add_poi(p)
	for id in positions.keys():
		if game.has_building(id):
			_add_bld(id)
	_add_place_layer()

func _tile_input(ev: InputEvent, cell: Vector2i) -> void:
	if not _placing():
		return
	if ev is InputEventMouseButton:
		var mb := ev as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_commit(cell)
	elif ev is InputEventMouseMotion:
		_preview_cell(cell)

func _add_poi(p: Dictionary) -> void:
	var cell: Vector2i = p["cell"]
	var tex: Texture2D = p["tex"]
	var sz := _cap(tex, 0.34, PMAX)
	var c := Vector2(cell.x * TILE + TILE * 0.5, cell.y * TILE + TILE * 0.5)
	var b := TextureButton.new()
	b.position = c - sz * 0.5
	b.custom_minimum_size = sz
	b.size = sz
	b.ignore_texture_size = true
	b.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	b.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	b.texture_normal = tex
	b.z_index = 2
	b.tooltip_text = p["name"]
	b.pressed.connect(func():
		if _placing():
			return
		_sfx(SFX_A)
		game.scout_site(p["id"], p["reward"], p["msg"])
	)
	poi_btns.append(b)
	world.add_child(b)

func _add_bld(id: String) -> void:
	var tex := _spr(id)
	var lvl := int(game.buildings[id]["level"])
	var sz := _cap(tex, 0.38 + mini(lvl - 1, 2) * 0.04, BMAX)
	var plot: Vector2i = positions[id]
	var c := Vector2(plot.x * TILE + TILE * 0.5, plot.y * TILE + TILE * 0.5)

	# Soft shadow disc
	var sh := ColorRect.new()
	sh.color = Color(0.55, 0.65, 0.75, 0.22)
	sh.size = Vector2(sz.x * 0.7, sz.y * 0.22)
	sh.position = c + Vector2(-sz.x * 0.35, sz.y * 0.28)
	sh.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sh.z_index = 2
	world.add_child(sh)

	var b := TextureButton.new()
	b.position = c - sz * 0.5
	b.custom_minimum_size = sz
	b.size = sz
	b.ignore_texture_size = true
	b.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	b.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	b.texture_normal = tex
	b.z_index = 3
	b.tooltip_text = game.buildings[id]["name"]
	b.pressed.connect(_tap.bind(id))
	b_btns[id] = b
	world.add_child(b)

	# Construction timer bubble (Whiteout style)
	var timer := Label.new()
	timer.visible = false
	timer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	timer.add_theme_color_override("font_color", Color.WHITE)
	timer.add_theme_font_size_override("font_size", 12)
	timer.add_theme_stylebox_override("normal", _style(Color(0.15, 0.35, 0.55, 0.92), Color("#80d0ff"), 12))
	timer.z_index = 8
	timer.position = c + Vector2(-40, -sz.y * 0.55)
	timer.custom_minimum_size = Vector2(80, 24)
	b_timers[id] = timer
	world.add_child(timer)

	# Collect bubble
	var bub := Button.new()
	bub.visible = false
	bub.focus_mode = Control.FOCUS_NONE
	bub.text = "+"
	bub.position = c + Vector2(sz.x * 0.2, -sz.y * 0.45)
	bub.custom_minimum_size = Vector2(44, 30)
	bub.add_theme_font_size_override("font_size", 14)
	bub.add_theme_stylebox_override("normal", _style(Color(0.2, 0.7, 0.4, 0.96), Color.WHITE, 15))
	bub.add_theme_stylebox_override("hover", _style(Color(0.25, 0.8, 0.48, 0.98), Color.WHITE, 15))
	bub.add_theme_color_override("font_color", Color.WHITE)
	bub.z_index = 9
	bub.pressed.connect(_collect_b.bind(id))
	b_bubbles[id] = bub
	world.add_child(bub)

func _add_place_layer() -> void:
	place_layer = Control.new()
	place_layer.custom_minimum_size = Vector2(COLS * TILE, ROWS * TILE)
	place_layer.size = place_layer.custom_minimum_size
	place_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place_layer.visible = false
	place_layer.z_index = 10
	world.add_child(place_layer)

	# Green Whiteout footprint (2x2 tiles)
	place_foot = Control.new()
	place_foot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place_foot.z_index = 10
	place_layer.add_child(place_foot)
	place_foot.set_script(null)
	# Draw via ColorRects
	for i in 4:
		var g := ColorRect.new()
		g.color = Color(0.35, 0.9, 0.45, 0.45)
		g.size = Vector2(TILE - 4, TILE - 4)
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		place_foot.add_child(g)

	place_prev = TextureRect.new()
	place_prev.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	place_prev.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	place_prev.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	place_prev.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place_prev.modulate = Color(1, 1, 1, 0.85)
	place_prev.z_index = 11
	place_layer.add_child(place_prev)

# =============================================================================
# LAYOUT
# =============================================================================

func _layout() -> void:
	if not ui_ok:
		return
	top_bar.offset_left = 8
	top_bar.offset_top = 8
	top_bar.offset_right = -8
	top_bar.reset_size()
	var th := maxf(top_bar.get_combined_minimum_size().y, 72.0)
	top_bar.offset_bottom = 8 + th
	var y := 12 + th

	if storm_pill.visible:
		storm_pill.offset_top = y
		storm_pill.offset_bottom = y + 28
		y += 32
	mission_pill.offset_left = 10
	mission_pill.offset_right = 230
	mission_pill.offset_top = y
	mission_pill.offset_bottom = y + 42
	toast.offset_top = y + 48
	toast.offset_bottom = y + 78

	var bottom := DOCK_H + 6
	if tray_visible:
		bottom += TRAY_H
	dock.offset_left = 8
	dock.offset_right = -8
	dock.offset_top = -DOCK_H
	dock.offset_bottom = -6

	tray.offset_left = 0
	tray.offset_right = 0
	tray.offset_top = -(DOCK_H + TRAY_H)
	tray.offset_bottom = -DOCK_H

	fab.offset_left = -72
	fab.offset_right = -12
	fab.offset_top = -(bottom + 64)
	fab.offset_bottom = -(bottom + 8)

	var sh := 280.0
	sheet.offset_left = 8
	sheet.offset_right = -8
	sheet.offset_top = -(sh + bottom)
	sheet.offset_bottom = -bottom

	menu.offset_left = 10
	menu.offset_right = -10
	menu.offset_top = 12 + th
	menu.offset_bottom = -(bottom + 4)

# =============================================================================
# REFRESH
# =============================================================================

func _refresh() -> void:
	if not ui_ok or game == null:
		return
	_sync_pos()
	_ensure_sel()

	day_lbl.text = "Day %s  %s" % [game.day, game.season.replace(" Winter", "")]
	heat_bar.value = game.heat
	fuel_bar.value = game.furnace_fuel
	morale_bar.value = game.morale
	pause_btn.modulate = Color(1.3, 1.1, 0.7) if game.paused else Color.WHITE

	for k in RES:
		var n := int(game.resources.get(k, 0))
		var cap := int(game.storage_capacity(k))
		res_lbl[k].text = "%s %s" % [RES_N[k].substr(0, 1), n]
		res_lbl[k].tooltip_text = "%s %s/%s" % [RES_N[k], n, cap]
		var low := n < maxi(1, int(cap * 0.18))
		res_lbl[k].get_parent().add_theme_stylebox_override("panel", _style(
			Color(1.0, 0.88, 0.82, 0.95) if low else Color(1, 1, 1, 0.95), RES_C[k], 10
		))

	var fl := world.get_node_or_null("FireLabel")
	if fl:
		fl.text = "  🔥 %s°  " % int(game.heat)

	var ds := game.days_until_storm()
	if game.storm_active_days > 0:
		storm_pill.visible = true
		storm_lbl.text = "WHITEOUT — feed the fire!"
	elif ds >= 0 and ds <= 2:
		storm_pill.visible = true
		storm_lbl.text = "%s in %s day(s)" % [game.storm_intensity.to_upper(), ds]
	else:
		storm_pill.visible = false

	var ms := game.active_missions()
	if ms.is_empty():
		mission_lbl.text = "Ch.%s clear\nPower %s" % [game.current_chapter, game.settlement_power()]
	else:
		mission_lbl.text = "▶ %s\n%s" % [ms[0]["title"], ms[0]["progress"]]

	fab.visible = game.has_any_bubbles() and menu_mode == "" and not sheet_on and not tray_visible

	_refresh_timers()
	for id in b_btns.keys():
		if not game.has_building(id):
			continue
		var bb: Dictionary = game.buildings[id]
		var btn: TextureButton = b_btns[id]
		btn.texture_normal = _spr(id)
		var bn := game.bubble_total(id)
		if b_bubbles.has(id):
			var bub: Button = b_bubbles[id]
			bub.visible = bn >= 1.0 and not bool(bb.get("under_construction", false))
			if bub.visible:
				bub.text = "+%s" % int(bn)
		var sel: bool = id == selected and sheet_on
		if float(bb["condition"]) < 30.0:
			btn.modulate = Color(1.15, 0.85, 0.8)
		elif sel:
			btn.modulate = Color(1.25, 1.25, 1.25)
		else:
			btn.modulate = Color.WHITE

	for i in poi_btns.size():
		if i >= POIS.size():
			break
		var p: Dictionary = POIS[i]
		var b: TextureButton = poi_btns[i]
		b.modulate = Color(0.55, 0.6, 0.65, 0.45) if game.scouted_sites.has(p["id"]) else Color.WHITE

	if sheet_on and game.has_building(selected):
		_refresh_sheet()
	if tray_visible:
		_fill_tray()
	if menu_mode != "":
		_fill_menu()
	_layout()

func _refresh_timers() -> void:
	for id in b_timers.keys():
		var t: Label = b_timers[id]
		if not is_instance_valid(t):
			continue
		var under := game.has_building(id) and bool(game.buildings[id].get("under_construction", false))
		var upg: bool = str(game.active_project.get("building_id", "")) == id
		if (under or upg) and game.project_in_progress():
			var sec := ceili(float(game.active_project.get("remaining", 0)))
			var m := int(sec / 60)
			var s := sec % 60
			t.text = "  %d:%02d  " % [m, s] if m > 0 else "  %ss  " % sec
			t.visible = true
		else:
			t.visible = false

func _refresh_sheet() -> void:
	var b: Dictionary = game.buildings[selected]
	sheet_prev.texture = _spr(selected)
	sheet_title.text = String(b["name"])
	sheet_sub.text = "Lv.%s · %s · Idle %s" % [b["level"], game.building_status_text(selected), game.available_workers]
	var d := game.building_details(selected)
	sheet_stats.text = "%s\n%s · %s" % [d["role"], d["output"], _fmt_prod(game.production_preview(selected))]
	sheet_hp.value = float(b["condition"])
	sheet_rd.value = float(b["readiness"])
	sheet_crew.text = "%s/%s" % [b["workers"], b["max_workers"]]
	var op := game.is_building_operational(selected)
	b_plus.disabled = game.game_over or not op or game.available_workers <= 0 or int(b["workers"]) >= int(b["max_workers"])
	b_minus.disabled = game.game_over or not op or int(b["workers"]) <= 0
	var bn := game.bubble_total(selected)
	b_col.disabled = bn < 1.0
	b_col.text = "Collect" if bn < 1.0 else "Take %.0f" % bn
	b_up.disabled = not game.can_upgrade(selected)
	b_up.tooltip_text = _fmt_cost(game.upgrade_cost(selected))
	b_move.disabled = game.game_over or not op
	b_move.text = "Moving" if move_mode else "Move"
	if acts_q:
		return
	acts_q = true
	call_deferred("_rebuild_acts")

func _rebuild_acts() -> void:
	acts_q = false
	for c in sheet_acts.get_children():
		c.queue_free()
	if not game.is_building_operational(selected):
		var b := _btn(game.building_status_text(selected), I_WARN, Color("#708090"), func(): pass)
		b.disabled = true
		sheet_acts.add_child(b)
		return
	for a in game.building_actions(selected):
		var aid: String = a["id"]
		var btn := _btn(a["name"], I_TARGET, Color("#2a7aa8"), func():
			_sfx(SFX_A)
			game.perform_building_action(selected, aid)
		)
		btn.custom_minimum_size = Vector2(118, 38)
		btn.add_theme_font_size_override("font_size", 11)
		btn.disabled = game.game_over or not game.can_perform_building_action(selected, aid)
		btn.tooltip_text = "%s · %s" % [a["cost"], a["effect"]]
		sheet_acts.add_child(btn)

# =============================================================================
# BUILD TRAY (Whiteout cards)
# =============================================================================

func _toggle_tray() -> void:
	_sfx(SFX_C)
	if tray_visible:
		_hide_tray()
	else:
		_close_menu()
		_close_sheet()
		tray_visible = true
		tray.visible = true
		_fill_tray()
		_layout()

func _hide_tray() -> void:
	tray_visible = false
	tray.visible = false
	if placing != "":
		_cancel_place()
	_layout()

func _fill_tray() -> void:
	for c in tray_row.get_children():
		c.queue_free()
	for id in game.building_ids():
		tray_row.add_child(_build_card(id))

func _build_card(id: String) -> Control:
	var tint: Color = CARD_TINT.get(id, Color("#6a9fd4"))
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(118, 108)
	card.add_theme_stylebox_override("panel", _style(Color(1, 1, 1, 0.97), tint, 14))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	card.add_child(box)

	var icon := TextureRect.new()
	icon.texture = _blueprint(id)
	icon.custom_minimum_size = Vector2(72, 48)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	box.add_child(icon)

	var name := Label.new()
	name.text = game.building_name(id)
	name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name.add_theme_color_override("font_color", Color("#153247"))
	name.add_theme_font_size_override("font_size", 11)
	name.clip_text = true
	box.add_child(name)

	if game.has_building(id):
		var st := Label.new()
		st.text = "Built L%s" % game.buildings[id]["level"]
		st.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		st.add_theme_color_override("font_color", Color("#2a7a50"))
		st.add_theme_font_size_override("font_size", 10)
		box.add_child(st)
		var open := Button.new()
		open.text = "Open"
		open.custom_minimum_size = Vector2(0, 28)
		open.add_theme_font_size_override("font_size", 11)
		open.add_theme_stylebox_override("normal", _style(tint, Color.WHITE, 8))
		open.add_theme_color_override("font_color", Color.WHITE)
		open.pressed.connect(func():
			_hide_tray()
			_open_sheet(id)
		)
		box.add_child(open)
	else:
		var cost := game.build_cost(id)
		var cl := Label.new()
		cl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cl.add_theme_color_override("font_color", Color("#4a6070"))
		cl.add_theme_font_size_override("font_size", 10)
		var parts: Array[String] = []
		for k in ["wood", "coal", "tools", "iron", "seed"]:
			if cost.has(k) and int(cost[k]) > 0:
				parts.append("%s" % int(cost[k]))
		cl.text = " ".join(parts) if not parts.is_empty() else game.building_status_text(id)
		box.add_child(cl)
		var place := Button.new()
		place.text = "Build" if game.can_build(id) else ("Locked" if not game.is_building_unlocked(id) else "Need res")
		place.custom_minimum_size = Vector2(0, 28)
		place.add_theme_font_size_override("font_size", 11)
		place.disabled = not game.can_build(id)
		place.add_theme_stylebox_override("normal", _style(tint if game.can_build(id) else Color("#8090a0"), Color.WHITE, 8))
		place.add_theme_stylebox_override("disabled", _style(Color("#90a0b0"), Color(1, 1, 1, 0.3), 8))
		place.add_theme_color_override("font_color", Color.WHITE)
		place.pressed.connect(func(): _begin_place(id))
		box.add_child(place)
	return card

# =============================================================================
# INTERACTION
# =============================================================================

func _tap(id: String) -> void:
	_sfx(SFX_B)
	if game.bubble_total(id) >= 1.0 and selected == id and sheet_on:
		_collect_b(id)
		return
	_hide_tray()
	_open_sheet(id)

func _open_sheet(id: String) -> void:
	if not game.has_building(id):
		return
	selected = id
	sheet_on = true
	sheet.visible = true
	sheet_dim.visible = true
	fab.visible = false
	_refresh_sheet()
	_layout()

func _close_sheet() -> void:
	sheet_on = false
	sheet.visible = false
	sheet_dim.visible = false
	if move_mode:
		_cancel_move()
	_layout()
	_refresh()

func _collect_b(id: String) -> void:
	_sfx(SFX_D)
	var g := game.collect_from_building(id)
	if g.is_empty():
		return
	_fx(id, g)

func _collect_sel() -> void:
	_collect_b(selected)

func _collect_all() -> void:
	_sfx(SFX_D)
	var g := game.collect_all()
	if g.is_empty():
		_toast("Nothing to collect")
		return
	var parts: Array[String] = []
	for k in g.keys():
		parts.append("+%s %s" % [int(g[k]), k])
	_toast(", ".join(parts))

func _on_got(id: String, amounts: Dictionary) -> void:
	_fx(id, amounts)

func _fx(id: String, amounts: Dictionary) -> void:
	if not b_btns.has(id):
		return
	var b: Control = b_btns[id]
	var pos := b.get_global_position() + b.size * 0.5
	var y := 0.0
	for k in amounts.keys():
		FLOAT.spawn(self, pos + Vector2(0, y), "+%s %s" % [int(amounts[k]), k], RES_C.get(str(k), Color("#2a8a50")))
		y -= 16.0

func _begin_place(id: String) -> void:
	if game.has_building(id):
		_hide_tray()
		_open_sheet(id)
		return
	if not game.can_build(id):
		_toast("Can't build yet")
		return
	_sfx(SFX_C)
	move_mode = false
	placing = id
	place_cell = _find_spot()
	_set_place(true)
	_preview_cell(place_cell)
	_toast("Drag green footprint · tap to place")

func _cancel_place() -> void:
	placing = ""
	_set_place(false)

func _toggle_move() -> void:
	_sfx(SFX_C)
	placing = ""
	move_mode = not move_mode
	_set_place(move_mode)
	_toast("Tap snow to relocate" if move_mode else "Move canceled")

func _cancel_move() -> void:
	move_mode = false
	_set_place(false)

func _commit(cell: Vector2i) -> void:
	if placing != "":
		if _blocked(cell) or _close(cell):
			_toast("Need clear snow")
			return
		var id := placing
		if game.build(id):
			positions[id] = cell
			selected = id
			_queue_world()
			_toast("%s building…" % game.building_name(id))
			call_deferred("_open_sheet", id)
		placing = ""
		_set_place(false)
		return
	if move_mode:
		var saved: Vector2i = positions.get(selected, cell)
		positions.erase(selected)
		if _blocked(cell) or _close(cell):
			positions[selected] = saved
			_toast("Need clear snow")
			return
		positions[selected] = cell
		move_mode = false
		_set_place(false)
		_queue_world()
		_toast("Moved")

func _set_place(on: bool) -> void:
	if place_layer:
		place_layer.visible = on
	for t in tiles:
		if not is_instance_valid(t):
			continue
		var cell: Vector2i = t.get_meta("cell")
		var base: Color = t.get_meta("base")
		# Only capture taps while placing so map drag still works
		t.mouse_filter = Control.MOUSE_FILTER_STOP if on else Control.MOUSE_FILTER_IGNORE
		if on:
			var bad := false
			if move_mode:
				bad = _blocked_except(cell, selected) or _close_except(cell, selected)
				if positions.get(selected, Vector2i(-1, -1)) == cell:
					bad = false
			else:
				bad = _blocked(cell) or _close(cell)
			# Whiteout green grid
			if bad:
				t.color = Color(1.0, 0.45, 0.4, 0.55)
			else:
				t.color = Color(0.35, 0.92, 0.5, 0.55)
		else:
			t.color = base
	for p in poi_btns:
		if is_instance_valid(p):
			p.mouse_filter = Control.MOUSE_FILTER_IGNORE if on else Control.MOUSE_FILTER_STOP

func _preview_cell(cell: Vector2i) -> void:
	place_cell = cell
	if place_foot == null:
		return
	# 2x2 green footprint centered on cell
	var origin := Vector2(cell.x * TILE + 2, cell.y * TILE + 2)
	var i := 0
	for child in place_foot.get_children():
		if child is ColorRect:
			var ox := i % 2
			var oy := int(i / 2)
			child.position = origin + Vector2(ox * TILE, oy * TILE)
			var bad := _blocked(cell + Vector2i(ox, oy)) if placing != "" else false
			child.color = Color(1.0, 0.4, 0.35, 0.5) if bad else Color(0.3, 0.95, 0.45, 0.55)
			i += 1
	if place_prev and placing != "":
		var tex := _blueprint(placing)
		var sz := _cap(tex, 0.38, BMAX)
		place_prev.texture = tex
		place_prev.custom_minimum_size = sz
		place_prev.size = sz
		place_prev.position = Vector2(cell.x * TILE + TILE - sz.x * 0.5, cell.y * TILE + TILE - sz.y * 0.5)
		place_prev.visible = true
		var bad2 := _blocked(cell) or _close(cell)
		place_prev.modulate = Color(1, 0.5, 0.45, 0.75) if bad2 else Color(1, 1, 1, 0.9)

func _placing() -> bool:
	return placing != "" or move_mode

func _blocked(cell: Vector2i) -> bool:
	return _blocked_except(cell, "")

func _blocked_except(cell: Vector2i, except: String) -> bool:
	if cell == Vector2i(CX, CY) or cell == Vector2i(CX, CY - 1):
		return true # protect fire pit
	for id in positions.keys():
		if except != "" and id == except:
			continue
		if positions[id] == cell:
			return true
	for p in POIS:
		if p["cell"] == cell:
			return true
	return false

func _close(cell: Vector2i) -> bool:
	return _close_except(cell, "" if placing != "" else selected)

func _close_except(cell: Vector2i, except: String) -> bool:
	for id in positions.keys():
		if except != "" and id == except:
			continue
		var o: Vector2i = positions[id]
		if absi(o.x - cell.x) < GAP and absi(o.y - cell.y) < GAP:
			return true
	return false

func _find_spot() -> Vector2i:
	# Prefer ring slots like Whiteout camp
	for slot in RING:
		if not _blocked(slot) and not _close(slot):
			return slot
	var origin := Vector2i(CX, CY)
	for r in range(GAP, 10):
		for dy in range(-r, r + 1):
			for dx in range(-r, r + 1):
				var c := Vector2i(origin.x + dx, origin.y + dy)
				if c.x > 1 and c.y > 1 and c.x < COLS - 2 and c.y < ROWS - 2:
					if not _blocked(c) and not _close(c):
						return c
	return Vector2i(CX + 3, CY)

func _sync_pos() -> void:
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
		if not b_btns.has(id):
			miss = true
	if miss:
		_queue_world()

func _queue_world() -> void:
	if world_q:
		return
	world_q = true
	call_deferred("_do_world")

func _do_world() -> void:
	world_q = false
	_rebuild_world()
	_refresh()

func _ensure_sel() -> void:
	if game.has_building(selected):
		return
	for id in game.building_ids():
		if game.has_building(id):
			selected = id
			return

func _center() -> void:
	await get_tree().process_frame
	if scroll == null:
		return
	scroll.scroll_horizontal = maxi(0, int(CX * TILE - scroll.size.x * 0.5))
	scroll.scroll_vertical = maxi(0, int(CY * TILE - scroll.size.y * 0.42))

func _map_in(ev: InputEvent) -> void:
	if _placing():
		return
	if ev is InputEventMouseButton:
		var mb := ev as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			drag = mb.pressed
			drag_pt = mb.position
		elif mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			scroll.scroll_vertical -= 56
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scroll.scroll_vertical += 56
	elif ev is InputEventMouseMotion and drag:
		var mm := ev as InputEventMouseMotion
		var d: Vector2 = drag_pt - mm.position
		scroll.scroll_horizontal += int(d.x)
		scroll.scroll_vertical += int(d.y)
		drag_pt = mm.position
	elif ev is InputEventScreenDrag:
		var sd := ev as InputEventScreenDrag
		scroll.scroll_horizontal -= int(sd.relative.x)
		scroll.scroll_vertical -= int(sd.relative.y)

func _pulse() -> void:
	var s := 1.0 + sin(pulse * 4.0) * 0.08
	for id in b_bubbles.keys():
		var b: Button = b_bubbles[id]
		if is_instance_valid(b) and b.visible:
			b.scale = Vector2(s, s)

# =============================================================================
# MENUS
# =============================================================================

func _open_menu(mode: String) -> void:
	_sfx(SFX_C)
	_hide_tray()
	_close_sheet()
	if menu_mode == mode:
		_close_menu()
		return
	menu_mode = mode
	menu_dim.visible = true
	menu.visible = true
	fab.visible = false
	_fill_menu()
	_layout()

func _close_menu() -> void:
	menu_mode = ""
	menu_dim.visible = false
	menu.visible = false
	_layout()
	_refresh()

func _fill_menu() -> void:
	for c in menu_body.get_children():
		c.queue_free()
	match menu_mode:
		"people":
			menu_title.text = "Survivors"
			var s := Label.new()
			s.text = "Idle %s · Sick %s · Total %s" % [game.idle_survivor_count(), game.sick_survivor_count(), game.homesteaders]
			s.add_theme_color_override("font_color", Color("#153247"))
			menu_body.add_child(s)
			for p in game.survivor_list():
				menu_body.add_child(_person(p))
		"missions":
			menu_title.text = "Missions"
			for g in game.survival_goals():
				menu_body.add_child(_goal(g))
			var h := Label.new()
			h.text = "Log"
			h.add_theme_color_override("font_color", Color("#153247"))
			h.add_theme_font_size_override("font_size", 15)
			menu_body.add_child(h)
			for i in mini(8, game.event_log.size()):
				menu_body.add_child(_log(game.event_log[i]))
		"more":
			menu_title.text = "Command"
			menu_body.add_child(_btn("Save City", I_SAVE, Color("#2d7a5a"), _save))
			menu_body.add_child(_btn("Load City", I_HOME, Color("#3a6a8a"), _load))
			menu_body.add_child(_btn("New Game", I_PLUS, Color("#a05040"), _new_game))
			menu_body.add_child(_btn("Expedition", I_TARGET, Color("#2d7a6a"), func(): game.send_expedition(); _sfx(SFX_A)))
			menu_body.add_child(_btn("Stoke Fire", I_WRENCH, Color("#c07020"), func(): game.repair_hearth(); _sfx(SFX_A)))
			var tip := Label.new()
			tip.text = "Drag map · Build for cards · Tap fire or buildings\nP pause · C collect · Esc close"
			tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			tip.add_theme_color_override("font_color", Color("#4a6070"))
			tip.add_theme_font_size_override("font_size", 12)
			menu_body.add_child(tip)

func _person(p: Dictionary) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _style(Color.WHITE, Color(0.6, 0.8, 0.9, 0.4), 10))
	var row := HBoxContainer.new()
	card.add_child(row)
	var info := Label.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.text = "%s\n%s · HP %s%%" % [p["name"], p.get("role", "Idle"), int(p.get("health", 100))]
	info.add_theme_color_override("font_color", Color("#153247"))
	info.add_theme_font_size_override("font_size", 12)
	row.add_child(info)
	var sid := int(p["id"])
	var idle := _btn("Idle", I_MINUS, Color("#708090"), func(): game.assign_survivor(sid, ""); _sfx(SFX_B))
	idle.custom_minimum_size = Vector2(70, 34)
	idle.disabled = str(p.get("building_id", "")) == ""
	row.add_child(idle)
	var job := _btn("Job", I_PLUS, Color("#2a8fc4"), func():
		game.assign_survivor(sid, selected if sheet_on else "cabin")
		_sfx(SFX_B)
	)
	job.custom_minimum_size = Vector2(70, 34)
	row.add_child(job)
	return card

func _goal(g: Dictionary) -> Control:
	var done := bool(g["complete"])
	var active := bool(g.get("active", false))
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _style(
		Color(0.85, 1.0, 0.9, 0.95) if done else Color.WHITE,
		Color("#60d090") if done else Color(0.6, 0.8, 0.9, 0.4), 10
	))
	var box := VBoxContainer.new()
	card.add_child(box)
	var t := Label.new()
	t.text = "%s %s" % ["✓" if done else ("▶" if active else "·"), g["title"]]
	t.add_theme_color_override("font_color", Color("#0d4b35") if done else Color("#153247"))
	t.add_theme_font_size_override("font_size", 13)
	box.add_child(t)
	var d := Label.new()
	d.text = "%s\n%s" % [g["detail"], g["progress"]]
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	d.add_theme_color_override("font_color", Color("#3c6b58") if done else Color("#4a6070"))
	d.add_theme_font_size_override("font_size", 11)
	box.add_child(d)
	return card

func _log(msg: String) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _style(Color(0.12, 0.28, 0.38, 0.9), Color(0.5, 0.8, 1.0, 0.25), 8))
	var l := Label.new()
	l.text = msg
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_color_override("font_color", Color("#d8edf7"))
	l.add_theme_font_size_override("font_size", 12)
	card.add_child(l)
	return card

func _store() -> void:
	var layout := {}
	for id in positions.keys():
		var c: Vector2i = positions[id]
		layout[id] = {"x": c.x, "y": c.y}
	game.layout_data = {"buildings": layout}

func _restore() -> void:
	positions = {"cabin": Vector2i(CX, CY - 3)}
	var layout: Dictionary = game.layout_data.get("buildings", {})
	for id in layout.keys():
		if not game.has_building(id):
			continue
		var e: Dictionary = layout[id]
		positions[id] = Vector2i(int(e.get("x", CX)), int(e.get("y", CY - 3)))
	for id in game.buildings.keys():
		if not positions.has(id):
			positions[id] = _find_spot()
	_queue_world()

func _save() -> void:
	_sfx(SFX_A)
	_store()
	_toast("Saved" if game.save_game() else "Save failed")

func _load() -> void:
	_sfx(SFX_A)
	if not game.has_save():
		_toast("No save")
		return
	if game.load_game():
		placing = ""
		move_mode = false
		_set_place(false)
		_close_menu()
		_close_sheet()
		_hide_tray()
		if tut:
			tut.visible = false
		if choice:
			choice.visible = false
		if endp:
			endp.visible = false
		_restore()
		call_deferred("_center")
		_toast("Day %s" % game.day)

func _new_game() -> void:
	_sfx(SFX_A)
	if tut:
		tut.visible = false
	if choice:
		choice.visible = false
	if endp:
		endp.visible = false
	placing = ""
	move_mode = false
	_set_place(false)
	_close_menu()
	_close_sheet()
	_hide_tray()
	positions = {"cabin": Vector2i(CX, CY - 3)}
	game.start_new_game()
	_queue_world()
	call_deferred("_center")

func _on_tut(_s: int, title: String, body: String) -> void:
	tut_t.text = title
	tut_b.text = body
	tut.visible = true

func _on_choice(_id: String, title: String, body: String, options: Array) -> void:
	ch_t.text = title
	ch_b.text = body
	for c in ch_row.get_children():
		c.queue_free()
	for o in options:
		var oid := str(o.get("id", ""))
		var b := _btn(str(o.get("label", "?")), I_TARGET, Color("#2a7aa8"), func():
			_sfx(SFX_A)
			choice.visible = false
			game.resolve_choice(oid)
			if not game.game_over:
				game.set_paused(false)
		)
		b.custom_minimum_size = Vector2(280, 48)
		ch_row.add_child(b)
	choice.visible = true

func _on_end(won: bool, summary: String) -> void:
	end_t.text = "CITY SECURED" if won else "CITY FALLEN"
	end_b.text = ("%s\n\n%s" % [
		"The fire still burns." if won else "The fire went out.",
		summary,
	])
	endp.visible = true

func _toast(msg: String) -> void:
	if toast == null:
		return
	toast.text = "  %s  " % msg
	toast.visible = true
	toast_t = 2.2

func _sfx(st: AudioStream) -> void:
	if sfx == null or game == null or not game.sfx_enabled:
		return
	sfx.stream = st
	sfx.play()

# =============================================================================
# WIDGETS
# =============================================================================

func _spr(id: String) -> Texture2D:
	var o: Array = SPRITES[id]
	var l := int(game.buildings[id]["level"]) if game.has_building(id) else 1
	return o[clampi(l - 1, 0, o.size() - 1)]

func _blueprint(id: String) -> Texture2D:
	return SPRITES[id][0]

func _cap(tex: Texture2D, sc: float, mx: float) -> Vector2:
	var s := Vector2(tex.get_width(), tex.get_height()) * sc
	var m := maxf(s.x, s.y)
	if m > mx and m > 0.0:
		s *= mx / m
	return s

func _fmt_prod(p: Dictionary) -> String:
	var parts: Array[String] = []
	for k in p.keys():
		if str(k) == "heat_gen":
			continue
		parts.append("+%.1f %s/d" % [float(p[k]), k])
	return ", ".join(parts) if not parts.is_empty() else "support"

func _fmt_cost(c: Dictionary) -> String:
	var parts: Array[String] = []
	for k in ["wood", "tools", "coal", "iron", "seed"]:
		if c.has(k) and int(c[k]) > 0:
			parts.append("%s %s" % [int(c[k]), k])
	return ", ".join(parts) if not parts.is_empty() else "free"

func _style(bg: Color, border: Color, r: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(1)
	s.set_corner_radius_all(r)
	s.content_margin_left = 10
	s.content_margin_top = 8
	s.content_margin_right = 10
	s.content_margin_bottom = 8
	s.shadow_color = Color(0.2, 0.35, 0.45, 0.18)
	s.shadow_size = 6
	s.shadow_offset = Vector2(0, 2)
	return s

func _bar(fill: Color, tip: String) -> ProgressBar:
	var p := ProgressBar.new()
	p.min_value = 0
	p.max_value = 100
	p.show_percentage = true
	p.tooltip_text = tip
	p.custom_minimum_size = Vector2(72, 20)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("background", _style(Color(0.9, 0.94, 0.97, 0.9), Color(0.7, 0.82, 0.9, 0.4), 8))
	var f := StyleBoxFlat.new()
	f.bg_color = fill
	f.set_corner_radius_all(8)
	p.add_theme_stylebox_override("fill", f)
	p.add_theme_color_override("font_color", Color("#1a3040"))
	p.add_theme_font_size_override("font_size", 9)
	return p

func _btn(text: String, icon: Texture2D, color: Color, cb: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.icon = icon
	b.expand_icon = true
	b.custom_minimum_size = Vector2(120, 42)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_stylebox_override("normal", _style(color, Color(1, 1, 1, 0.35), 12))
	b.add_theme_stylebox_override("hover", _style(color.lightened(0.1), Color.WHITE, 12))
	b.add_theme_stylebox_override("pressed", _style(color.darkened(0.1), Color(1, 1, 1, 0.25), 12))
	b.add_theme_stylebox_override("disabled", _style(Color("#90a0b0"), Color(1, 1, 1, 0.15), 12))
	b.add_theme_color_override("font_color", Color.WHITE)
	b.add_theme_font_size_override("font_size", 12)
	b.pressed.connect(cb)
	return b

func _ico(icon: Texture2D, cb: Callable) -> Button:
	var b := Button.new()
	b.icon = icon
	b.expand_icon = true
	b.custom_minimum_size = Vector2(40, 36)
	b.add_theme_stylebox_override("normal", _style(Color("#3a8ab8"), Color.WHITE, 10))
	b.add_theme_stylebox_override("hover", _style(Color("#4aa0d0"), Color.WHITE, 10))
	b.add_theme_stylebox_override("pressed", _style(Color("#2a6a90"), Color.WHITE, 10))
	b.add_theme_stylebox_override("disabled", _style(Color("#90a0b0"), Color.WHITE, 10))
	b.pressed.connect(cb)
	return b

func _dock(text: String, icon: Texture2D, color: Color, cb: Callable) -> Button:
	var b := _btn(text, icon, color, cb)
	b.custom_minimum_size = Vector2(0, 56)
	b.add_theme_font_size_override("font_size", 11)
	return b

func _lab(sz: int, c: Color) -> Label:
	var l := Label.new()
	l.add_theme_color_override("font_color", c)
	l.add_theme_font_size_override("font_size", sz)
	return l

func _modal() -> PanelContainer:
	var dim := PanelContainer.new()
	dim.visible = false
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_theme_stylebox_override("panel", _style(Color(0.08, 0.16, 0.24, 0.65), Color(0, 0, 0, 0), 0))
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(380, 0)
	card.add_theme_stylebox_override("panel", _style(Color(0.98, 0.99, 1.0, 0.99), Color(0.7, 0.88, 1.0, 0.7), 18))
	center.add_child(card)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	card.add_child(box)
	dim.set_meta("box", box)
	return dim
