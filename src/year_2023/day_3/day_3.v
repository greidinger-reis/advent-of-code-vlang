module day_3

import utils
import arrays
import regex

const file = @FILE
const pattern = r'\d*'
const pattern_symbols = r'[^\w\s.]'
pub const input = utils.get_actual_input(file)
pub const example_input = utils.get_example_input(file, 1)
pub const example_output = 4361

pub struct Match {
	val       int
	idx_start int
	idx_end   int
}

pub fn part_1(input string) int {
	lines := input.split_into_lines()
	mut reg := regex.regex_opt(day_3.pattern) or { panic('invalid regex') }
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
	}
	return sum
}
