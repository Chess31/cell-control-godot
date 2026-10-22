class_name Entity
extends CharacterBody2D

enum Team {
	Team01,
	Team02,
	ENEMY,
	NEUTRAL
}

@export var team: Team = Team.ENEMY


func get_team() -> Team:
	return team
