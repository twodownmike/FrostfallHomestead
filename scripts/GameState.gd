extends RefCounted
class_name GameState

## Frostfall Homestead — Whiteout Survival-style settlement simulation.

signal changed
signal event_added(message: String)
signal choice_requested(event_id: String, title: String, body: String, options: Array)
signal game_ended(victory: bool, summary: String)
signal tutorial_step(step: int, title: String, body: String)
signal resources_collected(building_id: String, amounts: Dictionary)
signal storm_warning(days_until: int, intensity: String)
signal toast(message: String)

const SAVE_PATH := "user://frostfall_save.json"
const SAVE_VERSION := 3
const DAY_LENGTH := 24.0
const BUBBLE_SOFT_CAP := 80.0
const MAX_SURVIVORS := 20
const SURVIVOR_NAMES := [
	"Asha", "Bram", "Cora", "Daven", "Elise", "Finn", "Greta", "Holt",
	"Ivy", "Jorn", "Kira", "Lars", "Mira", "Nils", "Olga", "Pax",
	"Quinn", "Rhea", "Soren", "Tessa", "Ulric", "Vera", "Wren", "Yuri",
]

const BUILDING_ORDER := [
	"cabin", "woodlot", "garden", "well", "hunter", "workshop",
	"kitchen", "warehouse", "root_cellar", "smokehouse", "coop", "infirmary", "watchtower",
]

const BUILDING_BLUEPRINTS := {
	"cabin": {"name": "Furnace Hall", "level": 1, "workers": 2, "max_workers": 4, "condition": 88.0, "readiness": 50.0, "category": "core"},
	"woodlot": {"name": "Lumber Yard", "level": 1, "workers": 0, "max_workers": 5, "condition": 75.0, "readiness": 15.0, "category": "production"},
	"garden": {"name": "Winter Farm", "level": 1, "workers": 0, "max_workers": 5, "condition": 70.0, "readiness": 15.0, "category": "production"},
	"well": {"name": "Water Pump", "level": 1, "workers": 0, "max_workers": 3, "condition": 78.0, "readiness": 15.0, "category": "production"},
	"hunter": {"name": "Hunter's Cabin", "level": 1, "workers": 0, "max_workers": 4, "condition": 72.0, "readiness": 15.0, "category": "production"},
	"workshop": {"name": "Workshop", "level": 1, "workers": 0, "max_workers": 4, "condition": 74.0, "readiness": 15.0, "category": "production"},
	"kitchen": {"name": "Cookhouse", "level": 1, "workers": 0, "max_workers": 4, "condition": 76.0, "readiness": 15.0, "category": "support"},
	"warehouse": {"name": "Warehouse", "level": 1, "workers": 0, "max_workers": 2, "condition": 82.0, "readiness": 10.0, "category": "support"},
	"root_cellar": {"name": "Root Cellar", "level": 1, "workers": 0, "max_workers": 2, "condition": 80.0, "readiness": 15.0, "category": "support"},
	"smokehouse": {"name": "Smokehouse", "level": 1, "workers": 0, "max_workers": 3, "condition": 74.0, "readiness": 15.0, "category": "support"},
	"coop": {"name": "Livestock Pen", "level": 1, "workers": 0, "max_workers": 3, "condition": 76.0, "readiness": 15.0, "category": "production"},
	"infirmary": {"name": "Infirmary", "level": 1, "workers": 0, "max_workers": 3, "condition": 80.0, "readiness": 15.0, "category": "support"},
	"watchtower": {"name": "Watchtower", "level": 1, "workers": 0, "max_workers": 2, "condition": 85.0, "readiness": 15.0, "category": "defense"},
}

const STARTING_BUILDINGS := {
	"cabin": {"name": "Furnace Hall", "level": 1, "workers": 2, "max_workers": 4, "condition": 88.0, "readiness": 50.0, "category": "core", "under_construction": false},
}

const BUILD_COSTS := {
	"woodlot": {"wood": 28, "tools": 2, "coal": 0, "iron": 0},
	"garden": {"wood": 22, "tools": 1, "seed": 5},
	"well": {"wood": 34, "tools": 3, "iron": 1},
	"hunter": {"wood": 30, "tools": 2},
	"workshop": {"wood": 45, "tools": 5, "iron": 2},
	"kitchen": {"wood": 36, "tools": 3},
	"warehouse": {"wood": 40, "tools": 3, "iron": 1},
	"root_cellar": {"wood": 35, "tools": 3, "seed": 3},
	"smokehouse": {"wood": 40, "tools": 4},
	"coop": {"wood": 26, "tools": 2, "seed": 6},
	"infirmary": {"wood": 42, "tools": 5, "iron": 2},
	"watchtower": {"wood": 48, "tools": 4, "iron": 3},
}

const BUILDING_UNLOCKS := {
	"woodlot": {"building": "cabin", "level": 1, "label": "Furnace Hall L1"},
	"garden": {"building": "cabin", "level": 1, "label": "Furnace Hall L1"},
	"well": {"building": "cabin", "level": 1, "label": "Furnace Hall L1"},
	"hunter": {"building": "woodlot", "level": 1, "label": "Lumber Yard"},
	"workshop": {"building": "cabin", "level": 2, "label": "Furnace Hall L2"},
	"kitchen": {"building": "garden", "level": 1, "label": "Winter Farm"},
	"warehouse": {"building": "cabin", "level": 2, "label": "Furnace Hall L2"},
	"root_cellar": {"building": "garden", "level": 1, "label": "Winter Farm"},
	"smokehouse": {"building": "hunter", "level": 1, "label": "Hunter's Cabin"},
	"coop": {"building": "garden", "level": 2, "label": "Winter Farm L2"},
	"infirmary": {"building": "cabin", "level": 2, "label": "Furnace Hall L2"},
	"watchtower": {"building": "cabin", "level": 3, "label": "Furnace Hall L3"},
}

const BUILD_DURATION := {
	"woodlot": 12.0, "garden": 14.0, "well": 18.0, "hunter": 16.0,
	"workshop": 24.0, "kitchen": 18.0, "warehouse": 20.0, "root_cellar": 20.0,
	"smokehouse": 22.0, "coop": 15.0, "infirmary": 26.0, "watchtower": 28.0,
}

const SURVIVAL_GOALS := [
	{"id": "build_woodlot", "chapter": 1, "title": "Secure Fuel", "detail": "Build a Lumber Yard.", "reward": {"wood": 20, "morale": 3}},
	{"id": "assign_woodlot", "chapter": 1, "title": "Chop the Line", "detail": "Assign 2 survivors to the Lumber Yard.", "reward": {"wood": 18}},
	{"id": "collect_resources", "chapter": 1, "title": "First Harvest", "detail": "Collect production bubbles 5 times.", "reward": {"food": 15, "morale": 2}},
	{"id": "stoke_furnace", "chapter": 1, "title": "Feed the Furnace", "detail": "Stoke the furnace until heat reaches 75.", "reward": {"heat": 8, "morale": 4}},
	{"id": "build_garden", "chapter": 2, "title": "Plant Beds", "detail": "Build a Winter Farm.", "reward": {"food": 22, "seed": 6}},
	{"id": "build_well", "chapter": 2, "title": "Clean Water", "detail": "Build a Water Pump.", "reward": {"water": 30, "morale": 3}},
	{"id": "build_hunter", "chapter": 2, "title": "Track Game", "detail": "Build a Hunter's Cabin.", "reward": {"food": 24, "tools": 1}},
	{"id": "homestead_l2", "chapter": 2, "title": "Raise the Hall", "detail": "Upgrade Furnace Hall to level 2.", "reward": {"wood": 22, "tools": 2, "coal": 4}},
	{"id": "build_kitchen", "chapter": 3, "title": "Hot Meals", "detail": "Build a Cookhouse.", "reward": {"food": 20, "morale": 5}},
	{"id": "build_warehouse", "chapter": 3, "title": "Stockpile Room", "detail": "Build a Warehouse to raise storage caps.", "reward": {"wood": 16, "tools": 2}},
	{"id": "build_workshop", "chapter": 3, "title": "Tools of Survival", "detail": "Build a Workshop.", "reward": {"tools": 6, "iron": 2}},
	{"id": "survive_week", "chapter": 3, "title": "Seven Cold Nights", "detail": "Reach day 7 with morale above 35.", "reward": {"food": 35, "wood": 30, "morale": 8}},
	{"id": "build_infirmary", "chapter": 4, "title": "Tend the Sick", "detail": "Build an Infirmary.", "reward": {"morale": 6, "tools": 3}},
	{"id": "homestead_l3", "chapter": 4, "title": "City Heart", "detail": "Upgrade Furnace Hall to level 3.", "reward": {"tools": 5, "coal": 8, "morale": 5}},
	{"id": "population_12", "chapter": 4, "title": "Growing Clan", "detail": "House 12 survivors.", "reward": {"food": 40, "wood": 20}},
	{"id": "power_120", "chapter": 4, "title": "Settlement Power 120", "detail": "Reach 120 settlement power.", "reward": {"tools": 6, "iron": 3, "morale": 5}},
	{"id": "build_watchtower", "chapter": 5, "title": "Eyes on the Ridge", "detail": "Build a Watchtower.", "reward": {"tools": 4, "morale": 4}},
	{"id": "survive_fortnight", "chapter": 5, "title": "Hold Two Weeks", "detail": "Reach day 14 with morale above 40.", "reward": {"food": 45, "wood": 40, "tools": 5, "morale": 10}},
	{"id": "power_180", "chapter": 5, "title": "Stormproof City", "detail": "Reach 180 settlement power.", "reward": {"tools": 10, "coal": 12, "iron": 6, "morale": 10}},
	{"id": "survive_blizzard", "chapter": 5, "title": "Outlast the Whiteout", "detail": "Survive a major blizzard event.", "reward": {"morale": 12, "heat": 10, "coal": 10}},
]

