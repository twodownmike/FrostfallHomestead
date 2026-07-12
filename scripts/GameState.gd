extends RefCounted
class_name GameState

signal changed
signal event_added(message: String)
signal choice_requested(event_id: String, title: String, body: String, options: Array)
signal game_ended(victory: bool, summary: String)
signal tutorial_step(step: int, title: String, body: String)

const SAVE_PATH := "user://frostfall_save.json"
const DAY_LENGTH := 20.0
const BUILDING_ORDER := [
	"cabin", "woodlot", "garden", "well", "workshop", "root_cellar", "smokehouse", "coop",
]
const BUILDING_BLUEPRINTS := {
	"cabin": {"name": "Homestead", "level": 1, "workers": 2, "max_workers": 4, "condition": 84.0, "readiness": 45.0},
	"woodlot": {"name": "Woodlot", "level": 1, "workers": 0, "max_workers": 5, "condition": 72.0, "readiness": 20.0},
	"garden": {"name": "Kitchen Garden", "level": 1, "workers": 0, "max_workers": 5, "condition": 68.0, "readiness": 20.0},
	"well": {"name": "Well House", "level": 1, "workers": 0, "max_workers": 3, "condition": 75.0, "readiness": 20.0},
	"workshop": {"name": "Workshop", "level": 1, "workers": 0, "max_workers": 4, "condition": 70.0, "readiness": 20.0},
	"root_cellar": {"name": "Root Cellar", "level": 1, "workers": 0, "max_workers": 2, "condition": 80.0, "readiness": 20.0},
	"smokehouse": {"name": "Smokehouse", "level": 1, "workers": 0, "max_workers": 3, "condition": 74.0, "readiness": 20.0},
	"coop": {"name": "Chicken Coop", "level": 1, "workers": 0, "max_workers": 3, "condition": 76.0, "readiness": 20.0},
}
const STARTING_BUILDINGS := {
	"cabin": {"name": "Homestead", "level": 1, "workers": 2, "max_workers": 4, "condition": 84.0, "readiness": 45.0},
}
const BUILD_COSTS := {
	"woodlot": {"wood": 32, "tools": 2, "seed": 0},
	"garden": {"wood": 24, "tools": 2, "seed": 6},
	"well": {"wood": 38, "tools": 4, "seed": 0},
	"workshop": {"wood": 50, "tools": 7, "seed": 0},
	"root_cellar": {"wood": 40, "tools": 4, "seed": 4},
	"smokehouse": {"wood": 45, "tools": 5, "seed": 0},
	"coop": {"wood": 30, "tools": 3, "seed": 8},
}
const BUILDING_UNLOCKS := {
	"woodlot": {"building": "cabin", "level": 1, "label": "Homestead L1"},
	"garden": {"building": "cabin", "level": 1, "label": "Homestead L1"},
	"well": {"building": "cabin", "level": 2, "label": "Homestead L2"},
	"workshop": {"building": "cabin", "level": 2, "label": "Homestead L2"},
	"root_cellar": {"building": "garden", "level": 1, "label": "Kitchen Garden"},
	"smokehouse": {"building": "woodlot", "level": 2, "label": "Woodlot L2"},
	"coop": {"building": "garden", "level": 2, "label": "Kitchen Garden L2"},
}
const BUILD_DURATION := {
	"woodlot": 14.0,
	"garden": 16.0,
	"well": 22.0,
	"workshop": 28.0,
	"root_cellar": 24.0,
	"smokehouse": 26.0,
	"coop": 18.0,
}
const SURVIVAL_GOALS := [
	{"id": "build_woodlot", "chapter": 1, "title": "Raise a Woodlot", "detail": "Build a Woodlot to secure fuel.", "reward": {"wood": 18, "morale": 3}},
	{"id": "assign_woodlot", "chapter": 1, "title": "Put Axes to Work", "detail": "Assign 2 workers to the Woodlot.", "reward": {"wood": 16}},
	{"id": "stockpile_heat", "chapter": 1, "title": "Hold the Hearth", "detail": "Reach 80 heat.", "reward": {"morale": 5, "heat": 5}},
	{"id": "homestead_l2", "chapter": 2, "title": "Strengthen the Hall", "detail": "Upgrade the Homestead to level 2.", "reward": {"wood": 20, "tools": 2}},
	{"id": "build_garden", "chapter": 2, "title": "Plant Winter Beds", "detail": "Build a Kitchen Garden for food and seed.", "reward": {"food": 20, "seed": 6}},
	{"id": "build_well", "chapter": 2, "title": "Break Groundwater", "detail": "Build a Well House before water runs thin.", "reward": {"water": 28, "morale": 3}},
	{"id": "build_cellar", "chapter": 2, "title": "Store the Harvest", "detail": "Build a Root Cellar to cut food spoilage.", "reward": {"food": 24, "morale": 2}},
	{"id": "homestead_l3", "chapter": 3, "title": "A Real Settlement", "detail": "Upgrade the Homestead to level 3.", "reward": {"tools": 4, "morale": 4}},
	{"id": "build_workshop", "chapter": 3, "title": "Open the Workshop", "detail": "Build a Workshop to craft tools.", "reward": {"tools": 6}},
	{"id": "build_smokehouse", "chapter": 3, "title": "Smoke and Salt", "detail": "Build a Smokehouse for preserved meat.", "reward": {"food": 30}},
	{"id": "survive_week", "chapter": 3, "title": "Survive the First Week", "detail": "Reach day 7 with morale above 35.", "reward": {"food": 30, "wood": 30, "morale": 8}},
	{"id": "build_coop", "chapter": 4, "title": "Feathers in Winter", "detail": "Build a Chicken Coop for eggs and morale.", "reward": {"food": 18, "morale": 4}},
	{"id": "power_100", "chapter": 4, "title": "Settlement Power 100", "detail": "Reach 100 settlement power.", "reward": {"tools": 8, "morale": 6}},
	{"id": "population_12", "chapter": 4, "title": "More Hands", "detail": "Grow the settlement to 12 homesteaders.", "reward": {"food": 40, "wood": 20}},
	{"id": "survive_fortnight", "chapter": 5, "title": "Hold Two Weeks", "detail": "Reach day 14 with morale above 40.", "reward": {"food": 40, "wood": 40, "tools": 4, "morale": 10}},
	{"id": "power_160", "chapter": 5, "title": "Valley Stronghold", "detail": "Reach 160 settlement power.", "reward": {"tools": 10, "morale": 8, "heat": 10}},
]
const CHAPTER_TITLES := {
	1: "Chapter 1: First Fire",
	2: "Chapter 2: Water and Seed",
	3: "Chapter 3: Working Settlement",
	4: "Chapter 4: Growing Roots",
	5: "Chapter 5: Stormproof Valley",
}
const BUILDING_DETAILS := {
	"cabin": {
		"role": "Main hall, shelter, warmth, family morale",
		"output": "Heat stability and morale",
		"risk": "A cold homestead drains morale fast.",
	},
	"woodlot": {
		"role": "Firewood, timber, trail scouting",
		"output": "Wood per day",
		"risk": "Low wood makes every cold night worse.",
	},
	"garden": {
		"role": "Food beds, seed saving, preservation",
		"output": "Food and seed per day",
		"risk": "Winter beds need attention to keep producing.",
	},
	"well": {
		"role": "Water, ice clearing, sanitation",
		"output": "Water per day",
		"risk": "Frozen water supply slows the whole homestead.",
	},
	"workshop": {
		"role": "Tools, repairs, building prep",
		"output": "Tools per day",
		"risk": "Broken tools block upgrades and field work.",
	},
	"root_cellar": {
		"role": "Cold storage that slows food spoilage",
		"output": "Less food loss + small seed reserve",
		"risk": "Without a cellar, winter spoilage hits hard.",
	},
	"smokehouse": {
		"role": "Preserve meat, stretch hunting yields",
		"output": "Food preservation bonus",
		"risk": "Wet wood and bad smoke waste hard-won meat.",
	},
	"coop": {
		"role": "Eggs, feathers, quiet winter work",
		"output": "Food and morale per day",
		"risk": "Foxes and freezes empty the roost.",
	},
}
const TUTORIAL_STEPS := [
	{"title": "Welcome to Frostfall", "body": "Winter is coming hard. Keep food, water, wood, heat, and morale above zero to survive."},
	{"title": "Assign Workers", "body": "Open Build, then use + / - on each building to assign idle families. Production needs hands."},
	{"title": "Build and Place", "body": "Tap Build, pick a structure, then place it on an open snow plot. Construction takes real time."},
	{"title": "Orders and Readiness", "body": "Select a building to issue orders. Readiness recovers each day — READY badges mean an order is available."},
	{"title": "Landmarks and Speed", "body": "Scout map landmarks once for rewards. Use pause and speed controls when planning. Good luck, steward."},
]

