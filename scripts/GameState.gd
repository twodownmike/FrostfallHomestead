extends RefCounted
class_name GameState

signal changed
signal event_added(message: String)

const BUILDING_ORDER := ["cabin", "woodlot", "garden", "well", "workshop"]
const BUILDING_BLUEPRINTS := {
	"cabin": {"name": "Homestead", "level": 1, "workers": 2, "max_workers": 4, "condition": 84.0, "readiness": 35.0},
	"woodlot": {"name": "Woodlot", "level": 1, "workers": 0, "max_workers": 5, "condition": 72.0, "readiness": 20.0},
	"garden": {"name": "Kitchen Garden", "level": 1, "workers": 0, "max_workers": 5, "condition": 68.0, "readiness": 20.0},
	"well": {"name": "Well House", "level": 1, "workers": 0, "max_workers": 3, "condition": 75.0, "readiness": 20.0},
	"workshop": {"name": "Workshop", "level": 1, "workers": 0, "max_workers": 4, "condition": 70.0, "readiness": 20.0},
}
const STARTING_BUILDINGS := {
	"cabin": {"name": "Homestead", "level": 1, "workers": 2, "max_workers": 4, "condition": 84.0, "readiness": 35.0},
}
const BUILD_COSTS := {
	"woodlot": {"wood": 35, "tools": 3, "seed": 0},
	"garden": {"wood": 28, "tools": 2, "seed": 8},
	"well": {"wood": 42, "tools": 5, "seed": 0},
	"workshop": {"wood": 55, "tools": 8, "seed": 0},
}
const BUILDING_UNLOCKS := {
	"woodlot": {"building": "cabin", "level": 1, "label": "Homestead L1"},
	"garden": {"building": "cabin", "level": 1, "label": "Homestead L1"},
	"well": {"building": "cabin", "level": 2, "label": "Homestead L2"},
	"workshop": {"building": "cabin", "level": 3, "label": "Homestead L3"},
}
const BUILD_DURATION := {
	"woodlot": 18.0,
	"garden": 20.0,
	"well": 28.0,
	"workshop": 36.0,
}
const SURVIVAL_GOALS := [
	{"id": "build_woodlot", "chapter": 1, "title": "Raise a Woodlot", "detail": "Build a Woodlot to secure fuel.", "reward": {"wood": 18, "morale": 3}},
	{"id": "assign_woodlot", "chapter": 1, "title": "Put Axes to Work", "detail": "Assign 2 workers to the Woodlot.", "reward": {"wood": 16}},
	{"id": "stockpile_heat", "chapter": 1, "title": "Hold the Hearth", "detail": "Reach 80 heat before the next hard freeze.", "reward": {"morale": 5}},
	{"id": "homestead_l2", "chapter": 2, "title": "Strengthen the Hall", "detail": "Upgrade the Homestead to level 2.", "reward": {"wood": 20, "tools": 2}},
	{"id": "build_garden", "chapter": 2, "title": "Plant Winter Beds", "detail": "Build a Kitchen Garden for food and seed.", "reward": {"food": 20, "seed": 6}},
	{"id": "build_well", "chapter": 2, "title": "Break Groundwater", "detail": "Build a Well House before water runs thin.", "reward": {"water": 28, "morale": 3}},
	{"id": "homestead_l3", "chapter": 3, "title": "A Real Settlement", "detail": "Upgrade the Homestead to level 3.", "reward": {"tools": 4, "morale": 4}},
	{"id": "build_workshop", "chapter": 3, "title": "Open the Workshop", "detail": "Build a Workshop to craft tools.", "reward": {"tools": 6}},
	{"id": "survive_week", "chapter": 3, "title": "Survive the First Week", "detail": "Reach day 7 with morale above 35.", "reward": {"food": 30, "wood": 30, "morale": 8}},
	{"id": "power_100", "chapter": 4, "title": "Settlement Power 100", "detail": "Reach 100 settlement power.", "reward": {"tools": 8, "morale": 6}},
]
const CHAPTER_TITLES := {
	1: "Chapter 1: First Fire",
	2: "Chapter 2: Water and Seed",
	3: "Chapter 3: Working Settlement",
	4: "Chapter 4: Stormproofing",
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
}

var day := 1
var season := "Early Winter"
var seconds_until_day := 20.0
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
var buildings := STARTING_BUILDINGS.duplicate(true)
var event_log: Array[String] = []
var completed_goals := {}
var scouted_sites := {}
var current_chapter := 1
var active_project := {}
var _project_refresh_timer := 0.0
var game_over := false

func _init() -> void:
	_recalculate_workers()
	_add_event("The first families arrive at Frostfall Homestead.")
	_check_goals()