const CHAPTER_TITLES := {
	1: "Chapter 1: First Furnace",
	2: "Chapter 2: Food & Water",
	3: "Chapter 3: Working City",
	4: "Chapter 4: Growing Strong",
	5: "Chapter 5: Whiteout Proof",
}

const BUILDING_DETAILS := {
	"cabin": {"role": "City core — furnace heat, shelter, command", "output": "Heat stability + morale", "risk": "If the furnace dies, the city freezes."},
	"woodlot": {"role": "Timber and firewood production", "output": "Wood (+ coal scrap at higher levels)", "risk": "No wood means no furnace fuel."},
	"garden": {"role": "Cold-frame crops and seed", "output": "Food and seed bubbles", "risk": "Frost kills unattended beds."},
	"well": {"role": "Drinking water and ice clearing", "output": "Water bubbles", "risk": "Frozen pumps starve the city."},
	"hunter": {"role": "Hunting parties and game meat", "output": "Food bubbles", "risk": "Empty trails mean empty pots."},
	"workshop": {"role": "Tools, repairs, iron work", "output": "Tools and iron", "risk": "Broken tools halt construction."},
	"kitchen": {"role": "Cooks meals that stretch food and raise morale", "output": "Food efficiency + morale", "risk": "Cold kitchens waste rations."},
	"warehouse": {"role": "Raises resource storage caps", "output": "Storage capacity", "risk": "Overcap losses dump excess goods."},
	"root_cellar": {"role": "Slows food spoilage", "output": "Spoilage reduction", "risk": "Without storage, food rots fast."},
	"smokehouse": {"role": "Preserves meat from hunts", "output": "Food preservation", "risk": "Wet smoke ruins the haul."},
	"coop": {"role": "Eggs and livestock products", "output": "Food + morale", "risk": "Predators empty pens overnight."},
	"infirmary": {"role": "Heals sick survivors", "output": "Health recovery", "risk": "Illness spreads without care."},
	"watchtower": {"role": "Storm scouting and city defense", "output": "Storm warning lead time", "risk": "Blind cities get hit unprepared."},
}

const TUTORIAL_STEPS := [
	{"title": "Whiteout City", "body": "You command a frozen settlement. Keep the furnace hot, stores full, and survivors healthy — or the whiteout wins."},
	{"title": "Collect Bubbles", "body": "Buildings produce floating resource bubbles. Tap a building (or Collect All) to claim them. Don't let bubbles cap out."},
	{"title": "Furnace Heat", "body": "Open Furnace Hall and Stoke Furnace with wood or coal. Heat is life — storms drain it fast."},
	{"title": "Survivors", "body": "Open Survivors to assign people to jobs. Idle hands produce nothing. Sick survivors work poorly."},
	{"title": "Build & Survive", "body": "Use Build to place structures. Complete chapter missions, endure blizzards, and grow into a stormproof city."},
]

const RESOURCE_KEYS := ["food", "wood", "water", "tools", "seed", "coal", "iron"]

var day := 1
var season := "Early Winter"
var seconds_until_day := DAY_LENGTH
var homesteaders := 8
var available_workers := 0
var morale := 72.0
var heat := 68.0
var furnace_fuel := 20.0
var resources := {}
var buildings := {}
var survivors: Array = []
var pending_collect := {}
var event_log: Array[String] = []
var completed_goals := {}
var scouted_sites := {}
var current_chapter := 1
var active_project := {}
var _project_refresh_timer := 0.0
var _prod_timer := 0.0
var game_over := false
var victory := false
var paused := false
var time_scale := 1.0
var expedition_cooldown := 0.0
var days_without_shortage := 0
var pending_choice := {}
var tutorial_index := 0
var tutorial_complete := false
var total_days_survived := 0
var peak_power := 0
var auto_save_day_marker := 0
var layout_data := {}
var collect_count := 0
var survived_blizzard := false
var next_storm_day := 5
var storm_intensity := "gale"
var storm_active_days := 0
var save_timestamp := 0
var total_collected := {}
var sfx_enabled := true
var _name_cursor := 0
var stats := {"days_played": 0, "collects": 0, "buildings_built": 0, "storms_survived": 0}

func _init() -> void:
	_reset_runtime_state()

func _reset_runtime_state() -> void:
	day = 1
	season = "Early Winter"
	seconds_until_day = DAY_LENGTH
	homesteaders = 8
	morale = 74.0
	heat = 68.0
	furnace_fuel = 24.0
	resources = {
		"food": 140.0, "wood": 110.0, "water": 90.0, "tools": 14.0,
		"seed": 20.0, "coal": 8.0, "iron": 4.0,
	}
	buildings = STARTING_BUILDINGS.duplicate(true)
	pending_collect.clear()
	survivors.clear()
	_name_cursor = 0
	_spawn_starting_survivors()
	event_log.clear()
	completed_goals.clear()
	scouted_sites.clear()
	current_chapter = 1
	active_project.clear()
	_project_refresh_timer = 0.0
	_prod_timer = 0.0
	game_over = false
	victory = false
	paused = false
	time_scale = 1.0
	expedition_cooldown = 0.0
	days_without_shortage = 0
	pending_choice.clear()
	tutorial_index = 0
	tutorial_complete = false
	total_days_survived = 0
	peak_power = 0
	auto_save_day_marker = 0
	layout_data = {}
	collect_count = 0
	survived_blizzard = false
	next_storm_day = 5
	storm_intensity = "gale"
	storm_active_days = 0
	save_timestamp = int(Time.get_unix_time_from_system())
	total_collected = {}
	for k in RESOURCE_KEYS:
		total_collected[k] = 0.0
	stats = {"days_played": 0, "collects": 0, "buildings_built": 0, "storms_survived": 0}
	_recalculate_workers()
	_add_event("Furnace Hall lights for the first night. Frostfall City begins.")
	_check_goals()

func start_new_game() -> void:
	_reset_runtime_state()
	changed.emit()
	if not tutorial_complete:
		_emit_tutorial()

func tick(delta: float) -> void:
	if game_over or paused or not pending_choice.is_empty():
		return

	var scaled := delta * time_scale
	if expedition_cooldown > 0.0:
		expedition_cooldown = maxf(0.0, expedition_cooldown - scaled)

	var project_changed := _tick_active_project(scaled)
	var prod_changed := _tick_production(scaled)
	_tick_furnace(scaled)

	seconds_until_day -= scaled
	if seconds_until_day > 0.0:
		if project_changed or prod_changed:
			changed.emit()
		return

	seconds_until_day = DAY_LENGTH
	day += 1
	total_days_survived = day
	stats["days_played"] = day
	_update_season()
	_apply_daily_cycle()
	_check_goals()
	_check_victory()
	peak_power = maxi(peak_power, settlement_power())
	if day - auto_save_day_marker >= 1 and not game_over:
		auto_save_day_marker = day
		save_game()
	changed.emit()

func set_paused(value: bool) -> void:
	if game_over and value == false and not victory:
		return
	paused = value
	changed.emit()

func toggle_pause() -> void:
	set_paused(not paused)

func cycle_time_scale() -> void:
	if time_scale < 0.75:
		time_scale = 1.0
	elif time_scale < 1.5:
		time_scale = 2.0
	elif time_scale < 2.5:
		time_scale = 3.0
	else:
		time_scale = 0.5
	toast.emit("Speed %sx" % _scale_label())
	changed.emit()

func set_time_scale(scale: float) -> void:
	time_scale = clampf(scale, 0.5, 3.0)
	changed.emit()

func advance_tutorial() -> void:
	if tutorial_complete:
		return
	tutorial_index += 1
	if tutorial_index >= TUTORIAL_STEPS.size():
		tutorial_complete = true
		paused = false
		_add_event("Tutorial complete. The whiteout is yours to outlast.")
		changed.emit()
		return
	_emit_tutorial()
	changed.emit()

func skip_tutorial() -> void:
	tutorial_complete = true
	tutorial_index = TUTORIAL_STEPS.size()
	paused = false
	_add_event("Tutorial skipped.")
	changed.emit()

# --- Buildings API ---

func building_ids() -> Array:
	return BUILDING_ORDER.duplicate()

func building_name(building_id: String) -> String:
	if buildings.has(building_id):
		return String(buildings[building_id]["name"])
	if BUILDING_BLUEPRINTS.has(building_id):
		return String(BUILDING_BLUEPRINTS[building_id]["name"])
	return "Building"

func has_building(building_id: String) -> bool:
	return buildings.has(building_id)

func is_building_operational(building_id: String) -> bool:
	return buildings.has(building_id) and not bool(buildings[building_id].get("under_construction", false))

func project_in_progress() -> bool:
	return not active_project.is_empty()

func project_status() -> String:
	if active_project.is_empty():
		return "No active project"
	return "%s · %ss" % [active_project["name"], ceili(float(active_project["remaining"]))]

func project_progress() -> float:
	if active_project.is_empty():
		return 0.0
	var duration := maxf(float(active_project.get("duration", 1.0)), 0.01)
	return clampf(1.0 - float(active_project["remaining"]) / duration, 0.0, 1.0)

