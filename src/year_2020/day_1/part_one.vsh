import os

const example_input = '1721\n979\n366\n299\n675\n1456'
const actual_input = os.read_lines(@FILE.replace('vsh', 'txt')) or { panic(err) }
const sum_search = 2020

// 1. Sort by highest
// 2. Eliminate every entry that is > 2020
// 3. Iterate over them and find the one that sums to 2020
fn part_1(input []string) int {
	numbers := input.map(it.int()).sorted(b < a)

	for i := 0; i < numbers.len; i++ {
		n := numbers[i]
		if n > sum_search {
			continue
		}

		for j := i + 1; j < numbers.len; j++ {
			n2 := numbers[j]

			if n + n2 > sum_search {
				continue
			}

			for k := j + 1; k < numbers.len; k++ {
				n3 := numbers[k]
				// println('n: ${n}, m: ${m}, m2: ${m2} sum: ${n + m + m2}')
				if n + n2 + n3 == sum_search {
					product := n * n2 * n3
					return product
				}
			}
		}
	}

	return -1
}

dump(part_1(actual_input))