var day := 1
var season := "Early Winter"
var seconds_until_day := DAY_LENGTH
var homesteaders := 8
var available_workers := 0
var morale := 72.0
var heat := 62.0
var resources := {
	"food": 130.0,
	"wood": 95.0,
	"water": 85.0,
	"tools": 16.0,
	"seed": 24.0,
}
var buildings := {}
var event_log: Array[String] = []
var completed_goals := {}
var scouted_sites := {}
var current_chapter := 1
var active_project := {}
var _project_refresh_timer := 0.0
var game_over := false
var victory := false
var paused := false
var time_scale := 1.0
var expedition_cooldown := 0
var days_without_shortage := 0
var pending_choice := {}
var tutorial_index := 0
var tutorial_complete := false
var total_days_survived := 0
var peak_power := 0
var auto_save_day_marker := 0
var layout_data := {}

func _init() -> void:
	_reset_runtime_state()

func _reset_runtime_state() -> void:
	day = 1
	season = "Early Winter"
	seconds_until_day = DAY_LENGTH
	homesteaders = 8
	morale = 72.0
	heat = 62.0
	resources = {
		"food": 130.0,
		"wood": 95.0,
		"water": 85.0,
		"tools": 16.0,
		"seed": 24.0,
	}
	buildings = STARTING_BUILDINGS.duplicate(true)
	event_log.clear()
	completed_goals.clear()
	scouted_sites.clear()
	current_chapter = 1
	active_project.clear()
	_project_refresh_timer = 0.0
	game_over = false
	victory = false
	paused = false
	time_scale = 1.0
	expedition_cooldown = 0
	days_without_shortage = 0
	pending_choice.clear()
	tutorial_index = 0
	tutorial_complete = false
	total_days_survived = 0
	peak_power = 0
	auto_save_day_marker = 0
	layout_data = {}
	_recalculate_workers()
	_add_event("The first families arrive at Frostfall Homestead.")
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
	var project_changed := _tick_active_project(scaled)
	seconds_until_day -= scaled
	if seconds_until_day > 0.0:
		if project_changed:
			changed.emit()
		return

	seconds_until_day = DAY_LENGTH
	day += 1
	total_days_survived = day
	_update_season()
	_apply_daily_cycle()
	_check_goals()
	_check_victory()
	peak_power = maxi(peak_power, settlement_power())
	if day - auto_save_day_marker >= 2 and not game_over:
		auto_save_day_marker = day
		save_game()
	changed.emit()

func set_paused(value: bool) -> void:
	if game_over:
		return
	paused = value
	changed.emit()

func toggle_pause() -> void:
	set_paused(not paused)

func cycle_time_scale() -> void:
	match time_scale:
		0.5:
			time_scale = 1.0
		1.0:
			time_scale = 2.0
		2.0:
			time_scale = 3.0
		_:
			time_scale = 0.5
	var label := "%s" % time_scale
	if fmod(time_scale, 1.0) == 0.0:
		label = str(int(time_scale))
	_add_event("Time scale set to %sx." % label)
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
		_add_event("Tutorial complete. The valley is yours to hold.")
		paused = false
		changed.emit()
		return
	_emit_tutorial()
	changed.emit()

func skip_tutorial() -> void:
	tutorial_complete = true
	tutorial_index = TUTORIAL_STEPS.size()
	_add_event("Tutorial skipped.")
	changed.emit()

func can_upgrade(building_id: String) -> bool:
	if not is_building_operational(building_id) or project_in_progress() or game_over:
		return false
	var building: Dictionary = buildings[building_id]
	var level := int(building["level"])
	var cost := upgrade_cost(building_id)
	return resources["wood"] >= cost["wood"] and resources["tools"] >= cost["tools"] and level < 8

