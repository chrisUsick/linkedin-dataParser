# README
This is a Package used to parse data from linkedIn API (from a profile) and mixin other data to override/add to the linkedIn data.

# API
## `DataParser.parse(linkedInProfile, additionalData) : Object`  
Takes in a raw linkedIn profile object, and add mixes in `additionalData` to it. Arrays of items such as `linkedInProfile.skills` are merged with i `additionalData` such that items with the same identifier (usually an `id` property) are overrode and new items are added.  
the `hide` attribute will cause this method to remove the item from the array.  
Read tests to know how to use.
