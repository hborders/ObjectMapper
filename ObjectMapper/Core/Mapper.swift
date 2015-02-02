//
//  Mapper.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2014-10-09.
//  Copyright (c) 2014 hearst. All rights reserved.
//

import Foundation

public protocol Mappable {
	mutating func map(mapper: Mapper)
	init()
}

enum MappingType {
	case fromJSON
	case toJSON
}

public class Mapper {
	var JSONDictionary: [String : AnyObject] = [:]
	var currentValue: AnyObject?
	var currentKey: String?
	var mappingType: MappingType = .fromJSON

	public init(){

	}

	/**
	* Sets the current mapper value and key
	*/
	public subscript(key: String) -> Mapper {
		// save key and value associated to it
		currentKey = key
		currentValue = valueFor(key)

		return self
	}

	// MARK: Public Mapping functions
	
	/**
	* Map a JSON string onto an existing object
	*/
	public func map<N: Mappable>(string JSONString: String, var toObject object: N) -> N! {
		if let JSON = parseJSONDictionary(JSONString) {
			return map(JSON, toObject: object)
		}
		return nil
	}

	/**
	* Map a JSON string to an object that conforms to Mappable
	*/
	public func map<N: Mappable>(string JSONString: String, toType type: N.Type) -> N! {
		if let JSON = parseJSONDictionary(JSONString) {
			return map(JSON, toType: type)
		}
		return nil
	}

	/**
	* Maps a JSON dictionary to an object that conforms to Mappable
	*/
	public func map<N: Mappable>(JSON: [String : AnyObject], toType type: N.Type) -> N! {
		let object = N()
		return map(JSON, toObject: object)
	}

	/**
	* Maps a JSON dictionary to an existing object that conforms to Mappable.
	* Usefull for those pesky objects that have crappy designated initializers like NSManagedObject
	*/
	public func map<N: Mappable>(JSON: [String : AnyObject], var toObject object: N) -> N! {
		mappingType = .fromJSON
		self.JSONDictionary = JSON
		object.map(self)
		return object
	}

	/**
	* Maps a JSON array to an object that conforms to Mappable
	*/
	public func mapArray<N: Mappable>(string JSONString: String, toType type: N.Type) -> [N] {
		if let JSONArray = parseJSONArray(JSONString) {
			return mapArray(JSONArray, toType: type)
		}

		// failed to parse JSON into array form
		// try to parse it into a dictionary and then wrap it in an array
		if let JSONDict = parseJSONDictionary(JSONString) {
			return mapArray([JSONDict], toType: type)
		}

		return []
	}
	
	/**
	* Maps a JSON dictionary to an array of object that conforms to Mappable
	*/
	public func mapArray<N: Mappable>(JSON: [[String : AnyObject]], toType type: N.Type) -> [N] {
		return JSON.map {
			self.map($0, toType: type)
		}		
	}

	// MARK: public toJSON functions
	
	/**
	* Maps an object that conforms to Mappable to a JSON dictionary <String : AnyObject>
	*/
	public func toJSON<N: Mappable>(var object: N) -> [String : AnyObject] {
		mappingType = .toJSON

		self.JSONDictionary = [String : AnyObject]()
		object.map(self)

		return self.JSONDictionary
	}

	
	/** 
	* Maps an array of Objects to an array of JSON dictionaries [[String : AnyObject]]
	*/
	public func toJSONArray<N: Mappable>(array: [N], toType: N.Type) -> [[String : AnyObject]] {
		return array.map {
			self.toJSON($0)
		}
	}

	/** 
	* Maps an Object to a JSON string
	*/
	public func toJSONString<N: Mappable>(object: N, prettyPrint: Bool) -> String! {
		let JSONDict = toJSON(object)

		var err: NSError?
		if NSJSONSerialization.isValidJSONObject(JSONDict) {
			let options: NSJSONWritingOptions = prettyPrint ? .PrettyPrinted : .allZeros
			let JSONData: NSData? = NSJSONSerialization.dataWithJSONObject(JSONDict, options: options, error: &err)
			if let error = err {
				println(error)
			}

			if let JSON = JSONData {
				return NSString(data: JSON, encoding: NSUTF8StringEncoding)
			}
		}

		return nil
	}

	// MARK: Private methods

	/** 
	* Fetch value from JSON dictionary 
	*/
	private func valueFor<N>(key: String) -> N? {
		// key can the form "distance.value", to allow mapping to sub objects

		// break down the components of the key and loop through them until we reach the desired object
		let components = key.componentsSeparatedByString(".")
		var index = 0
		var temp = JSONDictionary
		while index < components.count {
			let currentKey = components[index]
			if index == components.count - 1 {
				return temp[currentKey] as? N
			} else {
				if temp[currentKey] is NSNull {
					return nil
				}
				if let dict = temp[currentKey] as [String : AnyObject]? {
					temp = dict
					index++
				} else {
					return nil
				}
			}
		}

		return (JSONDictionary[key] as? N)
	}

	// MARK: Private utility functions for converting strings to JSON objects
	
	/** 
	* Convert a JSON String into a Dictionary<String, AnyObject> using NSJSONSerialization 
	*/
	private func parseJSONDictionary(JSON: String) -> [String : AnyObject]? {
		let parsedJSON: AnyObject? = parseJSONString(JSON)
		if let JSONDict = parsedJSON as? [String : AnyObject] {
			return JSONDict
		}

		return nil
	}

	/** 
	* Convert a JSON String into a Array<String, AnyObject> using NSJSONSerialization 
	*/
	private func parseJSONArray(JSON: String) -> [[String : AnyObject]]? {
		let parsedJSON: AnyObject? = parseJSONString(JSON)
		if let JSONArray = parsedJSON as? [[String : AnyObject]] {
			return JSONArray
		}

		return nil
	}

	/** 
	* Convert a JSON String into an Object using NSJSONSerialization 
	*/
	private func parseJSONString(JSON: String) -> AnyObject? {
		let data = JSON.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
		if let data = data {
			var error: NSError?
			let parsedJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error)
			return parsedJSON
		}

		return nil
	}

}
