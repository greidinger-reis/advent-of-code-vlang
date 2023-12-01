module utils

import os

pub struct Array {}

pub struct Rune {}

pub fn Array.sum(arr []int) int {
	mut total := 0

	for i in arr {
		total += i
	}

	return total
}

pub fn Rune.to_int(r rune) ?int {
	digit := r.str().int()

	if digit == 0 {
		return none
	}

	return digit
}

pub fn get_actual_input(file_path string) string {
	return os.read_file(file_path.replace('.v', '.txt')) or { panic(err) }
}

pub fn get_example_input(file_path string) string {
	return os.read_file(file_path.replace('.v', '.example.txt')) or { panic(err) }
}
