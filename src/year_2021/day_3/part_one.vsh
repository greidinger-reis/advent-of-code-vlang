import math
import os

const actual_input = os.read_file(@FILE.replace('vsh', 'txt')) or { panic(err) }
const test_input = r'00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010'

fn binary_to_decimal(b []rune) int {
	mut result := 0
	for i := 0; i < b.len; i++ {
		if b[i] == `1` {
			result += int(math.pow(2, b.len - i - 1))
		}
	}
	return result
}

fn flip_bits(b []rune) []rune {
	mut result := []rune{}
	for i := 0; i < b.len; i++ {
		if b[i] == `1` {
			result << `0`
		} else {
			result << `1`
		}
	}
	return result
}

fn get_most_common_bit(bits [][]rune) []rune {
	mut most_common_bits := []rune{len: bits[0].len, init: `0`}

	for i := 0; i < most_common_bits.len; i++ {
		mut count0 := 0
		mut count1 := 0
		for j := 0; j < bits.len; j++ {
			if bits[j][i] == `1` {
				count1++
			} else {
				count0++
			}
		}
		if count1 > count0 {
			most_common_bits[i] = `1`
		} else {
			most_common_bits[i] = `0`
		}
	}

	return most_common_bits
}

fn part_1(input string) int {
	bits := input.split_into_lines().map(it.runes())
	gamma_rate := get_most_common_bit(bits)
	epsilon_rate := flip_bits(gamma_rate)
	gamma_rate_decimal := binary_to_decimal(gamma_rate)
	epsilon_rate_decimal := binary_to_decimal(epsilon_rate)
	return gamma_rate_decimal * epsilon_rate_decimal
}

dump(part_1(actual_input))