func upgrade_cost(building_id: String) -> Dictionary:
	if not buildings.has(building_id):
		return {"wood": 0, "tools": 0}
	var level := int(buildings[building_id]["level"])
	return {
		"wood": 24 + (level * 16),
		"tools": 2 + level,
	}

func upgrade(building_id: String) -> void:
	if game_over:
		return
	if not buildings.has(building_id):
		_add_event("Build that structure before upgrading it.")
		changed.emit()
		return
	if not is_building_operational(building_id):
		_add_event("%s must finish construction before upgrading." % buildings[building_id]["name"])
		changed.emit()
		return
	if project_in_progress():
		_add_event("Finish the active project first: %s." % project_status())
		changed.emit()
		return
	if not can_upgrade(building_id):
		_add_event("Not enough supplies to upgrade %s." % buildings[building_id]["name"])
		changed.emit()
		return

	var cost := upgrade_cost(building_id)
	resources["wood"] -= cost["wood"]
	resources["tools"] -= cost["tools"]
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
	_add_event("%s upgrade started. Crews need %ss." % [buildings[building_id]["name"], int(duration)])
	changed.emit()

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
	return "%s: %ss left" % [active_project["name"], ceili(float(active_project["remaining"]))]

func project_progress() -> float:
	if active_project.is_empty():
		return 0.0
	var duration := maxf(float(active_project.get("duration", 1.0)), 0.01)
	return clampf(1.0 - float(active_project["remaining"]) / duration, 0.0, 1.0)

func build_lock_reason(building_id: String) -> String:
	if not BUILDING_UNLOCKS.has(building_id):
		return ""
	var unlock: Dictionary = BUILDING_UNLOCKS[building_id]
	var required_building: String = unlock["building"]
	var required_level := int(unlock["level"])
	if not buildings.has(required_building):
		return "Requires %s" % unlock["label"]
	if int(buildings[required_building]["level"]) < required_level:
		return "Requires %s" % unlock["label"]
	return ""

func is_building_unlocked(building_id: String) -> bool:
	return build_lock_reason(building_id) == ""

func build_cost(building_id: String) -> Dictionary:
	return BUILD_COSTS.get(building_id, {})

func can_build(building_id: String) -> bool:
	if game_over or buildings.has(building_id) or project_in_progress() or not is_building_unlocked(building_id) or not BUILDING_BLUEPRINTS.has(building_id) or not BUILD_COSTS.has(building_id):
		return false

	var cost := build_cost(building_id)
	for resource_name in cost.keys():
		if resources.get(resource_name, 0.0) < float(cost[resource_name]):
			return false
	return true

func build(building_id: String) -> bool:
	if game_over:
		return false
	if buildings.has(building_id):
		_add_event("%s is already built." % BUILDING_BLUEPRINTS[building_id]["name"])
		changed.emit()
		return false
	if not is_building_unlocked(building_id):
		_add_event("%s is locked. %s." % [BUILDING_BLUEPRINTS[building_id]["name"], build_lock_reason(building_id)])
		changed.emit()
		return false
	if project_in_progress():
		_add_event("Finish the active project first: %s." % project_status())
		changed.emit()
		return false
	if not can_build(building_id):
		_add_event("Not enough supplies to build %s." % BUILDING_BLUEPRINTS[building_id]["name"])
		changed.emit()
		return false

	var cost := build_cost(building_id)
	for resource_name in cost.keys():
		resources[resource_name] -= float(cost[resource_name])

	var blueprint: Dictionary = BUILDING_BLUEPRINTS[building_id]
	buildings[building_id] = blueprint.duplicate(true)
	buildings[building_id]["under_construction"] = true
	buildings[building_id]["workers"] = 0
	var duration := build_duration(building_id)
	active_project = {
		"type": "build",
		"building_id": building_id,
		"name": String(buildings[building_id]["name"]),
		"remaining": duration,
		"duration": duration,
	}
	_project_refresh_timer = 0.0
	_add_event("%s construction started. Crews need %ss." % [buildings[building_id]["name"], int(duration)])
	_recalculate_workers()
	changed.emit()
	return true

func assign_worker(building_id: String, amount: int) -> void:
	if game_over or not is_building_operational(building_id):
		return
	var building: Dictionary = buildings[building_id]
	var current := int(building["workers"])
	var max_workers := int(building["max_workers"])
	if amount > 0:
		var can_add := mini(amount, available_workers)
		can_add = mini(can_add, max_workers - current)
		building["workers"] = current + can_add
	else:
		building["workers"] = maxi(0, current + amount)
	buildings[building_id] = building
	_recalculate_workers()
	_check_goals()
	changed.emit()

func send_expedition() -> void:
	if game_over:
		return
	if expedition_cooldown > 0:
		_add_event("Expedition crews need %s more day(s) to recover." % expedition_cooldown)
		changed.emit()
		return
	if available_workers < 2 or resources["food"] < 16.0 or resources["wood"] < 10.0:
		_add_event("An expedition needs 2 idle workers, 16 food, and 10 wood.")
		changed.emit()
		return

	resources["food"] -= 16.0
	resources["wood"] -= 10.0
	expedition_cooldown = 2

	var roll := randi_range(0, 5)
	match roll:
		0, 1:
			var food_found := randi_range(20, 48)
			var seed_found := randi_range(4, 14)
			resources["food"] += food_found
			resources["seed"] += seed_found
			morale = clampf(morale + 2.0, 0.0, 100.0)
			_add_event("Foragers returned with %s food and %s seed." % [food_found, seed_found])
		2:
			var tools_found := randi_range(2, 6)
			var wood_found := randi_range(12, 28)
			resources["tools"] += tools_found
			resources["wood"] += wood_found
			_add_event("Scouts salvaged %s tools and %s wood from a wrecked cart." % [tools_found, wood_found])
		3:
			var water_found := randi_range(18, 36)
			resources["water"] += water_found
			heat = clampf(heat + 4.0, 0.0, 100.0)
			_add_event("A warm spring pocket yielded %s water and a little heat." % water_found)
		4:
			morale = clampf(morale - 5.0, 0.0, 100.0)
			heat = clampf(heat - 4.0, 0.0, 100.0)
			_add_event("The expedition nearly froze on the ridge. Morale and heat slipped.")
		5:
			var food_found := randi_range(10, 22)
			var tools_found := randi_range(1, 3)
			resources["food"] += food_found
			resources["tools"] += tools_found
			if homesteaders < 16 and randf() < 0.35:
				homesteaders += 1
				_recalculate_workers()
				_add_event("A wandering family joined with %s food and %s tools." % [food_found, tools_found])
			else:
				_add_event("Traders swapped for %s food and %s tools." % [food_found, tools_found])

	_check_goals()
	changed.emit()