func build_lock_reason(building_id: String) -> String:
	if not BUILDING_UNLOCKS.has(building_id):
		return ""
	var unlock: Dictionary = BUILDING_UNLOCKS[building_id]
	if not buildings.has(unlock["building"]):
		return "Requires %s" % unlock["label"]
	if int(buildings[unlock["building"]]["level"]) < int(unlock["level"]):
		return "Requires %s" % unlock["label"]
	return ""

func is_building_unlocked(building_id: String) -> bool:
	return build_lock_reason(building_id) == ""

func build_cost(building_id: String) -> Dictionary:
	return BUILD_COSTS.get(building_id, {})

func can_build(building_id: String) -> bool:
	if game_over or buildings.has(building_id) or project_in_progress():
		return false
	if not is_building_unlocked(building_id) or not BUILD_COSTS.has(building_id):
		return false
	return _can_afford(build_cost(building_id))

func build(building_id: String) -> bool:
	if not can_build(building_id):
		if buildings.has(building_id):
			_add_event("%s is already built." % building_name(building_id))
		elif not is_building_unlocked(building_id):
			_add_event("%s locked. %s." % [building_name(building_id), build_lock_reason(building_id)])
		elif project_in_progress():
			_add_event("Finish current project first.")
		else:
			_add_event("Not enough supplies for %s." % building_name(building_id))
		changed.emit()
		return false
	_pay_cost(build_cost(building_id))
	var blueprint: Dictionary = BUILDING_BLUEPRINTS[building_id].duplicate(true)
	blueprint["under_construction"] = true
	blueprint["workers"] = 0
	buildings[building_id] = blueprint
	pending_collect[building_id] = {}
	var duration := float(BUILD_DURATION.get(building_id, 20.0))
	active_project = {
		"type": "build", "building_id": building_id, "name": blueprint["name"],
		"remaining": duration, "duration": duration,
	}
	_project_refresh_timer = 0.0
	_add_event("%s construction started (%ss)." % [blueprint["name"], int(duration)])
	_recalculate_workers()
	changed.emit()
	return true

func can_upgrade(building_id: String) -> bool:
	if not is_building_operational(building_id) or project_in_progress() or game_over:
		return false
	var level := int(buildings[building_id]["level"])
	if level >= 8:
		return false
	return _can_afford(upgrade_cost(building_id))

func upgrade_cost(building_id: String) -> Dictionary:
	if not buildings.has(building_id):
		return {}
	var level := int(buildings[building_id]["level"])
	return {
		"wood": 22 + level * 14,
		"tools": 2 + level,
		"coal": maxi(0, level - 1),
		"iron": maxi(0, level - 2),
	}

func upgrade_duration(building_id: String) -> float:
	if not buildings.has(building_id):
		return 0.0
	return 14.0 + float(buildings[building_id]["level"]) * 9.0

func upgrade(building_id: String) -> void:
	if not can_upgrade(building_id):
		_add_event("Cannot upgrade %s right now." % building_name(building_id))
		changed.emit()
		return
	_pay_cost(upgrade_cost(building_id))
	var duration := upgrade_duration(building_id)
	active_project = {
		"type": "upgrade",
		"building_id": building_id,
		"name": String(buildings[building_id]["name"]),
		"target_level": int(buildings[building_id]["level"]) + 1,
		"remaining": duration,
		"duration": duration,
	}
	_project_refresh_timer = 0.0
	_add_event("%s upgrade started (%ss)." % [buildings[building_id]["name"], int(duration)])
	changed.emit()

func assign_worker(building_id: String, amount: int) -> void:
	if game_over or not is_building_operational(building_id):
		return
	var building: Dictionary = buildings[building_id]
	var current := int(building["workers"])
	var max_w := int(building["max_workers"])
	if amount > 0:
		var add := mini(amount, available_workers)
		add = mini(add, max_w - current)
		if add <= 0:
			return
		building["workers"] = current + add
		_assign_survivors_to(building_id, add)
	else:
		var remove := mini(absi(amount), current)
		if remove <= 0:
			return
		building["workers"] = current - remove
		_unassign_survivors_from(building_id, remove)
	buildings[building_id] = building
	_recalculate_workers()
	_check_goals()
	changed.emit()

func building_details(building_id: String) -> Dictionary:
	return BUILDING_DETAILS.get(building_id, {"role": "Structure", "output": "—", "risk": "—"})

func building_status_text(building_id: String) -> String:
	if not buildings.has(building_id):
		var lock := build_lock_reason(building_id)
		if lock != "":
			return lock
		if project_in_progress():
			return "Project busy"
		return "Ready to build"
	if bool(buildings[building_id].get("under_construction", false)):
		return "Building %ss" % _project_seconds_for(building_id)
	if active_project.get("building_id", "") == building_id and active_project.get("type", "") == "upgrade":
		return "Upgrading L%s · %ss" % [active_project["target_level"], _project_seconds_for(building_id)]
	var cond := float(buildings[building_id]["condition"])
	if cond < 30.0:
		return "Critical"
	if cond < 55.0:
		return "Damaged"
	return "Operational"

func production_preview(building_id: String) -> Dictionary:
	if not is_building_operational(building_id):
		return {}
	return _hourly_rates(building_id)

func building_actions(building_id: String) -> Array[Dictionary]:
	if not is_building_operational(building_id):
		return []
	var actions: Array[Dictionary] = []
	match building_id:
		"cabin":
			actions = [
				{"id": "stoke_wood", "name": "Stoke (Wood)", "cost": "15 wood", "effect": "+16 heat, +fuel"},
				{"id": "stoke_coal", "name": "Stoke (Coal)", "cost": "6 coal", "effect": "+22 heat, +fuel"},
				{"id": "council", "name": "City Council", "cost": "10 food", "effect": "+8 morale"},
			]
		"woodlot":
			actions = [
				{"id": "fell", "name": "Clearcut", "cost": "1 idle", "effect": "+32 wood bubble"},
				{"id": "charcoal", "name": "Burn Charcoal", "cost": "20 wood", "effect": "+8 coal"},
			]
		"garden":
			actions = [
				{"id": "cover", "name": "Cover Crops", "cost": "8 wood", "effect": "+20 food bubble"},
				{"id": "save_seed", "name": "Save Seed", "cost": "10 food", "effect": "+14 seed"},
			]
		"well":
			actions = [
				{"id": "draw", "name": "Pump Water", "cost": "ready", "effect": "+28 water bubble"},
				{"id": "clear_ice", "name": "Clear Ice", "cost": "1 tool", "effect": "+condition, water"},
			]
		"hunter":
			actions = [
				{"id": "hunt", "name": "Hunt Party", "cost": "2 idle, 8 food", "effect": "+36 food bubble"},
				{"id": "trapline", "name": "Set Traps", "cost": "6 wood", "effect": "+16 food bubble"},
			]
		"workshop":
			actions = [
				{"id": "craft", "name": "Forge Tools", "cost": "16 wood, 2 iron", "effect": "+6 tools"},
				{"id": "reinforce", "name": "Repair Weakest", "cost": "2 tools", "effect": "+condition"},
			]
		"kitchen":
			actions = [
				{"id": "feast", "name": "Hearty Stew", "cost": "18 food, 4 wood", "effect": "+12 morale, heat"},
				{"id": "ration", "name": "Ration Packs", "cost": "12 food", "effect": "stretch stores"},
			]
		"warehouse":
			actions = [
				{"id": "organize", "name": "Organize", "cost": "ready", "effect": "+temp capacity"},
				{"id": "repair_roof", "name": "Repair Roof", "cost": "10 wood, 1 tool", "effect": "+condition"},
			]
		"root_cellar":
			actions = [
				{"id": "sort_stores", "name": "Sort Stores", "cost": "ready", "effect": "+14 food"},
				{"id": "ice_pack", "name": "Pack Ice", "cost": "6 water", "effect": "less spoilage"},
			]
		"smokehouse":
			actions = [
				{"id": "smoke_meat", "name": "Smoke Meat", "cost": "10 wood, 8 food", "effect": "+24 preserved"},
				{"id": "render_fat", "name": "Render Fat", "cost": "6 food", "effect": "+heat, morale"},
			]
		"coop":
			actions = [
				{"id": "collect_eggs", "name": "Gather Eggs", "cost": "ready", "effect": "+16 food bubble"},
				{"id": "mend_roost", "name": "Mend Pens", "cost": "6 wood", "effect": "+condition"},
			]
		"infirmary":
			actions = [
				{"id": "treat", "name": "Treat Sick", "cost": "8 food, 1 tool", "effect": "heal survivors"},
				{"id": "medicine", "name": "Brew Tonic", "cost": "6 seed, 4 water", "effect": "+health all"},
			]
		"watchtower":
			actions = [
				{"id": "scout_storm", "name": "Scout Horizon", "cost": "ready", "effect": "storm intel"},
				{"id": "reinforce_wall", "name": "Brace Posts", "cost": "12 wood, 2 tools", "effect": "+condition, morale"},
			]
	return actions

