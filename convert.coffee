fs = require('fs')
js2coffee = require('js2coffee')

fs.readFile('README.md', 'utf-8', (err, data) ->
	if err
		console.log(err)
		return

	data = data.replace(/```javascript([^`]+)```/g, (match, js) ->
		try
			"```coffeescript\n#{js2coffee.build(js).code}\n```"
		catch error
			try
				# see if a closing brace fixes the syntax issue
				"```coffeescript\n#{js2coffee.build(js + '}').code}\n```"
			catch error
				# just return the original javascript, then
				match
	)

	fs.writeFile('README.coffee.md', data, (err) ->
		if err
			console.log(err)
	)
)