func repair_hearth() -> void:
	if game_over:
		return
	if resources["wood"] < 16.0 or resources["tools"] < 2.0:
		_add_event("The hearth repair needs 16 wood and 2 tools.")
		changed.emit()
		return

	resources["wood"] -= 16.0
	resources["tools"] -= 2.0
	heat = clampf(heat + 20.0, 0.0, 100.0)
	morale = clampf(morale + 3.0, 0.0, 100.0)
	_add_event("The hearth is burning steady again.")
	_check_goals()
	changed.emit()

func add_log(message: String) -> void:
	_add_event(message)
	changed.emit()

func building_details(building_id: String) -> Dictionary:
	return BUILDING_DETAILS.get(building_id, {
		"role": "Unknown structure",
		"output": "None",
		"risk": "Unknown risks.",
	})

func production_preview(building_id: String) -> Dictionary:
	if not is_building_operational(building_id):
		return {}
	match building_id:
		"cabin":
			return {
				"heat": float(buildings["cabin"]["level"]) * 1.4 + float(buildings["cabin"]["workers"]) * 0.4,
				"morale": 0.6 + float(buildings["cabin"]["workers"]) * 0.35,
			}
		"woodlot":
			return {"wood": _production_for("woodlot", 8.5, 3.2)}
		"garden":
			return {
				"food": _production_for("garden", 7.5, 2.8),
				"seed": _production_for("garden", 1.2, 0.45),
			}
		"well":
			return {"water": _production_for("well", 9.0, 2.4)}
		"workshop":
			return {"tools": _production_for("workshop", 1.5, 0.85)}
		"root_cellar":
			return {"spoilage_cut": 0.12 + float(buildings["root_cellar"]["level"]) * 0.06 + float(buildings["root_cellar"]["workers"]) * 0.03}
		"smokehouse":
			return {"food": _production_for("smokehouse", 4.5, 1.8)}
		"coop":
			return {
				"food": _production_for("coop", 3.8, 1.4),
				"morale": 0.4 + float(buildings["coop"]["workers"]) * 0.25 + float(buildings["coop"]["level"] - 1) * 0.2,
			}
	return {}

func building_actions(building_id: String) -> Array[Dictionary]:
	if not is_building_operational(building_id):
		return []
	match building_id:
		"cabin":
			return [
				{"id": "stoke", "name": "Stoke Hearth", "cost": "12 wood", "effect": "+14 heat, +2 morale"},
				{"id": "gather", "name": "Hall Council", "cost": "8 food", "effect": "+7 morale"},
			]
		"woodlot":
			return [
				{"id": "fell", "name": "Fell Timber", "cost": "1 idle worker", "effect": "+28 wood"},
				{"id": "snare", "name": "Set Snares", "cost": "4 wood", "effect": "+12 food"},
			]
		"garden":
			return [
				{"id": "cover", "name": "Cover Beds", "cost": "8 wood", "effect": "+18 food, +condition"},
				{"id": "save_seed", "name": "Save Seed", "cost": "10 food", "effect": "+16 seed"},
			]
		"well":
			return [
				{"id": "draw", "name": "Draw Water", "cost": "readiness", "effect": "+30 water"},
				{"id": "clear_ice", "name": "Clear Ice", "cost": "1 tool", "effect": "+condition, +water"},
			]
		"workshop":
			return [
				{"id": "craft", "name": "Craft Tools", "cost": "18 wood", "effect": "+5 tools"},
				{"id": "reinforce", "name": "Reinforce Weakest", "cost": "2 tools", "effect": "+condition to weakest building"},
			]
		"root_cellar":
			return [
				{"id": "sort_stores", "name": "Sort Stores", "cost": "readiness", "effect": "+12 food recovered"},
				{"id": "ice_pack", "name": "Pack Ice", "cost": "6 water", "effect": "+condition, less spoilage today"},
			]
		"smokehouse":
			return [
				{"id": "smoke_meat", "name": "Smoke Meat", "cost": "10 wood, 8 food", "effect": "+22 preserved food"},
				{"id": "render_fat", "name": "Render Fat", "cost": "6 food", "effect": "+heat, +morale"},
			]
		"coop":
			return [
				{"id": "collect_eggs", "name": "Collect Eggs", "cost": "readiness", "effect": "+14 food"},
				{"id": "mend_roost", "name": "Mend Roost", "cost": "6 wood", "effect": "+condition, +morale"},
			]
	return []

func can_perform_building_action(building_id: String, action_id: String) -> bool:
	if game_over or not is_building_operational(building_id):
		return false
	var building: Dictionary = buildings[building_id]
	if building["readiness"] < 20.0:
		return false

	match action_id:
		"stoke":
			return resources["wood"] >= 12.0
		"gather":
			return resources["food"] >= 8.0
		"fell":
			return available_workers >= 1
		"snare":
			return resources["wood"] >= 4.0
		"cover":
			return resources["wood"] >= 8.0
		"save_seed":
			return resources["food"] >= 10.0
		"draw":
			return true
		"clear_ice":
			return resources["tools"] >= 1.0
		"craft":
			return resources["wood"] >= 18.0
		"reinforce":
			return resources["tools"] >= 2.0
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
	return false