func can_perform_building_action(building_id: String, action_id: String) -> bool:
	if game_over or not is_building_operational(building_id):
		return false
	if float(buildings[building_id]["readiness"]) < 18.0:
		return false
	match action_id:
		"stoke_wood":
			return resources["wood"] >= 15.0
		"stoke_coal":
			return resources["coal"] >= 6.0
		"council":
			return resources["food"] >= 10.0
		"fell":
			return available_workers >= 1
		"charcoal":
			return resources["wood"] >= 20.0
		"cover":
			return resources["wood"] >= 8.0
		"save_seed":
			return resources["food"] >= 10.0
		"draw":
			return true
		"clear_ice":
			return resources["tools"] >= 1.0
		"hunt":
			return available_workers >= 2 and resources["food"] >= 8.0
		"trapline":
			return resources["wood"] >= 6.0
		"craft":
			return resources["wood"] >= 16.0 and resources["iron"] >= 2.0
		"reinforce":
			return resources["tools"] >= 2.0
		"feast":
			return resources["food"] >= 18.0 and resources["wood"] >= 4.0
		"ration":
			return resources["food"] >= 12.0
		"organize":
			return true
		"repair_roof":
			return resources["wood"] >= 10.0 and resources["tools"] >= 1.0
		"sort_stores":
			return true
		"ice_pack":
			return resources["water"] >= 6.0
		"smoke_meat":
			return resources["wood"] >= 10.0 and resources["food"] >= 8.0
		"render_fat":
			return resources["food"] >= 6.0
		"collect_eggs":
			return true
		"mend_roost":
			return resources["wood"] >= 6.0
		"treat":
			return resources["food"] >= 8.0 and resources["tools"] >= 1.0
		"medicine":
			return resources["seed"] >= 6.0 and resources["water"] >= 4.0
		"scout_storm":
			return true
		"reinforce_wall":
			return resources["wood"] >= 12.0 and resources["tools"] >= 2.0
	return false

func perform_building_action(building_id: String, action_id: String) -> void:
	if not can_perform_building_action(building_id, action_id):
		_add_event("%s cannot run that order." % building_name(building_id))
		changed.emit()
		return

	match action_id:
		"stoke_wood":
			resources["wood"] -= 15.0
			furnace_fuel = minf(100.0, furnace_fuel + 18.0)
			heat = clampf(heat + 16.0, 0.0, 100.0)
		"stoke_coal":
			resources["coal"] -= 6.0
			furnace_fuel = minf(100.0, furnace_fuel + 28.0)
			heat = clampf(heat + 22.0, 0.0, 100.0)
		"council":
			resources["food"] -= 10.0
			morale = clampf(morale + 8.0, 0.0, 100.0)
		"fell":
			_add_to_bubble(building_id, "wood", 32.0)
		"charcoal":
			resources["wood"] -= 20.0
			_add_resource("coal", 8.0)
		"cover":
			resources["wood"] -= 8.0
			_add_to_bubble(building_id, "food", 20.0)
			buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 6.0, 0.0, 100.0)
		"save_seed":
			resources["food"] -= 10.0
			_add_resource("seed", 14.0)
		"draw":
			_add_to_bubble(building_id, "water", 28.0)
		"clear_ice":
			resources["tools"] -= 1.0
			_add_to_bubble(building_id, "water", 16.0)
			buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 12.0, 0.0, 100.0)
		"hunt":
			resources["food"] -= 8.0
			_add_to_bubble(building_id, "food", 36.0)
		"trapline":
			resources["wood"] -= 6.0
			_add_to_bubble(building_id, "food", 16.0)
		"craft":
			resources["wood"] -= 16.0
			resources["iron"] -= 2.0
			_add_resource("tools", 6.0)
		"reinforce":
			resources["tools"] -= 2.0
			var weak := _weakest_building_id()
			buildings[weak]["condition"] = clampf(float(buildings[weak]["condition"]) + 20.0, 0.0, 100.0)
		"feast":
			resources["food"] -= 18.0
			resources["wood"] -= 4.0
			morale = clampf(morale + 12.0, 0.0, 100.0)
			heat = clampf(heat + 6.0, 0.0, 100.0)
		"ration":
			resources["food"] -= 12.0
			resources["food"] += 18.0
			_add_event("Cookhouse stretched rations into durable packs.")
		"organize":
			buildings[building_id]["organized"] = true
		"repair_roof":
			resources["wood"] -= 10.0
			resources["tools"] -= 1.0
			buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 16.0, 0.0, 100.0)
		"sort_stores":
			_add_resource("food", 14.0)
		"ice_pack":
			resources["water"] -= 6.0
			buildings[building_id]["ice_packed"] = true
			buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 8.0, 0.0, 100.0)
		"smoke_meat":
			resources["wood"] -= 10.0
			resources["food"] -= 8.0
			_add_resource("food", 24.0)
		"render_fat":
			resources["food"] -= 6.0
			heat = clampf(heat + 8.0, 0.0, 100.0)
			morale = clampf(morale + 3.0, 0.0, 100.0)
		"collect_eggs":
			_add_to_bubble(building_id, "food", 16.0)
		"mend_roost":
			resources["wood"] -= 6.0
			buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 12.0, 0.0, 100.0)
			morale = clampf(morale + 2.0, 0.0, 100.0)
		"treat":
			resources["food"] -= 8.0
			resources["tools"] -= 1.0
			_heal_survivors(25.0)
		"medicine":
			resources["seed"] -= 6.0
			resources["water"] -= 4.0
			_heal_survivors(12.0)
		"scout_storm":
			var days_left := next_storm_day - day
			_add_event("Watchtower: next %s storm in %s day(s)." % [storm_intensity, maxi(0, days_left)])
			storm_warning.emit(maxi(0, days_left), storm_intensity)
		"reinforce_wall":
			resources["wood"] -= 12.0
			resources["tools"] -= 2.0
			buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 14.0, 0.0, 100.0)
			morale = clampf(morale + 4.0, 0.0, 100.0)

	buildings[building_id]["readiness"] = 0.0
	_add_event("%s: %s complete." % [building_name(building_id), _action_name(building_id, action_id)])
	_check_goals()
	changed.emit()

# --- Collect bubbles (Whiteout core loop) ---

func bubble_amounts(building_id: String) -> Dictionary:
	return pending_collect.get(building_id, {}).duplicate()

func bubble_total(building_id: String) -> float:
	var total := 0.0
	for v in bubble_amounts(building_id).values():
		total += float(v)
	return total

func has_any_bubbles() -> bool:
	for building_id in pending_collect.keys():
		if bubble_total(building_id) >= 1.0:
			return true
	return false

func collect_from_building(building_id: String) -> Dictionary:
	if not pending_collect.has(building_id):
		return {}
	var amounts: Dictionary = pending_collect[building_id].duplicate()
	if amounts.is_empty():
		return {}
	var gained := {}
	for key in amounts.keys():
		var amt := float(amounts[key])
		if amt < 0.5:
			continue
		var applied := _add_resource(str(key), amt)
		if applied > 0.0:
			gained[key] = applied
			total_collected[key] = float(total_collected.get(key, 0.0)) + applied
	pending_collect[building_id] = {}
	if not gained.is_empty():
		collect_count += 1
		stats["collects"] = collect_count
		resources_collected.emit(building_id, gained)
		_check_goals()
		changed.emit()
	return gained

func collect_all() -> Dictionary:
	var total := {}
	for building_id in buildings.keys():
		var gained := collect_from_building(building_id)
		for key in gained.keys():
			total[key] = float(total.get(key, 0.0)) + float(gained[key])
	return total

func storage_capacity(resource_name: String) -> float:
	var caps := {
		"food": 220.0, "wood": 220.0, "water": 200.0, "tools": 60.0,
		"seed": 80.0, "coal": 80.0, "iron": 40.0,
	}
	var base: float = float(caps.get(resource_name, 100.0))
	if is_building_operational("warehouse"):
		var lvl := float(buildings["warehouse"]["level"])
		var workers := float(buildings["warehouse"]["workers"])
		var bonus := 1.0 + lvl * 0.22 + workers * 0.08
		if bool(buildings["warehouse"].get("organized", false)):
			bonus += 0.15
			buildings["warehouse"]["organized"] = false
		base *= bonus
	return base

# --- Survivors ---

func survivor_list() -> Array:
	return survivors.duplicate(true)

func idle_survivor_count() -> int:
	var n := 0
	for s in survivors:
		if str(s.get("building_id", "")) == "" and float(s.get("health", 100.0)) >= 25.0:
			n += 1
	return n

func sick_survivor_count() -> int:
	var n := 0
	for s in survivors:
		if float(s.get("health", 100.0)) < 50.0:
			n += 1
	return n

func assign_survivor(survivor_id: int, building_id: String) -> void:
	if game_over:
		return
	if building_id != "" and not is_building_operational(building_id):
		return
	var target_idx := -1
	for i in survivors.size():
		if int(survivors[i]["id"]) == survivor_id:
			target_idx = i
			break
	if target_idx < 0:
		return
	var s: Dictionary = survivors[target_idx]
	if float(s.get("health", 100.0)) < 25.0 and building_id != "":
		_add_event("%s is too sick to work." % s["name"])
		changed.emit()
		return

	var old_b := str(s.get("building_id", ""))
	if old_b != "" and buildings.has(old_b):
		buildings[old_b]["workers"] = maxi(0, int(buildings[old_b]["workers"]) - 1)

	if building_id != "":
		var b: Dictionary = buildings[building_id]
		if int(b["workers"]) >= int(b["max_workers"]):
			_add_event("%s is fully staffed." % b["name"])
			changed.emit()
			return
		b["workers"] = int(b["workers"]) + 1
		buildings[building_id] = b
		s["building_id"] = building_id
		s["role"] = building_name(building_id)
	else:
		s["building_id"] = ""
		s["role"] = "Idle"

	survivors[target_idx] = s
	_recalculate_workers()
	_check_goals()
	changed.emit()

