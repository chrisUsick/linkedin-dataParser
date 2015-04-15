var DataParser, marked;

marked = require('marked');

DataParser = (function() {
  var identities;

  function DataParser() {}

  identities = {
    positions: 'id',
    skills: 'id'
  };

  DataParser.parse = function(data, userData) {
    var j, len, parsed, pos, positions, value, x;
    if (userData == null) {
      userData = {};
    }
    parsed = Object.create(data);
    parsed.skills = (function() {
      var j, len, ref, results;
      ref = data.skills.values;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        value = ref[j];
        results.push(x = {
          name: value.skill.name,
          id: value.id
        });
      }
      return results;
    })();
    positions = JSON.parse(JSON.stringify(data.positions.values));
    for (j = 0, len = positions.length; j < len; j++) {
      pos = positions[j];
      pos.company = pos.company && pos.company.name;
    }
    parsed.positions = positions;
    parsed.md = marked;
    parsed = DataParser.mixin(parsed, userData);
    return parsed;
  };

  DataParser.mixin = function(sourceObj, target) {
    var id, source, targKey, targVal;
    source = Object.create(sourceObj);
    if (!target.hide) {
      for (targKey in target) {
        targVal = target[targKey];
        if (typeof targVal !== 'object' && typeof targVal !== 'function' || !source[targKey]) {
          source[targKey] = targVal;
        } else if (targVal instanceof Array && source[targKey]) {
          id = identities[targKey];
          source[targKey] = DataParser.mixinArray(source[targKey], targVal, id);
        } else if (typeof targVal === 'object' && typeof targVal !== 'function') {
          source[targKey] = DataParser.mixin(source[targKey], targVal);
        }
      }
    } else {
      source = void 0;
    }
    return source;
  };

  DataParser.mixinArray = function(sourceArray, target, id) {
    var el, i, index, j, k, len, len1, results, source, x;
    source = sourceArray.slice(0);
    for (j = 0, len = target.length; j < len; j++) {
      el = target[j];
      index = ((function() {
        var k, len1, results;
        results = [];
        for (i = k = 0, len1 = source.length; k < len1; i = ++k) {
          x = source[i];
          if (x[id] === el[id]) {
            results.push(i);
          }
        }
        return results;
      })())[0];
      if (source[index]) {
        source[index] = DataParser.mixin(source[index], el);
        if (!source[index]) {
          source.splice(index, 1);
        }
      } else {
        source.push(el);
      }
    }
    results = [];
    for (k = 0, len1 = source.length; k < len1; k++) {
      x = source[k];
      if (x) {
        results.push(x);
      }
    }
    return results;
  };

  return DataParser;

})();

module.exports = DataParser;