func perform_building_action(building_id: String, action_id: String) -> void:
	if game_over:
		return
	if not buildings.has(building_id):
		_add_event("Build that structure before assigning orders.")
		changed.emit()
		return
	if not is_building_operational(building_id):
		_add_event("%s is still under construction." % buildings[building_id]["name"])
		changed.emit()
		return
	if not can_perform_building_action(building_id, action_id):
		_add_event("%s is not ready or lacks supplies for that order." % buildings[building_id]["name"])
		changed.emit()
		return

	match action_id:
		"stoke":
			resources["wood"] -= 12.0
			heat = clampf(heat + 14.0, 0.0, 100.0)
			morale = clampf(morale + 2.0, 0.0, 100.0)
		"gather":
			resources["food"] -= 8.0
			morale = clampf(morale + 7.0, 0.0, 100.0)
		"fell":
			resources["wood"] += 28.0
		"snare":
			resources["wood"] -= 4.0
			resources["food"] += 12.0
		"cover":
			resources["wood"] -= 8.0
			resources["food"] += 18.0
			buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 8.0, 0.0, 100.0)
		"save_seed":
			resources["food"] -= 10.0
			resources["seed"] += 16.0
		"draw":
			resources["water"] += 30.0
		"clear_ice":
			resources["tools"] -= 1.0
			resources["water"] += 14.0
			buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 14.0, 0.0, 100.0)
		"craft":
			resources["wood"] -= 18.0
			resources["tools"] += 5.0
		"reinforce":
			resources["tools"] -= 2.0
			var target_id := _weakest_building_id()
			buildings[target_id]["condition"] = clampf(buildings[target_id]["condition"] + 18.0, 0.0, 100.0)
		"sort_stores":
			resources["food"] += 12.0
		"ice_pack":
			resources["water"] -= 6.0
			buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 10.0, 0.0, 100.0)
			buildings[building_id]["ice_packed"] = true
		"smoke_meat":
			resources["wood"] -= 10.0
			resources["food"] -= 8.0
			resources["food"] += 22.0
		"render_fat":
			resources["food"] -= 6.0
			heat = clampf(heat + 8.0, 0.0, 100.0)
			morale = clampf(morale + 3.0, 0.0, 100.0)
		"collect_eggs":
			resources["food"] += 14.0
		"mend_roost":
			resources["wood"] -= 6.0
			buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 12.0, 0.0, 100.0)
			morale = clampf(morale + 2.0, 0.0, 100.0)

	buildings[building_id]["readiness"] = 0.0
	_add_event("%s completed: %s." % [buildings[building_id]["name"], _action_name(building_id, action_id)])
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
		entry["chapter_title"] = CHAPTER_TITLES.get(int(goal["chapter"]), "Chapter %s" % goal["chapter"])
		result.append(entry)
	return result

func chapter_title() -> String:
	return CHAPTER_TITLES.get(current_chapter, "Chapter %s" % current_chapter)

func settlement_power() -> int:
	var score := 0
	for building_id in buildings.keys():
		if not is_building_operational(building_id):
			continue
		var building: Dictionary = buildings[building_id]
		score += int(building["level"]) * 12
		score += int(float(building["condition"]) / 10.0)
		score += int(building["workers"]) * 3
	score += int(morale / 8.0)
	score += int(heat / 8.0)
	score += maxi(0, homesteaders - 8) * 4
	return score

func storm_pressure() -> int:
	var pressure := 14 + day * 2 + int(maxf(0.0, 65.0 - heat) * 0.7)
	if day % 5 == 0:
		pressure += 16
	if season == "Deep Winter":
		pressure += 12
	elif season == "Late Winter":
		pressure += 6
	return clampi(pressure, 0, 100)

func scout_site(site_id: String, reward: Dictionary, message: String) -> void:
	if game_over:
		return
	if scouted_sites.has(site_id):
		_add_event("%s already marked. Survey crews are watching it." % message)
		changed.emit()
		return

	scouted_sites[site_id] = true
	for key in reward.keys():
		_apply_reward(key, float(reward[key]))
	_add_event("%s Survey reward: %s." % [message, _format_reward(reward)])
	_check_goals()
	changed.emit()

func resolve_choice(option_id: String) -> void:
	if pending_choice.is_empty():
		return
	var event_id: String = pending_choice.get("id", "")
	var options: Array = pending_choice.get("options", [])
	pending_choice.clear()

	for option in options:
		if str(option.get("id", "")) != option_id:
			continue
		var effects: Dictionary = option.get("effects", {})
		for key in effects.keys():
			_apply_choice_effect(str(key), float(effects[key]))
		_add_event(str(option.get("result", "Decision made.")))
		break

	_check_goals()
	changed.emit()

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game() -> bool:
	if game_over:
		return false
	var data := {
		"version": 2,
		"day": day,
		"season": season,
		"seconds_until_day": seconds_until_day,
		"homesteaders": homesteaders,
		"morale": morale,
		"heat": heat,
		"resources": resources.duplicate(true),
		"buildings": buildings.duplicate(true),
		"event_log": event_log.duplicate(),
		"completed_goals": completed_goals.duplicate(true),
		"scouted_sites": scouted_sites.duplicate(true),
		"current_chapter": current_chapter,
		"active_project": active_project.duplicate(true),
		"expedition_cooldown": expedition_cooldown,
		"days_without_shortage": days_without_shortage,
		"tutorial_index": tutorial_index,
		"tutorial_complete": tutorial_complete,
		"total_days_survived": total_days_survived,
		"peak_power": peak_power,
		"time_scale": time_scale,
		"paused": paused,
		"layout_data": layout_data.duplicate(true),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		_add_event("Save failed: could not write file.")
		changed.emit()
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
	heat = float(data.get("heat", 62.0))
	resources = data.get("resources", resources).duplicate(true)
	buildings = data.get("buildings", STARTING_BUILDINGS).duplicate(true)
	event_log.clear()
	for entry in data.get("event_log", []):
		event_log.append(str(entry))
	completed_goals = data.get("completed_goals", {}).duplicate(true)
	scouted_sites = data.get("scouted_sites", {}).duplicate(true)
	current_chapter = int(data.get("current_chapter", 1))
	active_project = data.get("active_project", {}).duplicate(true)
	expedition_cooldown = int(data.get("expedition_cooldown", 0))
	days_without_shortage = int(data.get("days_without_shortage", 0))
	tutorial_index = int(data.get("tutorial_index", TUTORIAL_STEPS.size()))
	tutorial_complete = bool(data.get("tutorial_complete", true))
	total_days_survived = int(data.get("total_days_survived", day))
	peak_power = int(data.get("peak_power", settlement_power()))
	time_scale = float(data.get("time_scale", 1.0))
	paused = bool(data.get("paused", false))
	layout_data = data.get("layout_data", {}).duplicate(true)
	game_over = false
	victory = false
	pending_choice.clear()
	_recalculate_workers()
	_add_event("Save loaded — day %s, %s." % [day, season])
	changed.emit()
	return true

func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)