# --- World actions ---

func send_expedition() -> void:
	if game_over:
		return
	if expedition_cooldown > 0.0:
		_add_event("Expedition recovering (%.0fs)." % expedition_cooldown)
		changed.emit()
		return
	if available_workers < 2 or resources["food"] < 14.0 or resources["wood"] < 8.0:
		_add_event("Expedition needs 2 idle survivors, 14 food, 8 wood.")
		changed.emit()
		return
	resources["food"] -= 14.0
	resources["wood"] -= 8.0
	expedition_cooldown = 35.0

	var roll := randi_range(0, 5)
	match roll:
		0, 1:
			_add_resource("food", float(randi_range(22, 48)))
			_add_resource("seed", float(randi_range(3, 12)))
			morale = clampf(morale + 2.0, 0.0, 100.0)
			_add_event("Foragers return with food and seed.")
		2:
			_add_resource("coal", float(randi_range(4, 10)))
			_add_resource("iron", float(randi_range(1, 4)))
			_add_event("Scouts found a coal seam and scrap iron.")
		3:
			_add_resource("wood", float(randi_range(18, 36)))
			_add_resource("tools", float(randi_range(1, 3)))
			_add_event("Timber trail haul succeeded.")
		4:
			heat = clampf(heat - 5.0, 0.0, 100.0)
			morale = clampf(morale - 4.0, 0.0, 100.0)
			_add_event("Expedition nearly lost to whiteout winds.")
		5:
			_add_resource("food", float(randi_range(12, 24)))
			if homesteaders < MAX_SURVIVORS and randf() < 0.4:
				_add_survivor_person()
				_add_event("A survivor joined the city from the ice road.")
			else:
				_add_event("Traders swapped supplies with the city.")
	_check_goals()
	changed.emit()

func repair_hearth() -> void:
	## Compatibility alias — stoke with wood.
	if resources["wood"] < 15.0:
		_add_event("Need 15 wood to repair/stoke the furnace.")
		changed.emit()
		return
	resources["wood"] -= 15.0
	furnace_fuel = minf(100.0, furnace_fuel + 20.0)
	heat = clampf(heat + 18.0, 0.0, 100.0)
	morale = clampf(morale + 2.0, 0.0, 100.0)
	_add_event("Furnace repaired and stoked.")
	_check_goals()
	changed.emit()

func scout_site(site_id: String, reward: Dictionary, message: String) -> void:
	if game_over:
		return
	if scouted_sites.has(site_id):
		_add_event("Already surveyed. Marker remains.")
		changed.emit()
		return
	scouted_sites[site_id] = true
	for key in reward.keys():
		_apply_reward(str(key), float(reward[key]))
	_add_event("%s Reward: %s." % [message, _format_reward(reward)])
	_check_goals()
	changed.emit()

func resolve_choice(option_id: String) -> void:
	if pending_choice.is_empty():
		return
	var options: Array = pending_choice.get("options", [])
	pending_choice.clear()
	for option in options:
		if str(option.get("id", "")) != option_id:
			continue
		var effects: Dictionary = option.get("effects", {})
		for key in effects.keys():
			_apply_choice_effect(str(key), float(effects[key]))
		_add_event(str(option.get("result", "Decision locked in.")))
		break
	_check_goals()
	changed.emit()

func survival_goals() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for goal in SURVIVAL_GOALS:
		if int(goal["chapter"]) > current_chapter:
			continue
		var entry: Dictionary = goal.duplicate(true)
		entry["complete"] = completed_goals.has(goal["id"])
		entry["progress"] = _goal_progress(goal["id"])
		entry["active"] = int(goal["chapter"]) == current_chapter and not completed_goals.has(goal["id"])
		entry["chapter_title"] = CHAPTER_TITLES.get(int(goal["chapter"]), "Chapter")
		result.append(entry)
	return result

func active_missions() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for goal in survival_goals():
		if bool(goal.get("active", false)) and not bool(goal.get("complete", false)):
			result.append(goal)
	return result

func chapter_title() -> String:
	return CHAPTER_TITLES.get(current_chapter, "Chapter %s" % current_chapter)

func settlement_power() -> int:
	var score := 0
	for building_id in buildings.keys():
		if not is_building_operational(building_id):
			continue
		var b: Dictionary = buildings[building_id]
		score += int(b["level"]) * 14
		score += int(float(b["condition"]) / 10.0)
		score += int(b["workers"]) * 4
	score += int(morale / 7.0)
	score += int(heat / 7.0)
	score += homesteaders * 2
	score += int(furnace_fuel / 10.0)
	return score

func storm_pressure() -> int:
	var pressure := 12 + day * 2 + int(maxf(0.0, 70.0 - heat) * 0.8)
	if storm_active_days > 0:
		pressure += 25
	if season == "Deep Winter":
		pressure += 14
	elif season == "Late Winter":
		pressure += 8
	var days_to := next_storm_day - day
	if days_to >= 0 and days_to <= 2:
		pressure += 10
	return clampi(pressure, 0, 100)

func days_until_storm() -> int:
	return next_storm_day - day

func add_log(message: String) -> void:
	_add_event(message)
	changed.emit()

func end_summary() -> String:
	return "Day %s · Power %s · People %s · Collects %s · Chapter %s" % [
		total_days_survived, peak_power, homesteaders, collect_count, current_chapter,
	]

# --- Save / Load ---

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game() -> bool:
	if game_over:
		return false
	save_timestamp = int(Time.get_unix_time_from_system())
	var data := {
		"version": SAVE_VERSION,
		"day": day, "season": season, "seconds_until_day": seconds_until_day,
		"homesteaders": homesteaders, "morale": morale, "heat": heat,
		"furnace_fuel": furnace_fuel, "resources": resources.duplicate(true),
		"buildings": buildings.duplicate(true), "survivors": survivors.duplicate(true),
		"pending_collect": pending_collect.duplicate(true),
		"event_log": event_log.duplicate(), "completed_goals": completed_goals.duplicate(true),
		"scouted_sites": scouted_sites.duplicate(true), "current_chapter": current_chapter,
		"active_project": active_project.duplicate(true),
		"expedition_cooldown": expedition_cooldown, "days_without_shortage": days_without_shortage,
		"tutorial_index": tutorial_index, "tutorial_complete": tutorial_complete,
		"total_days_survived": total_days_survived, "peak_power": peak_power,
		"time_scale": time_scale, "paused": paused, "layout_data": layout_data.duplicate(true),
		"collect_count": collect_count, "survived_blizzard": survived_blizzard,
		"next_storm_day": next_storm_day, "storm_intensity": storm_intensity,
		"storm_active_days": storm_active_days, "save_timestamp": save_timestamp,
		"total_collected": total_collected.duplicate(true), "stats": stats.duplicate(true),
		"sfx_enabled": sfx_enabled, "_name_cursor": _name_cursor,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data))
	return true

func load_game() -> bool:
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var data: Dictionary = parsed
	day = int(data.get("day", 1))
	season = str(data.get("season", "Early Winter"))
	seconds_until_day = float(data.get("seconds_until_day", DAY_LENGTH))
	homesteaders = int(data.get("homesteaders", 8))
	morale = float(data.get("morale", 72.0))
	heat = float(data.get("heat", 68.0))
	furnace_fuel = float(data.get("furnace_fuel", 20.0))
	resources = data.get("resources", {}).duplicate(true)
	for k in RESOURCE_KEYS:
		if not resources.has(k):
			resources[k] = 0.0
	buildings = data.get("buildings", STARTING_BUILDINGS).duplicate(true)
	survivors = data.get("survivors", []).duplicate(true)
	pending_collect = data.get("pending_collect", {}).duplicate(true)
	event_log.clear()
	for e in data.get("event_log", []):
		event_log.append(str(e))
	completed_goals = data.get("completed_goals", {}).duplicate(true)
	scouted_sites = data.get("scouted_sites", {}).duplicate(true)
	current_chapter = int(data.get("current_chapter", 1))
	active_project = data.get("active_project", {}).duplicate(true)
	expedition_cooldown = float(data.get("expedition_cooldown", 0.0))
	days_without_shortage = int(data.get("days_without_shortage", 0))
	tutorial_index = int(data.get("tutorial_index", TUTORIAL_STEPS.size()))
	tutorial_complete = bool(data.get("tutorial_complete", true))
	total_days_survived = int(data.get("total_days_survived", day))
	peak_power = int(data.get("peak_power", settlement_power()))
	time_scale = float(data.get("time_scale", 1.0))
	paused = bool(data.get("paused", false))
	layout_data = data.get("layout_data", {}).duplicate(true)
	collect_count = int(data.get("collect_count", 0))
	survived_blizzard = bool(data.get("survived_blizzard", false))
	next_storm_day = int(data.get("next_storm_day", day + 4))
	storm_intensity = str(data.get("storm_intensity", "gale"))
	storm_active_days = int(data.get("storm_active_days", 0))
	total_collected = data.get("total_collected", {}).duplicate(true)
	stats = data.get("stats", stats).duplicate(true)
	sfx_enabled = bool(data.get("sfx_enabled", true))
	_name_cursor = int(data.get("_name_cursor", homesteaders))
	game_over = false
	victory = false
	pending_choice.clear()

	# Offline progress (cap 4 hours real time → partial sim)
	var old_ts := int(data.get("save_timestamp", 0))
	var now_ts := int(Time.get_unix_time_from_system())
	if old_ts > 0 and now_ts > old_ts:
		var offline := mini(now_ts - old_ts, 4 * 3600)
		var sim_seconds := float(offline) * 0.15  # 15% of real time as game time
		if sim_seconds > 2.0:
			var was_paused := paused
			paused = false
			var steps := int(sim_seconds)
			for _i in steps:
				tick(1.0)
			paused = was_paused
			_add_event("Offline progress applied (~%sm real time)." % int(offline / 60.0))

	if survivors.is_empty():
		_spawn_starting_survivors()
	_recalculate_workers()
	_add_event("City loaded — Day %s, %s." % [day, season])
	changed.emit()
	return true

