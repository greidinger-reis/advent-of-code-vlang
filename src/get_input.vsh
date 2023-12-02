import time
import flag
import os
import net.http

const base_url = 'https://adventofcode.com'

fn parse_args() Input {
	token := os.read_file('session_token') or { panic(err) }
	mut fp := flag.new_flag_parser(os.args)
	fp.application('Advent of code input fetcher')
	fp.version('0.0.1')
	fp.description('Fetches the input for a given day and year')

	current_year := time.now().year
	current_day := time.now().day

	if current_day > 25 {
		panic('Advent of code is over for this year')
	}

	year := fp.int('year', `y`, current_year, 'usage: -y <year>')
	day := fp.int('day', `d`, current_day, 'usage: -d <day>')
	out_path := fp.string('out', `o`, 'input.txt', 'usage: -o <path>')

	return Input.new(u32(year), u32(day), token, out_path)
}

@[noinit]
struct Input {
	year          u32    @[required]
	day           u32    @[required]
	session_token string @[required]
	out_path      string @[required]
}

fn Input.new(year u32, day u32, session_token string, out_path string) Input {
	return Input{
		year: year
		day: day
		session_token: session_token
		out_path: out_path
	}
}

fn (mut i Input) write() ! {
	url := '${base_url}/${i.year}/day/${i.day}/input'
	cookies := {
		'session': i.session_token
	}
	req := http.fetch(url: url, cookies: cookies)!
	if req.status_code != 200 {
		panic('Failed to fetch input')
	}

	mut file := os.open_append(i.out_path)!
	defer {
		file.close()
	}

	file.write_string(req.body) or { panic(err) }
}

mut input := parse_args()

input.write() or { panic(err) }