func end_summary() -> String:
	return "Survived %s days | Peak power %s | Chapter %s | Buildings %s" % [
		total_days_survived,
		peak_power,
		current_chapter,
		buildings.size(),
	]

func _apply_daily_cycle() -> void:
	if expedition_cooldown > 0:
		expedition_cooldown -= 1

	var cabin_level := int(buildings["cabin"]["level"]) if buildings.has("cabin") else 1
	var cabin_workers := int(buildings["cabin"]["workers"]) if is_building_operational("cabin") else 0
	var cold_pressure := 7.0 + float(day) * 0.22
	if season == "Deep Winter":
		cold_pressure += 4.0
	elif season == "Late Winter":
		cold_pressure += 2.0
	if day % 5 == 0:
		cold_pressure += 6.0
		_add_event("Whiteout front: hearth drain and building wear are rising today.")
	heat = clampf(heat - cold_pressure + cabin_level * 1.4 + cabin_workers * 0.4, 0.0, 100.0)

	resources["food"] += _production_for("garden", 7.5, 2.8)
	resources["food"] += _production_for("smokehouse", 4.5, 1.8)
	resources["food"] += _production_for("coop", 3.8, 1.4)
	resources["wood"] += _production_for("woodlot", 8.5, 3.2)
	resources["water"] += _production_for("well", 9.0, 2.4)
	resources["tools"] += _production_for("workshop", 1.5, 0.85)
	resources["seed"] += _production_for("garden", 1.2, 0.45)

	if is_building_operational("root_cellar"):
		resources["seed"] += 0.3 + float(buildings["root_cellar"]["level"] - 1) * 0.2
	if is_building_operational("coop"):
		morale = clampf(morale + 0.4 + float(buildings["coop"]["workers"]) * 0.25, 0.0, 100.0)
	if is_building_operational("cabin"):
		morale = clampf(morale + 0.6 + float(buildings["cabin"]["workers"]) * 0.2, 0.0, 100.0)

	var food_need := homesteaders * 2.0
	var water_need := homesteaders * 1.6
	var wood_need := 5.5 + maxf(0.0, 65.0 - heat) * 0.16
	resources["food"] -= food_need
	resources["water"] -= water_need
	resources["wood"] -= wood_need

	var spoilage := maxf(0.0, resources["food"] * 0.04)
	if is_building_operational("root_cellar"):
		var cellar: Dictionary = buildings["root_cellar"]
		var cut := 0.12 + float(cellar["level"]) * 0.06 + float(cellar["workers"]) * 0.03
		if bool(cellar.get("ice_packed", false)):
			cut += 0.10
			cellar["ice_packed"] = false
			buildings["root_cellar"] = cellar
		spoilage *= maxf(0.15, 1.0 - cut)
	if is_building_operational("smokehouse"):
		spoilage *= maxf(0.45, 1.0 - 0.08 * float(buildings["smokehouse"]["level"]))
	if spoilage >= 1.0:
		resources["food"] = maxf(0.0, resources["food"] - spoilage)
		if spoilage >= 4.0 and day % 3 == 0:
			_add_event("Spoilage claimed %s food from the stores." % int(spoilage))

	var shortage_count := 0
	for resource_name in ["food", "water", "wood"]:
		if resources[resource_name] < 0.0:
			shortage_count += 1
			resources[resource_name] = 0.0

	if heat < 35.0:
		shortage_count += 1
		morale -= 8.0
		_add_event("The homestead is dangerously cold.")
	elif heat < 55.0:
		morale -= 3.0

	if shortage_count > 0:
		morale -= shortage_count * 4.0
		days_without_shortage = 0
	else:
		morale += 1.8
		days_without_shortage += 1

	if days_without_shortage >= 4 and homesteaders < 18 and resources["food"] >= 40.0 and morale >= 55.0:
		if randf() < 0.28:
			homesteaders += 1
			resources["food"] -= 12.0
			_recalculate_workers()
			_add_event("A new family joined Frostfall. Population is now %s." % homesteaders)
			days_without_shortage = 0

	morale = clampf(morale, 0.0, 100.0)
	if morale < 25.0:
		_add_event("Morale is low. Families are questioning the settlement plan.")
	elif day % 4 == 0:
		_add_event("Day %s ends under %s. Stores are holding, but pressure builds." % [day, season])

	for building_id in buildings.keys():
		if not is_building_operational(building_id):
			continue
		var building: Dictionary = buildings[building_id]
		building["readiness"] = clampf(building["readiness"] + 36.0 + float(building["workers"]) * 8.0, 0.0, 100.0)
		var wear := maxf(0.8, (70.0 - heat) * 0.035)
		if day % 5 == 0:
			wear += 1.2
		if season == "Deep Winter":
			wear += 0.5
		building["condition"] = clampf(building["condition"] - wear, 0.0, 100.0)
		if building["condition"] < 25.0:
			building["readiness"] = maxf(0.0, float(building["readiness"]) - 15.0)
		buildings[building_id] = building

	_apply_daily_event()

	if morale <= 0.0 or (resources["food"] <= 0.0 and resources["water"] <= 0.0 and resources["wood"] <= 0.0):
		_trigger_defeat("The settlement has broken under the storm.")
	elif heat <= 0.0 and morale < 20.0:
		_trigger_defeat("Frost claimed the last warm room. Frostfall falls silent.")

func _production_for(building_id: String, worker_rate: float, level_bonus: float) -> float:
	if not is_building_operational(building_id):
		return 0.0
	var building: Dictionary = buildings[building_id]
	var condition_mult := clampf(float(building["condition"]) / 100.0, 0.35, 1.0)
	return (float(building["workers"]) * worker_rate + float(building["level"] - 1) * level_bonus) * condition_mult

func build_duration(building_id: String) -> float:
	return float(BUILD_DURATION.get(building_id, 24.0))

func upgrade_duration(building_id: String) -> float:
	if not buildings.has(building_id):
		return 0.0
	return 18.0 + float(buildings[building_id]["level"]) * 10.0