func tick(delta: float) -> void:
	if game_over:
		return

	var project_changed := _tick_active_project(delta)
	seconds_until_day -= delta
	if seconds_until_day > 0.0:
		if project_changed:
			changed.emit()
		return

	seconds_until_day = 20.0
	day += 1
	_apply_daily_cycle()
	_check_goals()
	changed.emit()

func can_upgrade(building_id: String) -> bool:
	if not is_building_operational(building_id) or project_in_progress():
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
		"wood": 26 + (level * 18),
		"tools": 3 + level,
	}

func upgrade(building_id: String) -> void:
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
	if buildings.has(building_id) or project_in_progress() or not is_building_unlocked(building_id) or not BUILDING_BLUEPRINTS.has(building_id) or not BUILD_COSTS.has(building_id):
		return false

	var cost := build_cost(building_id)
	for resource_name in cost.keys():
		if resources.get(resource_name, 0.0) < float(cost[resource_name]):
			return false
	return true

func build(building_id: String) -> bool:
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
	if not is_building_operational(building_id):
		return
	var building: Dictionary = buildings[building_id]
	var new_workers: int = clampi(int(building["workers"]) + amount, 0, int(building["max_workers"]))
	building["workers"] = new_workers
	buildings[building_id] = building
	_recalculate_workers()
	changed.emit()

func send_expedition() -> void:
	if available_workers < 2 or resources["food"] < 18.0 or resources["wood"] < 12.0:
		_add_event("An expedition needs 2 idle workers, 18 food, and 12 wood.")
		changed.emit()
		return

	resources["food"] -= 18.0
	resources["wood"] -= 12.0
	var food_found := randi_range(18, 44)
	var seed_found := randi_range(4, 14)
	var tools_found := randi_range(0, 4)
	resources["food"] += food_found
	resources["seed"] += seed_found
	resources["tools"] += tools_found
	morale = clampf(morale + 3.0, 0.0, 100.0)
	_add_event("Foragers returned with %s food, %s seed, and %s tools." % [food_found, seed_found, tools_found])
	_check_goals()
	changed.emit()

func repair_hearth() -> void:
	if resources["wood"] < 18.0 or resources["tools"] < 2.0:
		_add_event("The hearth repair needs 18 wood and 2 tools.")
		changed.emit()
		return

	resources["wood"] -= 18.0
	resources["tools"] -= 2.0
	heat = clampf(heat + 18.0, 0.0, 100.0)
	morale = clampf(morale + 2.0, 0.0, 100.0)
	_add_event("The hearth is burning steady again.")
	_check_goals()
	changed.emit()

func add_log(message: String) -> void:
	_add_event(message)
	changed.emit()

func building_details(building_id: String) -> Dictionary:
	return BUILDING_DETAILS[building_id]

func production_preview(building_id: String) -> Dictionary:
	if not is_building_operational(building_id):
		return {}
	match building_id:
		"cabin":
			return {"heat": float(buildings["cabin"]["level"]) * 1.2, "morale": 0.6 + float(buildings["cabin"]["workers"]) * 0.3}
		"woodlot":
			return {"wood": _production_for("woodlot", 8.0, 3.0)}
		"garden":
			return {"food": _production_for("garden", 7.0, 2.6), "seed": _production_for("garden", 1.1, 0.4)}
		"well":
			return {"water": _production_for("well", 8.5, 2.2)}
		"workshop":
			return {"tools": _production_for("workshop", 1.4, 0.8)}
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
	return []

func can_perform_building_action(building_id: String, action_id: String) -> bool:
	if not is_building_operational(building_id):
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
	return false

func perform_building_action(building_id: String, action_id: String) -> void:
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
		entry["active"] = int(goal["chapter"]) == current_chapter
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
	return score

func storm_pressure() -> int:
	var pressure := 18 + day * 3 + int(maxf(0.0, 65.0 - heat) * 0.7)
	if day % 5 == 0:
		pressure += 18
	return clampi(pressure, 0, 100)

func scout_site(site_id: String, reward: Dictionary, message: String) -> void:
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