func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)

# --- Internal simulation ---

func _tick_production(delta: float) -> bool:
	_prod_timer += delta
	if _prod_timer < 1.0:
		return false
	var steps := int(_prod_timer)
	_prod_timer -= float(steps)
	var changed_any := false
	for _s in steps:
		for building_id in buildings.keys():
			if not is_building_operational(building_id):
				continue
			var rates := _hourly_rates(building_id)
			# rates are per-day; convert to per-second of day length
			for res_name in rates.keys():
				var per_sec := float(rates[res_name]) / DAY_LENGTH
				if per_sec <= 0.0:
					continue
				if bubble_total(building_id) >= BUBBLE_SOFT_CAP:
					continue
				_add_to_bubble(building_id, str(res_name), per_sec)
				changed_any = true
	return changed_any

func _hourly_rates(building_id: String) -> Dictionary:
	if not is_building_operational(building_id):
		return {}
	var b: Dictionary = buildings[building_id]
	var workers := float(b["workers"])
	var level := float(b["level"])
	var cond := clampf(float(b["condition"]) / 100.0, 0.35, 1.0)
	var health_mult := _building_health_mult(building_id)
	var m := cond * health_mult
	match building_id:
		"cabin":
			return {"heat_gen": (level * 1.2 + workers * 0.35) * m}
		"woodlot":
			var rates := {"wood": (workers * 9.0 + (level - 1.0) * 3.5) * m}
			if level >= 3.0:
				rates["coal"] = (workers * 0.6 + level * 0.3) * m
			return rates
		"garden":
			return {
				"food": (workers * 7.5 + (level - 1.0) * 2.8) * m,
				"seed": (workers * 1.1 + (level - 1.0) * 0.4) * m,
			}
		"well":
			return {"water": (workers * 9.5 + (level - 1.0) * 2.6) * m}
		"hunter":
			return {"food": (workers * 8.5 + (level - 1.0) * 3.0) * m}
		"workshop":
			return {
				"tools": (workers * 1.4 + (level - 1.0) * 0.7) * m,
				"iron": (workers * 0.35 + (level - 1.0) * 0.2) * m,
			}
		"kitchen":
			return {"food": (workers * 2.5 + (level - 1.0) * 1.0) * m}
		"coop":
			return {"food": (workers * 4.0 + (level - 1.0) * 1.5) * m}
		"smokehouse":
			return {"food": (workers * 3.5 + (level - 1.0) * 1.4) * m}
		"root_cellar":
			return {"seed": (0.4 + workers * 0.3 + (level - 1.0) * 0.2) * m}
		"warehouse", "infirmary", "watchtower":
			return {}
	return {}

func _building_health_mult(building_id: String) -> float:
	var total := 0.0
	var count := 0
	for s in survivors:
		if str(s.get("building_id", "")) == building_id:
			total += clampf(float(s.get("health", 100.0)) / 100.0, 0.3, 1.0)
			count += 1
	if count == 0:
		return 1.0
	return total / float(count)

func _tick_furnace(delta: float) -> void:
	# Continuous fuel burn keeps heat
	var burn := delta * (0.35 + float(day) * 0.008)
	if storm_active_days > 0:
		burn *= 1.8
	if season == "Deep Winter":
		burn *= 1.25
	if furnace_fuel > 0.0:
		var used := minf(furnace_fuel, burn)
		furnace_fuel -= used
		heat = clampf(heat + used * 0.15 - burn * 0.05, 0.0, 100.0)
	else:
		heat = clampf(heat - burn * 1.4, 0.0, 100.0)

func _apply_daily_cycle() -> void:
	_update_storm_calendar()

	var cabin_level := int(buildings["cabin"]["level"]) if buildings.has("cabin") else 1
	var cabin_workers := int(buildings["cabin"]["workers"]) if is_building_operational("cabin") else 0
	var cold := 5.5 + float(day) * 0.18
	if season == "Deep Winter":
		cold += 3.5
	elif season == "Mid Winter":
		cold += 1.5
	if storm_active_days > 0:
		cold += 8.0
		_add_event("BLIZZARD DAY — furnace drain and wear are severe.")
	heat = clampf(heat - cold + cabin_level * 1.5 + cabin_workers * 0.5 + furnace_fuel * 0.04, 0.0, 100.0)

	# Auto-transfer some bubble production at day end if ignored? No — Whiteout forces collect.
	# Mild passive trickle so AFK isn't zero: 15% of bubbles auto-collect
	for building_id in pending_collect.keys():
		var bubble: Dictionary = pending_collect[building_id]
		var auto := {}
		for key in bubble.keys():
			var amt := float(bubble[key]) * 0.12
			if amt >= 0.5:
				auto[key] = amt
				bubble[key] = float(bubble[key]) - amt
		for key in auto.keys():
			_add_resource(str(key), float(auto[key]))
		pending_collect[building_id] = bubble

	var food_need := homesteaders * 1.9
	var water_need := homesteaders * 1.5
	var wood_need := 4.0 + maxf(0.0, 70.0 - heat) * 0.12
	if is_building_operational("kitchen"):
		food_need *= maxf(0.72, 1.0 - 0.06 * float(buildings["kitchen"]["level"]) - 0.03 * float(buildings["kitchen"]["workers"]))
	resources["food"] -= food_need
	resources["water"] -= water_need
	resources["wood"] -= wood_need

	# Spoilage
	var spoilage := maxf(0.0, resources["food"] * 0.035)
	if is_building_operational("root_cellar"):
		var cut := 0.14 + float(buildings["root_cellar"]["level"]) * 0.05 + float(buildings["root_cellar"]["workers"]) * 0.03
		if bool(buildings["root_cellar"].get("ice_packed", false)):
			cut += 0.1
			buildings["root_cellar"]["ice_packed"] = false
		spoilage *= maxf(0.12, 1.0 - cut)
	if is_building_operational("smokehouse"):
		spoilage *= maxf(0.4, 1.0 - 0.07 * float(buildings["smokehouse"]["level"]))
	if spoilage >= 1.0:
		resources["food"] = maxf(0.0, resources["food"] - spoilage)

	# Infirmary passive heal
	if is_building_operational("infirmary"):
		var heal := 6.0 + float(buildings["infirmary"]["workers"]) * 4.0 + float(buildings["infirmary"]["level"]) * 2.0
		_heal_survivors(heal)
	else:
		# Natural sickness risk in cold
		if heat < 40.0 or randf() < 0.12:
			_hurt_random_survivors(randf_range(4.0, 12.0))

	if is_building_operational("coop"):
		morale = clampf(morale + 0.5 + float(buildings["coop"]["workers"]) * 0.2, 0.0, 100.0)
	if is_building_operational("cabin"):
		morale = clampf(morale + 0.5 + float(buildings["cabin"]["workers"]) * 0.15, 0.0, 100.0)

	var shortages := 0
	for r in ["food", "water", "wood"]:
		if resources[r] < 0.0:
			shortages += 1
			resources[r] = 0.0
	if heat < 32.0:
		shortages += 1
		morale -= 9.0
		_hurt_random_survivors(8.0)
		_add_event("Dangerous cold — survivors suffer.")
	elif heat < 50.0:
		morale -= 3.0

	if shortages > 0:
		morale -= shortages * 4.0
		days_without_shortage = 0
	else:
		morale += 2.0
		days_without_shortage += 1

	if days_without_shortage >= 4 and homesteaders < MAX_SURVIVORS and resources["food"] >= 45.0 and morale >= 55.0:
		if randf() < 0.32:
			_add_survivor_person()
			resources["food"] -= 14.0
			_add_event("A new family seeks shelter. Population %s." % homesteaders)
			days_without_shortage = 0

	morale = clampf(morale, 0.0, 100.0)

	for building_id in buildings.keys():
		if not is_building_operational(building_id):
			continue
		var b: Dictionary = buildings[building_id]
		b["readiness"] = clampf(float(b["readiness"]) + 38.0 + float(b["workers"]) * 8.0, 0.0, 100.0)
		var wear := maxf(0.7, (72.0 - heat) * 0.03)
		if storm_active_days > 0:
			wear += 2.0
		b["condition"] = clampf(float(b["condition"]) - wear, 0.0, 100.0)
		buildings[building_id] = b

	_apply_daily_event()
	_clamp_all_resources()

	if storm_active_days > 0:
		storm_active_days -= 1
		if storm_active_days == 0:
			survived_blizzard = true
			stats["storms_survived"] = int(stats.get("storms_survived", 0)) + 1
			_add_event("The blizzard breaks. Frostfall still stands.")
			_check_goals()

	if morale <= 0.0 or (resources["food"] <= 0.0 and resources["water"] <= 0.0 and resources["wood"] <= 0.0):
		_trigger_defeat("The city collapses under cold and shortage.")
	elif heat <= 0.0 and morale < 18.0:
		_trigger_defeat("The furnace dies. Frostfall freezes over.")

