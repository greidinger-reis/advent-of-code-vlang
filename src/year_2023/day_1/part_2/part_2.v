module part_2

import utils
import arrays

const filepath = @FILE
pub const example_input = utils.get_example_input(filepath)
pub const actual_input = utils.get_actual_input(filepath)
pub const example_result = 281

const digits_str = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

fn Digit.all_from_str(str string) []int {
	mut digits := []int{}

	for i := 0; i < str.len; i++ {
		sub_str := str[i..str.len]
        digit_literal := get_digit_literal(sub_str[0])

        if digit_literal != 0 {
            digits << digit_literal
            continue
        }

		for digit in part_2.digits_str {
			if sub_str.starts_with(digit) {
				digits << parse_digit_str(digit)
			}
		}
	}

	return digits
}

fn get_digit_literal(c rune) int {
	return match c {
		`1` { 1 }
		`2` { 2 }
		`3` { 3 }
		`4` { 4 }
		`5` { 5 }
		`6` { 6 }
		`7` { 7 }
		`8` { 8 }
		`9` { 9 }
		else { 0 }
	}
}

fn parse_digit_str(str string) int {
	return match str {
		'one' { 1 }
		'two' { 2 }
		'three' { 3 }
		'four' { 4 }
		'five' { 5 }
		'six' { 6 }
		'seven' { 7 }
		'eight' { 8 }
		'nine' { 9 }
		else { panic('Invalid digit string:${str}') }
	}
}

pub fn solve(input string) int {
	return arrays.sum(input.split_into_lines()
		.map(Digit.all_from_str(it))
		.map('${it.first()}${it.last()}'.int())) or { panic(err) }
}
