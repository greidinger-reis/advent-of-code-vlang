module day_5

import utils
import arrays

const filename = @FILE
pub const input = utils.get_actual_input(filename)
pub const example_input = utils.get_example_input(filename, 1)
pub const example_output = 35

struct Range {
	destination_start int
	source_start      int
	len               int
}

pub fn part_1(input string) int {
	blocks := input.split('\n\n')
	rest := blocks[1..]
	seeds := blocks[0].split(': ')[1].split(' ').map(it.int())
	mut locations := seeds.map(u32(it))

	for part in rest {
		mut ranges := []Range{}

		for line in part.split_into_lines()[1..] {
			raw_range := line.split(' ').map(it.int())
			ranges << Range{
				destination_start: raw_range[0]
				source_start: raw_range[1]
				len: raw_range[2]
			}
		}

		mut new_locations := []u32{}

		for x in locations {
			mut in_range := false

			for range in ranges {
				if range.source_start <= x && x < range.source_start + range.len {
					new_locations << u32(x - range.source_start + range.destination_start)
					in_range = true

					break
				}
			}

			if !in_range {
				new_locations << x
			}
		}

		locations = new_locations.clone()
		println(locations)
	}

	return arrays.min(locations) or { 0 }
}