func _update_storm_calendar() -> void:
	if day == next_storm_day:
		storm_active_days = 2 if storm_intensity == "whiteout" else 1
		_add_event("STORM HITS: %s conditions engulf the city!" % storm_intensity.to_upper())
		# Schedule next
		next_storm_day = day + randi_range(4, 7)
		storm_intensity = "whiteout" if day >= 10 and randf() < 0.45 else "gale"
		if is_building_operational("watchtower"):
			next_storm_day += int(buildings["watchtower"]["level"])
	elif next_storm_day - day == 2 or next_storm_day - day == 1:
		var left := next_storm_day - day
		storm_warning.emit(left, storm_intensity)
		_add_event("Storm warning: %s in %s day(s)." % [storm_intensity, left])

func _tick_active_project(delta: float) -> bool:
	if active_project.is_empty():
		return false
	active_project["remaining"] = maxf(0.0, float(active_project["remaining"]) - delta)
	_project_refresh_timer -= delta
	if float(active_project["remaining"]) > 0.0:
		if _project_refresh_timer <= 0.0:
			_project_refresh_timer = 0.4
			return true
		return false
	_finish_active_project()
	return true

func _finish_active_project() -> void:
	var project := active_project.duplicate(true)
	active_project.clear()
	var building_id: String = project["building_id"]
	if not buildings.has(building_id):
		return
	if project["type"] == "build":
		buildings[building_id]["under_construction"] = false
		buildings[building_id]["readiness"] = 45.0
		buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 6.0, 0.0, 100.0)
		pending_collect[building_id] = {}
		stats["buildings_built"] = int(stats.get("buildings_built", 0)) + 1
		_add_event("%s is online." % buildings[building_id]["name"])
	elif project["type"] == "upgrade":
		buildings[building_id]["level"] = int(project["target_level"])
		buildings[building_id]["max_workers"] = int(buildings[building_id]["max_workers"]) + 1
		buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) + 14.0, 0.0, 100.0)
		_add_event("%s reached level %s." % [buildings[building_id]["name"], buildings[building_id]["level"]])
	_recalculate_workers()
	_check_goals()

func _spawn_starting_survivors() -> void:
	survivors.clear()
	for i in homesteaders:
		var s := _make_survivor(i)
		if i < 2:
			s["building_id"] = "cabin"
			s["role"] = "Furnace Hall"
		survivors.append(s)
	_name_cursor = homesteaders

func _make_survivor(id: int) -> Dictionary:
	var person_name: String = str(SURVIVOR_NAMES[id % SURVIVOR_NAMES.size()])
	if id >= SURVIVOR_NAMES.size():
		person_name = "%s %s" % [person_name, 1 + int(id / SURVIVOR_NAMES.size())]
	return {
		"id": id,
		"name": person_name,
		"role": "Idle",
		"building_id": "",
		"health": randf_range(78.0, 100.0),
		"happiness": randf_range(60.0, 90.0),
	}

func _add_survivor_person() -> void:
	if homesteaders >= MAX_SURVIVORS:
		return
	var s := _make_survivor(_name_cursor)
	_name_cursor += 1
	survivors.append(s)
	homesteaders = survivors.size()
	_recalculate_workers()

func _assign_survivors_to(building_id: String, count: int) -> void:
	var left := count
	for i in survivors.size():
		if left <= 0:
			break
		var s: Dictionary = survivors[i]
		if str(s.get("building_id", "")) == "" and float(s.get("health", 100.0)) >= 25.0:
			s["building_id"] = building_id
			s["role"] = building_name(building_id)
			survivors[i] = s
			left -= 1

func _unassign_survivors_from(building_id: String, count: int) -> void:
	var left := count
	for i in range(survivors.size() - 1, -1, -1):
		if left <= 0:
			break
		var s: Dictionary = survivors[i]
		if str(s.get("building_id", "")) == building_id:
			s["building_id"] = ""
			s["role"] = "Idle"
			survivors[i] = s
			left -= 1

func _heal_survivors(amount: float) -> void:
	for i in survivors.size():
		var s: Dictionary = survivors[i]
		s["health"] = clampf(float(s["health"]) + amount, 0.0, 100.0)
		survivors[i] = s

func _hurt_random_survivors(amount: float) -> void:
	if survivors.is_empty():
		return
	var count := mini(2, survivors.size())
	for _i in count:
		var idx := randi_range(0, survivors.size() - 1)
		var s: Dictionary = survivors[idx]
		s["health"] = clampf(float(s["health"]) - amount, 5.0, 100.0)
		survivors[idx] = s

func _recalculate_workers() -> void:
	# Sync worker counts from survivors for consistency
	var counts := {}
	for s in survivors:
		var bid := str(s.get("building_id", ""))
		if bid == "":
			continue
		counts[bid] = int(counts.get(bid, 0)) + 1
	for building_id in buildings.keys():
		if bool(buildings[building_id].get("under_construction", false)):
			buildings[building_id]["workers"] = 0
		elif counts.has(building_id):
			buildings[building_id]["workers"] = mini(int(counts[building_id]), int(buildings[building_id]["max_workers"]))
		else:
			# Keep manual worker counts if no survivor data mismatch
			pass
	var assigned := 0
	for building_id in buildings.keys():
		if not bool(buildings[building_id].get("under_construction", false)):
			assigned += int(buildings[building_id]["workers"])
	homesteaders = maxi(homesteaders, survivors.size())
	available_workers = maxi(0, homesteaders - assigned)

func _add_to_bubble(building_id: String, resource_name: String, amount: float) -> void:
	if amount <= 0.0:
		return
	if not pending_collect.has(building_id):
		pending_collect[building_id] = {}
	var bubble: Dictionary = pending_collect[building_id]
	var cur := float(bubble.get(resource_name, 0.0))
	var room := BUBBLE_SOFT_CAP - bubble_total(building_id)
	if room <= 0.0:
		return
	bubble[resource_name] = cur + minf(amount, room)
	pending_collect[building_id] = bubble

func _add_resource(resource_name: String, amount: float) -> float:
	if amount <= 0.0:
		return 0.0
	if resource_name == "morale":
		morale = clampf(morale + amount, 0.0, 100.0)
		return amount
	if resource_name == "heat":
		heat = clampf(heat + amount, 0.0, 100.0)
		return amount
	if not resources.has(resource_name):
		return 0.0
	var cap := storage_capacity(resource_name)
	var space := maxf(0.0, cap - float(resources[resource_name]))
	var applied := minf(amount, space)
	resources[resource_name] = float(resources[resource_name]) + applied
	return applied

func _clamp_all_resources() -> void:
	for key in resources.keys():
		var cap := storage_capacity(str(key))
		if float(resources[key]) > cap:
			resources[key] = cap

func _can_afford(cost: Dictionary) -> bool:
	for k in cost.keys():
		if float(cost[k]) <= 0.0:
			continue
		if float(resources.get(k, 0.0)) < float(cost[k]):
			return false
	return true

func _pay_cost(cost: Dictionary) -> void:
	for k in cost.keys():
		if resources.has(k):
			resources[k] = maxf(0.0, float(resources[k]) - float(cost[k]))

func _project_seconds_for(building_id: String) -> int:
	if str(active_project.get("building_id", "")) != building_id:
		return 0
	return ceili(float(active_project.get("remaining", 0.0)))

func _weakest_building_id() -> String:
	var best := "cabin"
	var lowest := 101.0
	for building_id in buildings.keys():
		if not is_building_operational(building_id):
			continue
		var c := float(buildings[building_id]["condition"])
		if c < lowest:
			lowest = c
			best = building_id
	return best

func _action_name(building_id: String, action_id: String) -> String:
	for a in building_actions(building_id):
		if a["id"] == action_id:
			return a["name"]
	return "Order"

func _add_event(message: String) -> void:
	event_log.push_front(message)
	if event_log.size() > 16:
		event_log.pop_back()
	event_added.emit(message)

func _emit_tutorial() -> void:
	if tutorial_complete or tutorial_index >= TUTORIAL_STEPS.size():
		return
	var step: Dictionary = TUTORIAL_STEPS[tutorial_index]
	tutorial_step.emit(tutorial_index, str(step["title"]), str(step["body"]))
	paused = true

func _update_season() -> void:
	if day <= 4:
		season = "Early Winter"
	elif day <= 9:
		season = "Mid Winter"
	elif day <= 15:
		season = "Deep Winter"
	else:
		season = "Late Winter"

func _scale_label() -> String:
	if fmod(time_scale, 1.0) == 0.0:
		return str(int(time_scale))
	return str(time_scale)

func _check_goals() -> void:
	for goal in SURVIVAL_GOALS:
		if int(goal["chapter"]) > current_chapter:
			continue
		var gid: String = goal["id"]
		if completed_goals.has(gid) or not _goal_complete(gid):
			continue
		completed_goals[gid] = true
		var reward: Dictionary = goal["reward"]
		for key in reward.keys():
			_apply_reward(str(key), float(reward[key]))
		_add_event("Mission complete: %s (+%s)" % [goal["title"], _format_reward(reward)])
		toast.emit("Mission: %s" % goal["title"])
	_advance_chapter_if_ready()

