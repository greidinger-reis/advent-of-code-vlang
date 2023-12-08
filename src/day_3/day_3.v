module day_3

import utils
import arrays
import regex

const file = @FILE
const pattern_digits = r'\d+'
const pattern_symbols = r'[^\w\s.]'
const pattern_gear = r'\*'
pub const input = utils.get_actual_input(file)
pub const example_input = utils.get_example_input(file, 1)
pub const example_output_part_1 = 4361

struct Match {
	val       int
	idx_start int
	idx_end   int
}

pub fn part_1(input string) int {
	lines := input.split_into_lines()
	mut reg := regex.regex_opt(day_3.pattern_digits) or { panic('invalid regex') }
	mut reg_symbols := regex.regex_opt(day_3.pattern_symbols) or { panic('invalid regex') }
	mut sum := 0

	for line := 0; line < lines.len; line++ {
		matches_str := reg.find_all_str(lines[line])
		matches_idx := arrays.window(reg.find_all(lines[line]), size: 2, step: 2)

		if matches_str.len == 0 {
			continue
		}

		mut matches := []Match{}

		for i := 0; i < matches_str.len; i++ {
			m := matches_str[i]
			matches << Match{
				val: m.int()
				idx_start: matches_idx[i][0]
				idx_end: matches_idx[i][1]
			}
		}

		row_above := if line > 0 {
			lines[line - 1]
		} else {
			''
		}

		row_below := if line < lines.len - 1 {
			lines[line + 1]
		} else {
			''
		}

		for m in matches {
			left := if m.idx_start - 1 > 0 {
				lines[line][m.idx_start - 1].ascii_str()
			} else {
				''
			}

			right := if m.idx_end + 1 < lines[line].len {
				lines[line][m.idx_end].ascii_str()
			} else {
				''
			}

			if reg_symbols.matches_string(left) || reg_symbols.matches_string(right) {
				sum += m.val
				continue
			}

			if !row_above.is_blank() {
				directly_above := row_above[m.idx_start..m.idx_end]

				top_left := if m.idx_start - 1 > 0 {
					row_above[m.idx_start - 1].ascii_str()
				} else {
					''
				}

				top_right := if m.idx_end + 1 < row_above.len {
					row_above[m.idx_end].ascii_str()
				} else {
					''
				}

				full_row_above := '${top_left}${directly_above}${top_right}'
				if reg_symbols.find_all_str(full_row_above).len > 0 {
					sum += m.val
					continue
				}
			}

			if !row_below.is_blank() {
				directly_below := row_below[m.idx_start..m.idx_end]

				bottom_left := if m.idx_start - 1 > 0 {
					row_below[m.idx_start - 1].ascii_str()
				} else {
					''
				}

				bottom_right := if m.idx_end + 1 < row_below.len {
					row_below[m.idx_end].ascii_str()
				} else {
					''
				}

				full_row_below := '${bottom_left}${directly_below}${bottom_right}'
				if reg_symbols.find_all_str(full_row_below).len > 0 {
					sum += m.val
					continue
				}
			}
		}
	}
	return sum
}

pub fn part_2(input string) int {
	lines := input.split_into_lines()
	mut reg := regex.regex_opt(day_3.pattern_digits) or { panic('invalid regex_digits') }
	mut reg_gear := regex.regex_opt(day_3.pattern_gear) or { panic('invalid regex_gear') }
	mut sum := 0

	for line := 0; line < lines.len; line++ {
		line_str := lines[line]

		gear_idxs := arrays.window(reg_gear.find_all(line_str), size: 1, step: 2).map(it[0])

		if gear_idxs.len < 1 {
			continue
		}

		row_above := if line > 0 {
			lines[line - 1]
		} else {
			''
		}

		row_below := if line < lines.len - 1 {
			lines[line + 1]
		} else {
			''
		}

		for gear in gear_idxs {
			mut adjacent_part_numbers := []int{}

			right_substr := line_str[gear + 1..]

			if right_substr[0].is_digit() {
				if right_val := utils.String.get_first_int(right_substr) {
					adjacent_part_numbers << right_val
				}
			}

			left_substr := line_str[0..gear]

			if left_substr[left_substr.len - 1].is_digit() {
				if left_val := utils.String.get_first_int_r(left_substr) {
					adjacent_part_numbers << left_val
				}
			}

			if !row_above.is_blank() {
				matches_str := reg.find_all_str(row_above)
				matches_idx := arrays.window(reg.find_all(row_above), size: 2, step: 2)
				mut matches := []Match{}

				if matches_str.len > 0 {
					for i := 0; i < matches_str.len; i++ {
						m := matches_str[i]
						matches << Match{
							val: m.int()
							idx_start: matches_idx[i][0]
							idx_end: matches_idx[i][1] - 1
						}
					}
				}

				for m in matches {
					start_match := m.idx_start == gear || m.idx_start == gear + 1
					middle_match := m.idx_start + 1 == gear
					end_match := m.idx_end == gear || m.idx_end == gear - 1

					if start_match || middle_match || end_match {
						adjacent_part_numbers << m.val
					}
				}
			}

			if !row_below.is_blank() {
				matches_str := reg.find_all_str(row_below)
				matches_idx := arrays.window(reg.find_all(row_below), size: 2, step: 2)
				mut matches := []Match{}

				if matches_str.len > 0 {
					for i := 0; i < matches_str.len; i++ {
						m := matches_str[i]
						matches << Match{
							val: m.int()
							idx_start: matches_idx[i][0]
							idx_end: matches_idx[i][1] - 1
						}
					}
				}

				for m in matches {
					start_match := m.idx_start == gear || m.idx_start == gear + 1
					middle_match := m.idx_start + 1 == gear
					end_match := m.idx_end == gear || m.idx_end == gear - 1

					if start_match || middle_match || end_match {
						adjacent_part_numbers << m.val
					}
				}
			}
			// println('found gear: col ${gear} ln ${line + 1} adjacent_numbers: ${adjacent_part_numbers}')

			if adjacent_part_numbers.len == 2 {
				sum += adjacent_part_numbers[0] * adjacent_part_numbers[1]
			}
		}
	}
	return sum
}