func _apply_daily_cycle() -> void:
	var cabin_level := int(buildings["cabin"]["level"])
	var cold_pressure := 8.0 + float(day) * 0.28
	if day % 5 == 0:
		cold_pressure += 7.0
		_add_event("Whiteout front: hearth drain and building wear are rising today.")
	heat = clampf(heat - cold_pressure + cabin_level * 1.2, 0.0, 100.0)

	resources["food"] += _production_for("garden", 7.0, 2.6)
	resources["wood"] += _production_for("woodlot", 8.0, 3.0)
	resources["water"] += _production_for("well", 8.5, 2.2)
	resources["tools"] += _production_for("workshop", 1.4, 0.8)
	resources["seed"] += _production_for("garden", 1.1, 0.4)

	var food_need := homesteaders * 2.2
	var water_need := homesteaders * 1.8
	var wood_need := 6.0 + maxf(0.0, 65.0 - heat) * 0.18
	resources["food"] -= food_need
	resources["water"] -= water_need
	resources["wood"] -= wood_need

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
	else:
		morale += 1.5

	morale = clampf(morale, 0.0, 100.0)
	if morale < 25.0:
		_add_event("Morale is low. Families are questioning the settlement plan.")
	elif day % 4 == 0:
		_add_event("Day %s ends. Stores are holding, but winter is tightening." % day)

	for building_id in buildings.keys():
		if not is_building_operational(building_id):
			continue
		var building: Dictionary = buildings[building_id]
		building["readiness"] = clampf(building["readiness"] + 34.0 + float(building["workers"]) * 8.0, 0.0, 100.0)
		var wear := maxf(1.0, (70.0 - heat) * 0.04)
		if day % 5 == 0:
			wear += 1.5
		building["condition"] = clampf(building["condition"] - wear, 0.0, 100.0)
		buildings[building_id] = building

	_apply_random_daily_event()
	if morale <= 0.0 or (resources["food"] <= 0.0 and resources["water"] <= 0.0 and resources["wood"] <= 0.0):
		game_over = true
		_add_event("The settlement has broken under the storm.")

func _production_for(building_id: String, worker_rate: float, level_bonus: float) -> float:
	if not is_building_operational(building_id):
		return 0.0
	var building: Dictionary = buildings[building_id]
	return float(building["workers"]) * worker_rate + float(building["level"] - 1) * level_bonus

func build_duration(building_id: String) -> float:
	return float(BUILD_DURATION.get(building_id, 24.0))

func upgrade_duration(building_id: String) -> float:
	if not buildings.has(building_id):
		return 0.0
	return 22.0 + float(buildings[building_id]["level"]) * 12.0

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
			_project_refresh_timer = 1.0
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
		buildings[building_id]["readiness"] = 35.0
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
	available_workers = homesteaders - assigned

func _add_event(message: String) -> void:
	event_log.push_front(message)
	if event_log.size() > 10:
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
		"homestead_l2":
			return int(buildings["cabin"]["level"]) >= 2
		"homestead_l3":
			return int(buildings["cabin"]["level"]) >= 3
		"survive_week":
			return day >= 7 and morale >= 35.0
		"power_100":
			return settlement_power() >= 100
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
		"homestead_l2":
			return "L%s/2" % int(buildings["cabin"]["level"])
		"homestead_l3":
			return "L%s/3" % int(buildings["cabin"]["level"])
		"survive_week":
			return "Day %s/7 | %s morale" % [day, int(morale)]
		"power_100":
			return "%s/100 power" % settlement_power()
	return ""

func _apply_reward(resource_name: String, amount: float) -> void:
	if resource_name == "morale":
		morale = clampf(morale + amount, 0.0, 100.0)
	elif resource_name == "heat":
		heat = clampf(heat + amount, 0.0, 100.0)
	elif resources.has(resource_name):
		resources[resource_name] += amount

func _format_reward(reward: Dictionary) -> String:
	var parts: Array[String] = []
	for key in reward.keys():
		parts.append("+%s %s" % [int(reward[key]), key])
	return ", ".join(parts)

func _apply_random_daily_event() -> void:
	if day < 2 or randi_range(1, 100) > 42:
		return

	var roll := randi_range(0, 4)
	match roll:
		0:
			var found_food := randi_range(10, 24)
			resources["food"] += found_food
			_add_event("A buried cache yielded %s food." % found_food)
		1:
			var wind_damage := randf_range(4.0, 9.0)
			for building_id in buildings.keys():
				buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] - wind_damage, 0.0, 100.0)
			_add_event("Knife-wind damaged exposed roofs. Building condition fell.")
		2:
			var spare_tools := randi_range(2, 5)
			resources["tools"] += spare_tools
			_add_event("A trader caravan exchanged stories and left %s tools." % spare_tools)
		3:
			heat = clampf(heat - 8.0, 0.0, 100.0)
			morale = clampf(morale - 3.0, 0.0, 100.0)
			_add_event("A night squall punched through the shutters. Heat and morale dropped.")
		4:
			morale = clampf(morale + 4.0, 0.0, 100.0)
			_add_event("Shared songs in the main hall lifted morale.")
