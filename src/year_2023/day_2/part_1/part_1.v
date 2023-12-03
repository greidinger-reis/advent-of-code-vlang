module part_1

import utils
import arrays

const file = @FILE
pub const example_input = utils.get_example_input(file)
pub const actual_input = utils.get_actual_input(file)
const cube_names = ['red', 'green', 'blue']

enum Cube {
	red
	green
	blue
}

struct Game {
	id    int
	draws []Draw
}

struct Draw {
	cubes []DrawCube
}

struct DrawCube {
	cube  Cube
	count int
}

struct PossibleGamesArgs {
	red   int
	green int
	blue  int
}

// find all games that are possible with the given args
// args define the maximum possible number of cubes of each color in each draw
// if a draw contains more cubes than the maximum, the game is not possible
fn (games []Game) possible_games(args PossibleGamesArgs) []Game {
	mut possible_games := []Game{cap: games.len}

	for game in games {
		mut possible := true

		for draw in game.draws {
			for cubes in draw.cubes {
				match cubes.cube {
					.red {
						if cubes.count > args.red {
							possible = false
							break
						}
					}
					.green {
						if cubes.count > args.green {
							possible = false
							break
						}
					}
					.blue {
						if cubes.count > args.blue {
							possible = false
							break
						}
					}
				}
			}
			if !possible {
				break
			}
		}

		if possible {
			possible_games << game
		}
	}

	return possible_games
}

fn Game.from_line(line string) Game {
	parts := line.split(':')
	game_id := parts[0].replace('Game ', '').int()

	raw_draws := parts[1].split(';')
	draws := raw_draws.map(parse_draw(it))

	return Game{
		id: game_id
		draws: draws
	}
}

fn parse_draw(draw_str string) Draw {
	trimmed_draw := draw_str.trim_space()
	cube_counts_raw := trimmed_draw.split(', ')

	draw_cubes := cube_counts_raw.map(fn (it string) DrawCube {
		cube_count_parts := it.split(' ')
		count := cube_count_parts[0].int()
		cube := cube_from_str(cube_count_parts[1])
		return DrawCube{
			cube: cube
			count: count
		}
	})

	return Draw{
		cubes: draw_cubes
	}
}

fn cube_from_str(str string) Cube {
	return match str {
		'red' {
			.red
		}
		'green' {
			.green
		}
		'blue' {
			.blue
		}
		else {
			panic('Unknown cube color: ${str}')
		}
	}
}

pub fn solve(input string) int {
	games := input.split_into_lines().map(Game.from_line(it))
	possible_games := games.possible_games(red: 12, green: 13, blue: 14)
	return arrays.sum(possible_games.map(it.id)) or { panic(err) }
}
