chai = require 'chai'
chai.should()
# expect = chai.expect
jf = require 'jsonfile'
DataParser = require '../src/index'
data = jf.readFileSync './test/linkedInData.json'

describe 'DataParser.parse', ->
	parsed = {} 
	beforeEach () ->
		parsed = DataParser.parse data

	it 'should set skills to an array of objects with names', ->
		parsed.skills.length.should.equal data.skills._total

	it 'make each skill have a name property', ->
		x.name.should.exist for x in parsed.skills

	it 'should append marked to parsed data', ->
		(typeof parsed.md).should.equal 'function'

	it 'should make positions an array of job positions', ->
		for x in parsed.positions
			x.company.should.exist
			x.company.should.be.a('string')
			x.summary.should.exist

	it 'should make skills an array of (id, name) objects', ->
		for x in parsed.skills
			x.name.should.be.a 'string'
			x.id.should.exist

	it 'should remove items with visibility set to false', ->
		parsed = DataParser.parse data, {
			positions:[
				(
					id:591830271
					hide:true
				)
				(
					id:591831027
					hide: true
				)
			]
		}
		parsed.positions.length.should.equal 1

	it 'should mix in skills', ->
		parsed = DataParser.parse data, 
			skills:[
			    (
			      id:1
			      description:"I'm very talented!"
			    )
			  ]
		parsed.skills.filter((x) -> x.id == 1)[0].description.should.exist

describe '#mixin()', ->
	objOfPrimatives =
		foo: 10
		bar: "chris"

	it 'should add properties that source doesnt have', ->
		obj = Object.create objOfPrimatives
		x = DataParser.mixin obj, 
			baz: 10
			positions: [1,2,3]
		x.foo.should.equal objOfPrimatives.foo
		x.bar.should.equal objOfPrimatives.bar 
		x.baz.should.equal 10
		x.positions.should.exist

	it 'should replace primitive properties in the source', ->
		source = Object.create objOfPrimatives
		x = DataParser.mixin source, bar: "kimbo"
		x.bar.should.equal "kimbo"

	it 'should use #mixinArray() to handle arrays', ->
		source = Object.create objOfPrimatives
		source.positions = [
			{id:'tree'}	
			{id:'bird'}
		]
		x = DataParser.mixin source, positions: [{id:'tree'}, {id:'sky'}]	
		x.positions.length.should.equal 3

	it 'should remove items where target.hide is truthy', ->
		source = Object.create objOfPrimatives
		source.baz = a:1, b:2
		source.positions = [{id:1, name:'foo'}, {id:2, name:'bar'}]
		x = DataParser.mixin source, 
			baz: {hide:true}
			positions: [{id:1, hide:true}]
		x.should.satisfy (i) -> i.baz == undefined
		# x.should.not.have.property 'baz'
		x.positions.length.should.equal 1

describe '#mixinArray()', ->
	sourceBase = [{name:'chris', age:19}, {name:'kimbo', age:18}]

	it 'should add items that dont match to source', ->
		source = sourceBase.slice 0
		x = DataParser.mixinArray source, [{name:'john', age:10}], 'name'
		x.length.should.equal 3
		x[2].should.be.ok

	it 'should add merge elements in the array with same identity', ->
		source = sourceBase.slice 0
		x = DataParser.mixinArray source, [{name:'kimbo', age:19}], 'name'
		x.length.should.equal 2
		x[1].age.should.equal 19