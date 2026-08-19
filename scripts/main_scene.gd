extends Node2D

var resetButtonValue = 1

@onready var progress_bar: ProgressBar = $printProgressBar
@onready var timer: Timer = $cooldownTimer


func _ready():
	loadValues()
	$moneyLabel.text = "Balance: " + str(global.balance)

func _process(delta: float):
	if not timer.is_stopped():
		var progress_ratio: float = 1.0 - (timer.time_left / timer.wait_time)
		progress_bar.value = progress_ratio * 100.0
	else:
		if timer.wait_time > 0 and timer.time_left == 0:
			progress_bar.value = 0
			
	$moneyLabel.text = "Balance: " + str(global.balance)
	$shopMenu/backTexture/ScrollContainer/VBoxContainer/earningsUpgrade/currentLevel.text = "Current: $" + str(global.earnings) 
	$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/currentLevel.text = "Current: " + str(global.printTime) + " second(s)"

	if global.earnLevel < global.earn_prices.size():
		var current_earn_cost = global.earn_prices[global.earnLevel]
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/earningsUpgrade/UpgradeButton.text = "Upgrade ($" + str(current_earn_cost) + ")"
		if current_earn_cost <= global.balance:
			$shopMenu/backTexture/ScrollContainer/VBoxContainer/earningsUpgrade/UpgradeButton.disabled = false
		else:
			$shopMenu/backTexture/ScrollContainer/VBoxContainer/earningsUpgrade/UpgradeButton.disabled = true
	else:
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/earningsUpgrade/UpgradeButton.text = "Max"
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/earningsUpgrade/UpgradeButton.disabled = true

	if global.speedLevel < global.speed_prices.size():
		var current_speed_cost = global.speed_prices[global.speedLevel]
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/UpgradeButton.text = "Upgrade ($" + str(current_speed_cost) + ")"
		if current_speed_cost <= global.balance:
			$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/UpgradeButton.disabled = false
		else:
			$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/UpgradeButton.disabled = true
	else:
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/UpgradeButton.text = "Max"
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/UpgradeButton.disabled = true

	if global.autoPrintCost <= global.balance:
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/autoPrintUpgrade/UpgradeButton.disabled = false
	else:
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/autoPrintUpgrade/UpgradeButton.disabled = true
		
	if global.printTime <= 0.375:
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/UpgradeButton.text = "Max"
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/speedUpgrade/UpgradeButton.disabled = true
		
	if global.autoPrint == true:
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/autoPrintUpgrade/UpgradeButton.disabled = true
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/autoPrintUpgrade/currentLevel.text = "Current: Yes"
		$shopMenu/backTexture/ScrollContainer/VBoxContainer/autoPrintUpgrade/UpgradeButton.text = "Max"
	
	if global.autoPrint == true:
		if $printButton.disabled == false:
			$printButton.pressed.emit()

func _on_print_button_pressed() -> void:
	$printButton.disabled = true
	$cooldownTimer.start(global.printTime)
	$printerSprite.speed_scale = 1.0 / $cooldownTimer.wait_time
	$printerSprite.play("print")

func _on_cooldown_timer_timeout() -> void:
	$printButton.disabled = false
	global.balance += global.earnings

func _on_reset_button_pressed() -> void:
	if resetButtonValue == 1:
		resetButtonValue = 2
		$resetButton.text = "THIS WILL ERASE ALL PROGRESS!"
	elif resetButtonValue == 2:
		SaveManager.reset_save()
		resetButtonValue = 1
		$resetButton.text = "Reset ALL Progress"
		loadValues()

func _exit_tree() -> void:
	SaveManager.save_game({"balance": global.balance, "print_time": global.printTime, "earnings": global.earnings, "earnLevel": global.earnLevel, "speedLevel": global.speedLevel, "autoPrint": global.autoPrint, "autoPrintCost": global.autoPrintCost})

func loadValues():
	var dict: Dictionary = SaveManager.load_game()
	global.balance = dict["balance"]
	global.printTime = dict["print_time"]
	global.earnings = dict["earnings"]
	global.earnLevel = dict["earnLevel"]
	global.speedLevel = dict["speedLevel"]
	global.autoPrint = dict["autoPrint"]
	global.autoPrintCost = dict["autoPrintCost"]


func _on_audio_player_finished() -> void:
	$audioPlayer.play()