func _advance_chapter_if_ready() -> void:
	for goal in SURVIVAL_GOALS:
		if int(goal["chapter"]) != current_chapter:
			continue
		if not completed_goals.has(goal["id"]):
			return
	current_chapter += 1
	if CHAPTER_TITLES.has(current_chapter):
		_add_event("%s unlocked!" % chapter_title())
		toast.emit(chapter_title())
	else:
		current_chapter -= 1

func _check_victory() -> void:
	if game_over:
		return
	var ch5 := true
	for goal in SURVIVAL_GOALS:
		if int(goal["chapter"]) != 5:
			continue
		if not completed_goals.has(goal["id"]):
			ch5 = false
			break
	if ch5 and day >= 14 and settlement_power() >= 180:
		victory = true
		game_over = true
		paused = true
		_add_event("VICTORY — Frostfall is whiteout-proof.")
		game_ended.emit(true, end_summary())

func _trigger_defeat(message: String) -> void:
	if game_over:
		return
	game_over = true
	victory = false
	paused = true
	_add_event(message)
	game_ended.emit(false, end_summary())

func _goal_complete(goal_id: String) -> bool:
	match goal_id:
		"build_woodlot":
			return is_building_operational("woodlot")
		"assign_woodlot":
			return is_building_operational("woodlot") and int(buildings["woodlot"]["workers"]) >= 2
		"collect_resources":
			return collect_count >= 5
		"stoke_furnace":
			return heat >= 75.0
		"build_garden":
			return is_building_operational("garden")
		"build_well":
			return is_building_operational("well")
		"build_hunter":
			return is_building_operational("hunter")
		"build_kitchen":
			return is_building_operational("kitchen")
		"build_warehouse":
			return is_building_operational("warehouse")
		"build_workshop":
			return is_building_operational("workshop")
		"build_infirmary":
			return is_building_operational("infirmary")
		"build_watchtower":
			return is_building_operational("watchtower")
		"homestead_l2":
			return buildings.has("cabin") and int(buildings["cabin"]["level"]) >= 2
		"homestead_l3":
			return buildings.has("cabin") and int(buildings["cabin"]["level"]) >= 3
		"survive_week":
			return day >= 7 and morale >= 35.0
		"survive_fortnight":
			return day >= 14 and morale >= 40.0
		"population_12":
			return homesteaders >= 12
		"power_120":
			return settlement_power() >= 120
		"power_180":
			return settlement_power() >= 180
		"survive_blizzard":
			return survived_blizzard
	return false

func _goal_progress(goal_id: String) -> String:
	match goal_id:
		"build_woodlot":
			return "Done" if is_building_operational("woodlot") else "Not built"
		"assign_woodlot":
			return "%s/2" % (int(buildings["woodlot"]["workers"]) if buildings.has("woodlot") else 0)
		"collect_resources":
			return "%s/5 collects" % collect_count
		"stoke_furnace":
			return "%s/75 heat" % int(heat)
		"build_garden":
			return "Done" if is_building_operational("garden") else "Not built"
		"build_well":
			return "Done" if is_building_operational("well") else "Not built"
		"build_hunter":
			return "Done" if is_building_operational("hunter") else "Not built"
		"build_kitchen":
			return "Done" if is_building_operational("kitchen") else "Not built"
		"build_warehouse":
			return "Done" if is_building_operational("warehouse") else "Not built"
		"build_workshop":
			return "Done" if is_building_operational("workshop") else "Not built"
		"build_infirmary":
			return "Done" if is_building_operational("infirmary") else "Not built"
		"build_watchtower":
			return "Done" if is_building_operational("watchtower") else "Not built"
		"homestead_l2":
			return "L%s/2" % (int(buildings["cabin"]["level"]) if buildings.has("cabin") else 0)
		"homestead_l3":
			return "L%s/3" % (int(buildings["cabin"]["level"]) if buildings.has("cabin") else 0)
		"survive_week":
			return "Day %s/7 · Morale %s" % [day, int(morale)]
		"survive_fortnight":
			return "Day %s/14 · Morale %s" % [day, int(morale)]
		"population_12":
			return "%s/12" % homesteaders
		"power_120":
			return "%s/120" % settlement_power()
		"power_180":
			return "%s/180" % settlement_power()
		"survive_blizzard":
			return "Survived" if survived_blizzard else "Awaiting storm"
	return ""

func _apply_reward(resource_name: String, amount: float) -> void:
	_add_resource(resource_name, amount)

func _apply_choice_effect(key: String, amount: float) -> void:
	match key:
		"morale":
			morale = clampf(morale + amount, 0.0, 100.0)
		"heat":
			heat = clampf(heat + amount, 0.0, 100.0)
		"furnace_fuel":
			furnace_fuel = clampf(furnace_fuel + amount, 0.0, 100.0)
		"homesteaders":
			if amount > 0:
				for _i in int(amount):
					_add_survivor_person()
			else:
				homesteaders = clampi(homesteaders + int(amount), 1, MAX_SURVIVORS)
		_:
			if resources.has(key):
				if amount >= 0:
					_add_resource(key, amount)
				else:
					resources[key] = maxf(0.0, float(resources[key]) + amount)

func _format_reward(reward: Dictionary) -> String:
	var parts: Array[String] = []
	for key in reward.keys():
		parts.append("+%s %s" % [int(reward[key]), key])
	return ", ".join(parts)

func _apply_daily_event() -> void:
	if day == 3 and pending_choice.is_empty():
		_request_choice("strangers", "Refugees at the Gate",
			"Frozen travelers beg for a place by the furnace. Food is scarce.",
			[
				{"id": "shelter", "label": "Take them in", "result": "New hands join. Rations drop.", "effects": {"food": -16, "morale": 7, "homesteaders": 1}},
				{"id": "share", "label": "Share a meal only", "result": "They leave tools in thanks.", "effects": {"food": -8, "tools": 2, "morale": 2}},
				{"id": "deny", "label": "Bar the gate", "result": "Wood is saved. Hearts harden.", "effects": {"wood": 8, "morale": -5}},
			])
		return
	if day == 6 and pending_choice.is_empty():
		_request_choice("fuel", "Furnace Crisis",
			"Coal is low and the wind is rising. How do you keep the city warm?",
			[
				{"id": "burn_wood", "label": "Burn timber freely", "result": "Heat surges. Forests thin.", "effects": {"wood": -28, "heat": 20, "furnace_fuel": 25}},
				{"id": "ration_heat", "label": "Ration warmth", "result": "Families shiver but stores hold.", "effects": {"heat": 6, "morale": -4, "wood": -6}},
				{"id": "mine_push", "label": "Force a coal push", "result": "Dangerous dig yields coal.", "effects": {"coal": 14, "morale": -2, "tools": -1}},
			])
		return
	if day == 9 and pending_choice.is_empty():
		_request_choice("blizzard_prep", "Whiteout Incoming",
			"The watch reports a multi-day whiteout. Prepare now.",
			[
				{"id": "stoke", "label": "Max the furnace", "result": "Fuel burned for a heat cushion.", "effects": {"wood": -20, "coal": -6, "heat": 22, "furnace_fuel": 30}},
				{"id": "feast", "label": "Pre-storm feast", "result": "Morale spikes. Food burns.", "effects": {"food": -24, "morale": 12, "heat": 4}},
				{"id": "brace", "label": "Brace every roof", "result": "Buildings hold firmer.", "effects": {"wood": -16, "tools": -2, "morale": 3}},
			])
		return
	if day == 12 and pending_choice.is_empty():
		_request_choice("trader", "Ice Road Caravan",
			"A lantern-lit trader offers one bargain.",
			[
				{"id": "tools", "label": "Buy tools & iron", "result": "Workshop stocked.", "effects": {"wood": -22, "tools": 8, "iron": 4}},
				{"id": "coal", "label": "Buy coal", "result": "Furnace stockpile secured.", "effects": {"food": -14, "coal": 16}},
				{"id": "pass", "label": "Wave them on", "result": "You keep the stores tight.", "effects": {"morale": 1}},
			])
		return

	if day < 2 or randi_range(1, 100) > 40:
		return
	match randi_range(0, 6):
		0:
			_add_resource("food", float(randi_range(10, 22)))
			_add_event("Buried cache discovered near the trail.")
		1:
			for building_id in buildings.keys():
				if is_building_operational(building_id):
					buildings[building_id]["condition"] = clampf(float(buildings[building_id]["condition"]) - randf_range(3.0, 7.0), 0.0, 100.0)
			_add_event("Knife-wind shears roofs across the city.")
		2:
			_add_resource("tools", float(randi_range(2, 4)))
			_add_event("A peddler left spare tools.")
		3:
			heat = clampf(heat - 6.0, 0.0, 100.0)
			_add_event("Night squall steals furnace heat.")
		4:
			morale = clampf(morale + 5.0, 0.0, 100.0)
			_add_event("Hall songs lift the city.")
		5:
			_hurt_random_survivors(10.0)
			_add_event("Winter cough spreads among the bunks.")
		6:
			_add_resource("coal", float(randi_range(3, 7)))
			_add_event("Kids found coal fragments in the drift.")

func _request_choice(event_id: String, title: String, body: String, options: Array) -> void:
	pending_choice = {"id": event_id, "title": title, "body": body, "options": options}
	paused = true
	choice_requested.emit(event_id, title, body, options)
	changed.emit()
