module main

import year_2023.day_1.part_1

fn main() {
	assert part_1.solve(part_1.example_input) == part_1.example_result
	println(part_1.solve(part_1.actual_input))
}
