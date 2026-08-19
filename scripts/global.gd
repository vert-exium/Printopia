extends Node

var balance: float
var printTime = 3.0
var autoPrint: bool
var earnings: float = 1.0

var autoPrintCost = 1000.0

var earnLevel: int = 0
var speedLevel: int = 0

var earn_prices: Array[float] = [2.0, 5.0, 15.0, 35.0, 80.0, 1000.0, 15000.0, 35000.0, 100000.0]
var earn_gains: Array[float] = [3.0, 8.0, 20.0, 45.0, 100.0, 250.0, 750.0, 2500.0, 6000.0]
var speed_prices: Array[float] = [2.0, 10.0, 45.0, 120.0, 300.0]
