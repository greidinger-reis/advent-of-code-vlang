import time
import flag
import os
import net.http

const base_url = 'https://adventofcode.com'

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
		return error(req.body)
	}

	mut file := os.open_file(i.out_path, 'w')!
	defer {
		file.close()
	}

	dump(req)
	file.write_string(req.body)!
}

mut fp := flag.new_flag_parser(os.args)

fp.application('Advent of code input fetcher')
fp.version('0.0.1')
fp.description('Fetches the input for a given day and year')

current_year := time.now().year
current_day := time.now().day

year := fp.int('year', `y`, current_year, 'The current year to get input.')
day := fp.int('day', `d`, current_day, 'The day to get input.')
session_token_path := fp.string('token', `t`, 'session_token', 'Path to the file containing the session token.')
out_path := fp.string_opt('out', `o`, 'Path to write the input.') or {
	eprintln('Output path not provided.\n')
	exit(1)
}

fp.finalize() or { panic(err) }

if day > 25 {
	eprintln('Invalid day for advent of code (must be <= 25)\n')
	exit(1)
}

session_token := os.read_file(session_token_path) or {
	eprintln('Session token filepath not found.\n')
	exit(1)
}

mut input := Input.new(u32(year), u32(day), session_token, out_path)

input.write() or {
	eprintln('Could not write input for day:${day} (${err})')
	exit(1)
}

println('Input for day: ${day} written to ${out_path}')
exit(0)
