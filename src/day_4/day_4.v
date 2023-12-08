module day_4

import utils
import arrays

const filepath = @FILE
pub const input = utils.get_actual_input(filepath)
pub const example_input = utils.get_example_input(filepath, 1)
pub const example_output = 13
pub const example_output_part_2 = 30

struct Card {
	number          int
	winning_numbers []int
	my_numbers      []int
}

fn (c &Card) calc_points() int {
	mut points := 0
	for number in c.my_numbers {
		if number in c.winning_numbers {
			if points == 0 {
				points = 1
			} else {
				points *= 2
			}
		}
	}

	return points
}

fn (c &Card) get_matches() int {
	return c.my_numbers.filter(it in c.winning_numbers).len
}

fn (cards []&Card) get_copies_from_win(card_number int) []&Card {
	// -1 because card numbers start at 1
	card := cards[card_number - 1]
	matches := card.get_matches()

	if matches < 1 {
		return []
	}

	idx_end := if card.number + matches > cards.len {
		cards.len
	} else {
		card.number + matches
	}

	return cards[card_number..idx_end]
}

fn recursive_proccess_copies(cards []&Card, current_card &Card, mut card_map map[int]int, remaining int) {
	card_map[current_card.number] += 1

	if remaining == 0 {
		return
	}

	copies := cards.get_copies_from_win(current_card.number)
	// println('current_card: ${current_card.number}, remaining: ${remaining} copies: ${copies.map(it.number)}')

	for copy in copies {
		recursive_proccess_copies(cards, copy, mut card_map, copy.get_matches())
	}
}

fn (cards []&Card) process_win_copies() map[int]int {
	mut processed := map[int]int{}

	for original_card in cards {
		processed[original_card.number] = 0
	}

	for card in cards {
		recursive_proccess_copies(cards, card, mut processed, card.get_matches())
	}

	return processed
}

fn Card.from_line(line string) &Card {
	parts := line.split(':')
	card_number := utils.String.get_first_int(parts[0]) or { panic('no card number') }
	number_lists := parts[1].split(' | ')
	winning_numbers := number_lists[0].trim_left(' ').split(' ').map(it.int())
	my_numbers := number_lists[1].split(' ').map(it.int()).filter(it != 0)

	return &Card{
		number: card_number
		winning_numbers: winning_numbers
		my_numbers: my_numbers
	}
}

pub fn part_1(input string) int {
	lines := input.split_into_lines()
	mut sum := 0

	for line in lines {
		card := Card.from_line(line)
		sum += card.calc_points()
	}

	return sum
}

pub fn part_2(input string) int {
	lines := input.split_into_lines()
	cards := lines.map(Card.from_line(it))
	card_map := cards.process_win_copies()

	return arrays.sum(card_map.values()) or { panic('sum failed') }
}
