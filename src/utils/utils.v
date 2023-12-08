module utils

import os

pub struct Rune {}

pub struct String {}

pub fn Rune.to_int(r rune) ?int {
	digit := r.str().int()

	if digit == 0 {
		return none
	}

	return digit
}

// string_get_first_int takes a line and an index and returns the first int
pub fn String.get_first_int(str string) ?int {
	if str.len == 0 {
		return none
	}
	mut final_str := ''

	for i := 0; i < str.len; i++ {
		ch := str[i]
		if ch.is_digit() {
			final_str += ch.ascii_str()
		}
	}

	if final_str.is_blank() {
		return none
	}

	return final_str.int()
}

// string_get_first_int_r takes a line and an index and returns the leftmost full int
pub fn String.get_first_int_r(str string) ?int {
	if str.len == 0 {
		return none
	}
	mut final_str := ''

	for i := str.len - 1; i >= 0; i-- {
		ch := str[i]
		if ch.is_digit() {
			final_str = ch.ascii_str() + final_str
		}
	}

	if final_str.is_blank() {
		return none
	}

	return final_str.int()
}

pub fn get_actual_input(file_path string) string {
	mut path := file_path.split('/')
	path.pop()
	path << 'input'

	return os.read_file(path.join('/')) or { panic(err) }
}

pub fn get_example_input(file_path string, part int) string {
	file_name := if part == 1 { 'example_input' } else { 'example_input_2' }
	mut path := file_path.split('/')
	path.pop()
	path << file_name

	return os.read_file(path.join('/')) or { panic(err) }
}
