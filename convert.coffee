fs = require('fs')
js2coffee = require('js2coffee')

fs.readFile('README.md', 'utf-8', (err, data) ->
	if err
		console.log(err)
		return

	data = data.replace(/\n([ \t]*)```javascript([^`]+)```/g, (match, indent, js) ->
		try
			"#{indent}```coffeescript\n#{js2coffee.build(js).code}\n#{indent}```"
		catch error
			try
				# see if a closing brace fixes the syntax issue
				"#{indent}```coffeescript\n#{js2coffee.build(js + '}').code}\n#{indent}```"
			catch error
				# just return the original javascript, then
				match
	)

	fs.writeFile('README.coffee.md', data, (err) ->
		if err
			console.log(err)
	)
)
