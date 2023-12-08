module day_4

import utils

const filepath = @FILE
pub const input = utils.get_actual_input(filepath)
pub const example_input = utils.get_example_input(filepath, 1)
pub const example_output = 13
pub const example_output_part_2 = 30
const example_cards_map_output = {
	1: 1
	2: 2
	3: 4
	4: 8
	5: 14
	6: 1
}

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

fn recursive_get_copies_from_card(cards []&Card, current_card &Card, mut card_map map[int]int, remaining int) {
	card_map[current_card.number] += 1

	if remaining == 0 {
		return
	}

	copies := cards.get_copies_from_win(current_card.number)

	for copy in copies {
		card_map[copy.number] += 1
		recursive_get_copies_from_card(cards, copy, mut card_map, remaining - 1)
	}
}

fn (cards []&Card) process_win_copies() map[int]int {
	mut processed := map[int]int{}

	for original_card in cards {
		processed[original_card.number] = 0
	}

	for card in cards {
		recursive_get_copies_from_card(cards, card, mut processed, card.get_matches())
	}

	return processed
}

fn Card.from_line(line string) &Card {
	parts := line.split(':')
	card_number := parts[0].split(' ')[1].int()
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
	mut sum := 0

	card_map := cards.process_win_copies()
	assert card_map == day_4.example_cards_map_output

	return sum
}
