fs = require('fs')
js2coffee = require('js2coffee')

fs.readFile('README.md', 'utf-8', (err, data) ->
	if err
		console.log(err)
		return

	data = data.replace(/\n([ \t]*)```javascript([^`]+)```/g, (match, indent, js) ->		
		try
			# convert javascript to coffeescript
			code = js2coffee.build(js).code
		catch error
			try
				# see if a closing brace fixes the syntax issue
				code = js2coffee.build(js + '}').code
			catch error
				# just return the original javascript, then
				return match
		# add back the same indentation to each line of the code
		code = code.replace(/\n/g, "\n#{indent}")
		# return in backtick code block with coffeescript highlighting
		"#{indent}```coffeescript\n#{indent}#{code}\n#{indent}```"
	)

	fs.writeFile('README.coffee.md', data, (err) ->
		if err
			console.log(err)
	)
)
