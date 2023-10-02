extends Node

var textbox: Textbox

var score: int = 0
var best_score: int = 0
var skip_cutscene: bool = false

var explosion_scene = preload("res://scenes/one_shot_explosion.tscn")
var star_pickup_scene = preload("res://scenes/star_pickup.tscn")
var choreograph_scene = preload("res://scenes/choreograph.tscn")
