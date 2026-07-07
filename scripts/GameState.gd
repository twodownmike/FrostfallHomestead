extends RefCounted
class_name GameState

signal changed
signal event_added(message: String)

const STARTING_BUILDINGS := {
	"cabin": {"name": "Cabin", "level": 1, "workers": 2, "max_workers": 4, "condition": 78.0, "readiness": 35.0},
	"woodlot": {"name": "Woodlot", "level": 1, "workers": 2, "max_workers": 5, "condition": 72.0, "readiness": 52.0},
	"garden": {"name": "Kitchen Garden", "level": 1, "workers": 2, "max_workers": 5, "condition": 68.0, "readiness": 48.0},
	"well": {"name": "Well House", "level": 1, "workers": 1, "max_workers": 3, "condition": 75.0, "readiness": 58.0},
	"workshop": {"name": "Workshop", "level": 1, "workers": 1, "max_workers": 4, "condition": 70.0, "readiness": 42.0},
}

const BUILDING_DETAILS := {
	"cabin": {
		"role": "Shelter, warmth, family morale",
		"output": "Heat stability and morale",
		"risk": "Cold cabins drain morale fast.",
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

func _init() -> void:
	_recalculate_workers()
	_add_event("The first families arrive at Frostfall Homestead.")

func tick(delta: float) -> void:
	seconds_until_day -= delta
	if seconds_until_day > 0.0:
		return

	seconds_until_day = 20.0
	day += 1
	_apply_daily_cycle()
	changed.emit()

func can_upgrade(building_id: String) -> bool:
	var building: Dictionary = buildings[building_id]
	var level := int(building["level"])
	var cost := upgrade_cost(building_id)
	return resources["wood"] >= cost["wood"] and resources["tools"] >= cost["tools"] and level < 8

func upgrade_cost(building_id: String) -> Dictionary:
	var level := int(buildings[building_id]["level"])
	return {
		"wood": 26 + (level * 18),
		"tools": 3 + level,
	}

func upgrade(building_id: String) -> void:
	if not can_upgrade(building_id):
		_add_event("Not enough supplies to upgrade %s." % buildings[building_id]["name"])
		changed.emit()
		return

	var cost := upgrade_cost(building_id)
	resources["wood"] -= cost["wood"]
	resources["tools"] -= cost["tools"]
	buildings[building_id]["level"] += 1
	buildings[building_id]["max_workers"] += 1
	buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 12.0, 0.0, 100.0)
	_add_event("%s upgraded to level %s." % [buildings[building_id]["name"], buildings[building_id]["level"]])
	_recalculate_workers()
	changed.emit()

func assign_worker(building_id: String, amount: int) -> void:
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
	changed.emit()

func add_log(message: String) -> void:
	_add_event(message)
	changed.emit()

func building_details(building_id: String) -> Dictionary:
	return BUILDING_DETAILS[building_id]

func production_preview(building_id: String) -> Dictionary:
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
	match building_id:
		"cabin":
			return [
				{"id": "stoke", "name": "Stoke Hearth", "cost": "12 wood", "effect": "+14 heat, +2 morale"},
				{"id": "gather", "name": "Family Council", "cost": "8 food", "effect": "+7 morale"},
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
				{"id": "reinforce", "name": "Reinforce Building", "cost": "2 tools", "effect": "+condition to selected"},
			]
	return []

func can_perform_building_action(building_id: String, action_id: String) -> bool:
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
			buildings[building_id]["condition"] = clampf(buildings[building_id]["condition"] + 18.0, 0.0, 100.0)

	buildings[building_id]["readiness"] = 0.0
	_add_event("%s completed: %s." % [buildings[building_id]["name"], _action_name(building_id, action_id)])
	changed.emit()

func _apply_daily_cycle() -> void:
	var cabin_level := int(buildings["cabin"]["level"])
	var cold_pressure := 8.0 + float(day) * 0.28
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
		_add_event("The cabins are dangerously cold.")
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
		var building: Dictionary = buildings[building_id]
		building["readiness"] = clampf(building["readiness"] + 34.0 + float(building["workers"]) * 8.0, 0.0, 100.0)
		building["condition"] = clampf(building["condition"] - maxf(1.0, (70.0 - heat) * 0.04), 0.0, 100.0)
		buildings[building_id] = building

func _production_for(building_id: String, worker_rate: float, level_bonus: float) -> float:
	var building: Dictionary = buildings[building_id]
	return float(building["workers"]) * worker_rate + float(building["level"] - 1) * level_bonus

func _recalculate_workers() -> void:
	var assigned := 0
	for building in buildings.values():
		assigned += int(building["workers"])
	available_workers = homesteaders - assigned

func _add_event(message: String) -> void:
	event_log.push_front(message)
	if event_log.size() > 8:
		event_log.pop_back()
	event_added.emit(message)

func _action_name(building_id: String, action_id: String) -> String:
	for action in building_actions(building_id):
		if action["id"] == action_id:
			return action["name"]
	return "Order"
