module part_1

import utils
import arrays

const file = @FILE
pub const example_input = utils.get_example_input(file)
pub const actual_input = utils.get_actual_input(file)
const cube_names = ['red', 'blue', 'green']

struct Game {
	id               string
	red_cube_count   int
	blue_cube_count  int
	green_cube_count int
}

fn Game.parse(line string) &Game {
	parts := line.split(':')
	game_id := parts[0].replace('Game ', '')
	mut red_cube_count := 0
	mut green_cube_count := 0
	mut blue_cube_count := 0

	for i := 1; i < parts[1].len; i++ {
		sub_str := parts[1][i..parts[1].len]
		n0 := sub_str[0].str().int()
		n1 := sub_str[1].str().int()
		mut cube := ''

		if n0 != 0 {
			if n1 != 0 {
				for c in part_1.cube_names {
					if sub_str[3..sub_str.len].contains(c) {
						cube = c
						break
					}
				}
			}

			for c in part_1.cube_names {
				if sub_str[2..sub_str.len].contains(c) {
					cube = c
					break
				}
			}

            count := if n1 != 0 { '${n0}${n1}'.int() } else { n0 }
            println('Cube: ${cube}, Count: ${count}')

            match cube {
                'red' {
                    red_cube_count += count
                }
                'blue' {
                    blue_cube_count += count
                }
                'green' {
                    green_cube_count += count
                }
                else {
                    panic('Unknown cube color: ${cube}')
                }
            }
		}
	}

	return &Game{
		id: game_id
		red_cube_count: red_cube_count
		green_cube_count: green_cube_count
		blue_cube_count: blue_cube_count
	}
}

pub fn solve(input string) int {
	games := input.split_into_lines().map(Game.parse(it))
    dump(games)
	return 0
}