func building_status_text(building_id: String) -> String:
	if not buildings.has(building_id):
		var lock_reason := build_lock_reason(building_id)
		if lock_reason != "":
			return lock_reason
		if project_in_progress():
			return "Project queue busy"
		return "Available to build"
	if bool(buildings[building_id].get("under_construction", false)):
		return "Building: %ss left" % _project_seconds_for(building_id)
	if active_project.get("building_id", "") == building_id and active_project.get("type", "") == "upgrade":
		return "Upgrading to L%s: %ss left" % [active_project["target_level"], _project_seconds_for(building_id)]
	var condition := float(buildings[building_id]["condition"])
	if condition < 30.0:
		return "Critical condition"
	if condition < 55.0:
		return "Needs repair"
	return "Operational"

func _project_seconds_for(building_id: String) -> int:
	if active_project.get("building_id", "") != building_id:
		return 0
	return ceili(float(active_project.get("remaining", 0.0)))

func _tick_active_project(delta: float) -> bool:
	if active_project.is_empty():
		return false

	active_project["remaining"] = maxf(0.0, float(active_project["remaining"]) - delta)
	_project_refresh_timer -= delta
	if float(active_project["remaining"]) > 0.0:
		if _project_refresh_timer <= 0.0:
			_project_refresh_timer = 0.5
			return true
		return false

	_finish_active_project()
	_project_refresh_timer = 0.0
	return true

func _finish_active_project() -> void:
	var project := active_project.duplicate(true)
	active_project.clear()
	var building_id: String = project["building_id"]
	if not buildings.has(building_id):
		return

	if project["type"] == "build":
		buildings[building_id]["under_construction"] = false
		buildings[building_id]["readiness"] = 40.0
		buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 8.0, 0.0, 100.0)
		_add_event("%s construction complete." % buildings[building_id]["name"])
	elif project["type"] == "upgrade":
		buildings[building_id]["level"] = int(project["target_level"])
		buildings[building_id]["max_workers"] += 1
		buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 12.0, 0.0, 100.0)
		_add_event("%s upgraded to level %s." % [buildings[building_id]["name"], buildings[building_id]["level"]])

	_recalculate_workers()
	_check_goals()

func _recalculate_workers() -> void:
	var assigned := 0
	for building in buildings.values():
		if not bool(building.get("under_construction", false)):
			assigned += int(building["workers"])
	available_workers = maxi(0, homesteaders - assigned)

func _add_event(message: String) -> void:
	event_log.push_front(message)
	if event_log.size() > 14:
		event_log.pop_back()
	event_added.emit(message)

func _action_name(building_id: String, action_id: String) -> String:
	for action in building_actions(building_id):
		if action["id"] == action_id:
			return action["name"]
	return "Order"

func _weakest_building_id() -> String:
	var weakest_id := "cabin"
	var weakest_condition := 101.0
	for building_id in buildings.keys():
		if not is_building_operational(building_id):
			continue
		var condition := float(buildings[building_id]["condition"])
		if condition < weakest_condition:
			weakest_condition = condition
			weakest_id = building_id
	return weakest_id

func _check_goals() -> void:
	for goal in SURVIVAL_GOALS:
		if int(goal["chapter"]) > current_chapter:
			continue
		var goal_id: String = goal["id"]
		if completed_goals.has(goal_id) or not _goal_complete(goal_id):
			continue
		completed_goals[goal_id] = true
		var reward: Dictionary = goal["reward"]
		for key in reward.keys():
			_apply_reward(key, float(reward[key]))
		_add_event("Goal complete: %s. Reward: %s." % [goal["title"], _format_reward(reward)])
	_advance_chapter_if_ready()

func _advance_chapter_if_ready() -> void:
	var has_current_chapter_goals := false
	for goal in SURVIVAL_GOALS:
		if int(goal["chapter"]) != current_chapter:
			continue
		has_current_chapter_goals = true
		if not completed_goals.has(goal["id"]):
			return
	if not has_current_chapter_goals:
		return

	current_chapter += 1
	if CHAPTER_TITLES.has(current_chapter):
		_add_event("%s unlocked." % chapter_title())
	else:
		current_chapter -= 1

func _check_victory() -> void:
	if game_over:
		return
	var chapter_five_done := true
	for goal in SURVIVAL_GOALS:
		if int(goal["chapter"]) != 5:
			continue
		if not completed_goals.has(goal["id"]):
			chapter_five_done = false
			break
	if chapter_five_done and day >= 14 and settlement_power() >= 160:
		victory = true
		game_over = true
		paused = true
		_add_event("Victory: Frostfall stands as a stormproof valley settlement.")
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
		"build_garden":
			return is_building_operational("garden")
		"stockpile_heat":
			return heat >= 80.0
		"build_well":
			return is_building_operational("well")
		"build_workshop":
			return is_building_operational("workshop")
		"build_cellar":
			return is_building_operational("root_cellar")
		"build_smokehouse":
			return is_building_operational("smokehouse")
		"build_coop":
			return is_building_operational("coop")
		"homestead_l2":
			return int(buildings["cabin"]["level"]) >= 2
		"homestead_l3":
			return int(buildings["cabin"]["level"]) >= 3
		"survive_week":
			return day >= 7 and morale >= 35.0
		"survive_fortnight":
			return day >= 14 and morale >= 40.0
		"power_100":
			return settlement_power() >= 100
		"power_160":
			return settlement_power() >= 160
		"population_12":
			return homesteaders >= 12
	return false

func _goal_progress(goal_id: String) -> String:
	match goal_id:
		"build_woodlot":
			return "Built" if is_building_operational("woodlot") else "Not built"
		"assign_woodlot":
			return "%s/2 workers" % (int(buildings["woodlot"]["workers"]) if buildings.has("woodlot") else 0)
		"build_garden":
			return "Built" if is_building_operational("garden") else "Not built"
		"stockpile_heat":
			return "%s/80 heat" % int(heat)
		"build_well":
			return "Built" if is_building_operational("well") else "Not built"
		"build_workshop":
			return "Built" if is_building_operational("workshop") else "Not built"
		"build_cellar":
			return "Built" if is_building_operational("root_cellar") else "Not built"
		"build_smokehouse":
			return "Built" if is_building_operational("smokehouse") else "Not built"
		"build_coop":
			return "Built" if is_building_operational("coop") else "Not built"
		"homestead_l2":
			return "L%s/2" % int(buildings["cabin"]["level"])
		"homestead_l3":
			return "L%s/3" % int(buildings["cabin"]["level"])
		"survive_week":
			return "Day %s/7 | %s morale" % [day, int(morale)]
		"survive_fortnight":
			return "Day %s/14 | %s morale" % [day, int(morale)]
		"power_100":
			return "%s/100 power" % settlement_power()
		"power_160":
			return "%s/160 power" % settlement_power()
		"population_12":
			return "%s/12 people" % homesteaders
	return ""

