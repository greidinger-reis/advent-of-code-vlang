module part_1

import utils

pub const filepath = @FILE
pub const example_input = utils.get_example_input(filepath)
pub const actual_input = utils.get_actual_input(filepath)
pub const example_result = 142

pub fn get_calibration_from_line(line string) int {
	mut first_digit := 0
	mut last_digit := 0

	for c in line.runes() {
		if digit := utils.Rune.to_int(c) {
			if first_digit == 0 {
				first_digit = digit
				last_digit = digit
			} else {
				last_digit = digit
			}
		}
	}

	return '${first_digit}${last_digit}'.int()
}

pub fn solve(input string) int {
	lines := input.split_into_lines()
	digits := lines.map(get_calibration_from_line(it))
	total := utils.Array.sum(digits)
	return total
}
