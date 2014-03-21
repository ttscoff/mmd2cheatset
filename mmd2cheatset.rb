#!/usr/bin/ruby
require 'yaml'

if RUBY_VERSION.to_f > 1.9
	Encoding.default_external = Encoding::UTF_8
	Encoding.default_internal = Encoding::UTF_8
end

def show_usage
	puts "#{File.basename(__FILE__,'.rb')}: Convert MultiMarkdown document to cheatset format}"
	puts "Usage: #{__FILE__} filename.md"
	Process.exit
end


if ARGV.length > 0
	if ARGV[0] =~ /^(debug|test)$/
		input = DATA.read
	else
		infile = File.expand_path(ARGV[0])

		if File.exists?(infile)
			input = IO.read(infile)
		else
			puts "File not found: #{infile}"
			Process.exit 1
		end
	end
elsif STDIN.stat.size > 0
	input = STDIN.read
	if RUBY_VERSION.to_f > 1.9
		input = input.force_encoding('utf-8')
	end
else
	show_usage
end

class String
	def esc
		self.gsub(/(')/,"\\\\'")
	end
end

def convert_table(input)
	category = {}
	commands = []
	in_body = false
	input.split(/[\n\r]/).each { |line|
		if in_body
			case line.strip
			when /^\|?(.*?)\|(.*?)\|(.*?)\|?\s*$/u
				name = $1 || ''
				cmds = $2 || ''
				note = $3 || ''
				cmds = cmds.split(/,/).map {|x| x.strip }
				commands.push({ 'name' => name.strip, 'commands' => cmds, 'note' => note.strip })
			when /^\[(.*?)\]$/
				category['id'] = $1
			end
		else
			in_body = true if line =~ /(\|?\s*[:\-]+\s*\|?)/
		end
	}
	category['commands'] = commands

	return false unless category['id'] && category['commands'].length > 0
	category
end

categories = []
headers = nil

input.sub!(/(?i-m)(\S+:[\s\S]*?\n)+/) {|m|
	headers = YAML.load(m.strip)
	""
}

unless headers.has_key?('keyword')
	puts 'Cheatsheet must have a "keyword" header'
	puts 'Using "test"'
	headers['keyword'] = 'test'
end

if headers.has_key?('resources') && !File.exists?(headers['resources'])
	puts "You specified a resources folder, but #{headers['resources']} doesn't seem to exist."
	Process.exit 1
end

input.gsub!(/^\s{0,3}(\|?\s*name\s*\|\s*command\s*\|\s*note\s*\|?.*?\[.*?\])\s*$/ismu) {|m|
	categories.push(convert_table(m.strip))
	""
}

other = input.split(/^\-{3,}/).map{|s| s.strip }.delete_if{|s| s == '' }

if other
	headers['notes'] = other.pop if other.length > 1
	headers['introduction'] = other.join("\n\n")
end

# tables = input.strip.scan(/^\s{0,3}(\|?\s*name\s*\|\s*command\s*\|\s*note\s*\|?.*?\[.*?\])\s*$/ismu)
# tables.each {|table|
# 	categories.push(convert_table(table[0].strip))
# }


resources = headers.has_key?('resources') ? "\n\tresources '#{headers['resources']}'" : ""
intro = headers.has_key?('introduction') ? "\n\tintroduction <<-'END'\n#{headers['introduction']}\nEND" : ""
output = "cheatsheet do\n\ttitle '#{headers['title'].esc}'\n\tdocset_file_name '#{headers['name'].esc}'\n\tkeyword '#{headers['keyword']}'#{resources}#{intro}\n"

categories.each {|cat|
	next unless cat
	output += "\tcategory do\n\t\tid '#{cat['id'].esc}'\n"
	cat['commands'].each do |cmd|
		note = cmd['note'] == "" ? "" : %Q{\t\t\tnotes %(#{cmd['note'].esc})\n}
		new_commands = ""
		cmd['commands'].each {|c|
			next if c.nil? || c.strip == ""
			new_cmd =<<EOC
			command '#{c.esc}'
EOC
			new_commands += new_cmd
		}
		output += %Q{\t\tentry do\n\t\t\tname '#{cmd['name'].esc}'\n#{new_commands}\n#{note}\t\tend\n}
	end
	output += "\tend\n"
}
output += "\n\tnotes <<-'END'\n#{headers['notes']}\nEND" if headers.has_key?('notes')
output += "\nend"

title = headers['title'] + ".cheatsheet.txt"
File.open(title, 'w+') do |f|
	f.puts output
end
puts "Wrote template to #{title}"
puts "Generating #{headers['name']}.docset"
exec "cheatset generate '#{title}'"

__END__
title: Test Docset
name: Test
keyword: test
resources: resource_folder

The metadata headers in the file serve as the main keys for cheatset. All but the 'resources' key are required, I believe (and if it's used, the folder must be present). This text between headers and the first table becomes the intro text.

Tables must start with `|name|command|note|` (wording verbatim, additional spaces ok) and end with a `[label]` (standard MultiMarkdown).

|      name      |  command  |         note        |
|----------------|-----------|---------------------|
| Do something   | ⌘B        | This does something |
| Something else | ^⌘K, ⎋    | comma creates multiple command options |
| Crazy          | ⌘⇧⌥^S     | Only for weirdos.   |
Bollocks         | ALT | simpler row formatting works, too
[General Commands]

|name|command|note|
|----|-------|----|
|Do something else|⌘B||
|Something worse|^⌘K||
|End it all| ⌘⌥⇧⎋||
[Secondary Commands]

---

You can have as many tables (categories) as you want. Give them all unique labels beneath them. If you want a note at the end of the doc like this, just put it after a horizontal rule (`---`).
