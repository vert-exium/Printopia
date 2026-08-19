extends Control

func _on_upgrade_button_pressed() -> void:
	if global.earnLevel < global.earn_prices.size():
		var cost = global.earn_prices[global.earnLevel]
		if cost <= global.balance:
			global.balance -= cost
			global.earnings = global.earn_gains[global.earnLevel]
			global.earnLevel += 1

func _on_upgrade_button2pressed() -> void:
	if global.speedLevel < global.speed_prices.size():
		var cost = global.speed_prices[global.speedLevel]
		if cost <= global.balance:
			global.balance -= cost
			global.speedLevel += 1
			global.printTime = global.printTime / 2.0

func _on_upgrade_button3_pressed() -> void:
	if global.autoPrintCost <= global.balance and not global.autoPrint:
		global.balance -= global.autoPrintCost
		global.autoPrint = true
