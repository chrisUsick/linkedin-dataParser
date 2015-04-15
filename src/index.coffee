marked = require 'marked'
class DataParser
	identities =
		positions: 'id'
		skills: 'id'
	@parse: (data, userData = {}) ->
		parsed = Object.create data

		parsed.skills = ( x = name:value.skill.name, id: value.id for value in data.skills.values)


		# parsed.positions = (x.company = x.company and x.company.name; x for x in data.positions.values)
		# have to use this technique to negate deep linking
		positions = JSON.parse JSON.stringify(data.positions.values)
		for pos in positions
			pos.company = pos.company and pos.company.name

		parsed.positions = positions
		# console.log parsed.positions
		# add marked to the parsed data
		parsed.md = marked
		parsed = DataParser.mixin parsed, userData
		# DataParser.mergeUserData parsed, userData
		parsed

	@mixin: (sourceObj, target) ->
		source = Object.create sourceObj
		if !target.hide
			# loop through props of target
			for targKey, targVal of target
				# if targVal is primitive or doesn't exist, overwrite
				if (typeof targVal != 'object' and typeof targVal != 'function' or !source[targKey])
					source[targKey] = targVal
				else if (targVal instanceof Array and source[targKey])
					id = identities[targKey]
					source[targKey] = DataParser.mixinArray source[targKey], targVal, id
				else if (typeof targVal == 'object' && typeof targVal != 'function')
					source[targKey] = DataParser.mixin source[targKey], targVal 
		else
			source = undefined
		source

	@mixinArray: (sourceArray, target, id) ->
		source = sourceArray.slice 0
		for el in target

			# console.log source
			index = (i for x,i in source when x[id] == el[id])[0]
			if source[index]
				source[index] = DataParser.mixin source[index], el
				# if #mixin() returned undefined, remove that item from the array
				if !source[index]
					source.splice index, 1
			else 
				source.push el

		(x for x in source when x)

module.exports = DataParser