func _apply_reward(resource_name: String, amount: float) -> void:
	if resource_name == "morale":
		morale = clampf(morale + amount, 0.0, 100.0)
	elif resource_name == "heat":
		heat = clampf(heat + amount, 0.0, 100.0)
	elif resources.has(resource_name):
		resources[resource_name] += amount

func _apply_choice_effect(key: String, amount: float) -> void:
	match key:
		"morale":
			morale = clampf(morale + amount, 0.0, 100.0)
		"heat":
			heat = clampf(heat + amount, 0.0, 100.0)
		"homesteaders":
			homesteaders = clampi(homesteaders + int(amount), 1, 24)
			_recalculate_workers()
		_:
			if resources.has(key):
				resources[key] = maxf(0.0, resources[key] + amount)

func _format_reward(reward: Dictionary) -> String:
	var parts: Array[String] = []
	for key in reward.keys():
		parts.append("+%s %s" % [int(reward[key]), key])
	return ", ".join(parts)

func _update_season() -> void:
	if day <= 4:
		season = "Early Winter"
	elif day <= 9:
		season = "Mid Winter"
	elif day <= 14:
		season = "Deep Winter"
	else:
		season = "Late Winter"

func _emit_tutorial() -> void:
	if tutorial_complete or tutorial_index >= TUTORIAL_STEPS.size():
		return
	var step: Dictionary = TUTORIAL_STEPS[tutorial_index]
	tutorial_step.emit(tutorial_index, str(step["title"]), str(step["body"]))

func _apply_daily_event() -> void:
	if day < 2:
		return

	# Scripted choice events on key days.
	if day == 3 and pending_choice.is_empty():
		_request_choice("strangers", "Strangers at the Gate",
			"A frozen pair of travelers ask for shelter. They look honest — and hungry.",
			[
				{"id": "shelter", "label": "Shelter them", "result": "You take them in. Food is spent, but hope rises.", "effects": {"food": -14, "morale": 6, "homesteaders": 1}},
				{"id": "rations", "label": "Share rations only", "result": "They eat and move on, leaving a spare axe head.", "effects": {"food": -8, "tools": 1, "morale": 2}},
				{"id": "turn_away", "label": "Turn them away", "result": "The gate stays shut. Wood is saved, hearts harden.", "effects": {"wood": 6, "morale": -4}},
			])
		return
	if day == 8 and pending_choice.is_empty():
		_request_choice("blizzard", "Blizzard Warning",
			"Scouts report a multi-day whiteout. How do you spend the calm before it hits?",
			[
				{"id": "stoke_all", "label": "Burn wood freely", "result": "Hearths roar. Heat holds, wood stores thin.", "effects": {"wood": -22, "heat": 18, "morale": 3}},
				{"id": "ration", "label": "Ration and brace", "result": "Families tighten belts. Morale dips, stores hold.", "effects": {"food": -10, "wood": -8, "morale": -2, "heat": 6}},
				{"id": "hunt", "label": "Last hunt run", "result": "A risky hunt brings meat — and frostbite stories.", "effects": {"food": 20, "wood": -6, "morale": -1, "heat": -4}},
			])
		return
	if day == 12 and pending_choice.is_empty():
		_request_choice("trader", "Ice-Road Trader",
			"A mule-cart trader offers deals under lantern light. Pick one bargain.",
			[
				{"id": "tools", "label": "Buy tools", "result": "Sharp steel for the workshop and repairs.", "effects": {"wood": -20, "tools": 8}},
				{"id": "seed", "label": "Buy seed stock", "result": "Rare winter-hardy seed fills the jars.", "effects": {"food": -12, "seed": 18, "morale": 2}},
				{"id": "pass", "label": "Decline", "result": "You keep stores tight and wave them on.", "effects": {"morale": 1}},
			])
		return

	if randi_range(1, 100) > 38:
		return

	var roll := randi_range(0, 6)
	match roll:
		0:
			var found_food := randi_range(10, 24)
			resources["food"] += found_food
			_add_event("A buried cache yielded %s food." % found_food)
		1:
			var wind_damage := randf_range(3.0, 8.0)
			for building_id in buildings.keys():
				if not is_building_operational(building_id):
					continue
				buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] - wind_damage, 0.0, 100.0)
			_add_event("Knife-wind damaged exposed roofs. Building condition fell.")
		2:
			var spare_tools := randi_range(2, 5)
			resources["tools"] += spare_tools
			_add_event("A trader caravan exchanged stories and left %s tools." % spare_tools)
		3:
			heat = clampf(heat - 7.0, 0.0, 100.0)
			morale = clampf(morale - 3.0, 0.0, 100.0)
			_add_event("A night squall punched through the shutters. Heat and morale dropped.")
		4:
			morale = clampf(morale + 5.0, 0.0, 100.0)
			_add_event("Shared songs in the main hall lifted morale.")
		5:
			if is_building_operational("garden"):
				resources["food"] += randi_range(8, 16)
				_add_event("A warm spell coaxed extra growth from the kitchen beds.")
			else:
				resources["wood"] += randi_range(8, 16)
				_add_event("Deadfall from the treeline was easy to haul in.")
		6:
			var sick := randi_range(1, 2)
			morale = clampf(morale - 4.0 * sick, 0.0, 100.0)
			resources["food"] = maxf(0.0, resources["food"] - 6.0 * sick)
			_add_event("Winter coughs spread through %s bunk(s). Extra food went to the sick." % sick)

func _request_choice(event_id: String, title: String, body: String, options: Array) -> void:
	pending_choice = {"id": event_id, "title": title, "body": body, "options": options}
	paused = true
	choice_requested.emit(event_id, title, body, options)
	changed.emit()
