//
//  ObjectMapperTests.swift
//  ObjectMapperTests
//
//  Created by Tristan Himmelman on 2014-10-16.
//  Copyright (c) 2014 hearst. All rights reserved.
//

import UIKit
import XCTest
import ObjectMapper

class ObjectMapperTests: XCTestCase {

    let userMapper = Mapper()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicParsing() {
        let username = "John Doe"
        let identifier = "user8723"
        let photoCount = 13
        let age = 1227
        let weight = 123.23
        let float: Float = 123.231
        let drinker = true
        let smoker = false
        let arr = [ "bla", true, 42 ]
        let birthday = NSDate(timeIntervalSince1970: 1398956159)
        let y2k = NSDate(timeIntervalSince1970: 946684800) // calculated via http://wolfr.am/2pliY~W9
        let directory = [
            "key1" : "value1",
            "key2" : false,
            "key3" : 142
        ]
        
        let subUserJSON = "{\"identifier\" : \"user8723\", \"drinker\" : true, \"age\": 17, \"birthdayOpt\" : 1398956159, \"y2kOpt\" : \"2000-01-01T00:00:00Z\", \"username\" : \"sub user\" }"
        
        let userJSONString = "{\"username\":\"\(username)\",\"identifier\":\"\(identifier)\",\"photoCount\":\(photoCount),\"age\":\(age),\"drinker\":\(drinker),\"smoker\":\(smoker), \"arr\":[ \"bla\", true, 42 ], \"dict\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 }, \"arrOpt\":[ \"bla\", true, 42 ], \"dictOpt\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 }, \"birthday\": 1398956159, \"birthdayOpt\": 1398956159, \"y2k\" : \"2000-01-01T00:00:00Z\", \"y2kOpt\" : \"2000-01-01T00:00:00Z\", \"weight\": \(weight), \"float\": \(float), \"friend\": \(subUserJSON), \"friendDictionary\":{ \"bestFriend\": \(subUserJSON)}}"
		
		let user = Mapper().map(string: userJSONString, toType: User.self)

        XCTAssertEqual(username, user.username, "Username should be the same")
        XCTAssertEqual(identifier, user.identifier!, "Identifier should be the same")
        XCTAssertEqual(photoCount, user.photoCount, "PhotoCount should be the same")
        XCTAssertEqual(age, user.age!, "Age should be the same")
        XCTAssertEqual(weight, user.weight!, "Weight should be the same")
        XCTAssertEqual(float, user.float!, "float should be the same")
        XCTAssertEqual(drinker, user.drinker, "Drinker should be the same")
        XCTAssertEqual(smoker, user.smoker!, "Smoker should be the same")
        XCTAssertEqual(birthday, user.birthday, "Birthday should be the same")
        XCTAssertEqual(birthday, user.birthdayOpt!, "Birthday should be the same")
        XCTAssertEqual(y2k, user.y2k, "Y2K date should be the same")
        XCTAssertEqual(y2k, user.y2kOpt!, "Y2K date should be the same")

        println(Mapper().toJSONString(user, prettyPrint: true))
    }
	
    func testInstanceParsing() {
        let username = "John Doe"
        let identifier = "user8723"
        let photoCount = 13
        let age = 1227
        let weight = 123.23
        let float: Float = 123.231
        let drinker = true
        let smoker = false
        let arr = [ "bla", true, 42 ]
        let birthday = NSDate(timeIntervalSince1970: 1398956159)
        let y2k = NSDate(timeIntervalSince1970: 946684800)
        let directory = [
            "key1" : "value1",
            "key2" : false,
            "key3" : 142
        ]
        
        let subUserJSON = "{\"identifier\" : \"user8723\", \"drinker\" : true, \"age\": 17,\"birthdayOpt\" : 1398956159, \"y2kOpt\" : \"2000-01-01T00:00:00Z\", \"username\" : \"sub user\" }"
        
        let userJSONString = "{\"username\":\"\(username)\",\"identifier\":\"\(identifier)\",\"photoCount\":\(photoCount),\"age\":\(age),\"drinker\":\(drinker),\"smoker\":\(smoker), \"arr\":[ \"bla\", true, 42 ], \"dict\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 }, \"arrOpt\":[ \"bla\", true, 42 ], \"dictOpt\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 }, \"birthday\": 1398956159, \"birthdayOpt\": 1398956159, \"y2k\" : \"2000-01-01T00:00:00Z\", \"y2kOpt\" : \"2000-01-01T00:00:00Z\", \"weight\": \(weight), \"float\": \(float), \"friend\": \(subUserJSON), \"friendDictionary\":{ \"bestFriend\": \(subUserJSON)}}"
        
        let user = Mapper().map(string: userJSONString, toObject: User())
        
        XCTAssertEqual(username, user.username, "Username should be the same")
        XCTAssertEqual(identifier, user.identifier!, "Identifier should be the same")
        XCTAssertEqual(photoCount, user.photoCount, "PhotoCount should be the same")
        XCTAssertEqual(age, user.age!, "Age should be the same")
        XCTAssertEqual(weight, user.weight!, "Weight should be the same")
        XCTAssertEqual(float, user.float!, "float should be the same")
        XCTAssertEqual(drinker, user.drinker, "Drinker should be the same")
        XCTAssertEqual(smoker, user.smoker!, "Smoker should be the same")
        XCTAssertEqual(birthday, user.birthday, "Birthday should be the same")
        XCTAssertEqual(birthday, user.birthdayOpt!, "Birthday should be the same")
        XCTAssertEqual(y2k, user.y2k, "Y2K date should be the same")
        XCTAssertEqual(y2k, user.y2kOpt!, "Y2K date should be the same")

        println(Mapper().toJSONString(user, prettyPrint: true))
    }
    
    func testDictionaryParsing() {
        var name: String = "Genghis khan"
        var UUID: String = "12345"
        var major: Int = 99
        var minor: Int = 1
        let json: [String: AnyObject] = ["name": name, "UUID": UUID, "major": major]
        
        //test that the sematics of value types works as expected.  the resulting maped student
        //should have the correct minor property set even thoug it's not mapped
        var s = Student()
        s.minor = minor
        let student = Mapper().map(json, toObject: s)
        
        XCTAssertEqual(student.name!, name, "Names should be the same")
        XCTAssertEqual(student.UUID!, UUID, "UUID should be the same")
        XCTAssertEqual(student.major!, major, "major should be the same")
        XCTAssertEqual(student.minor!, minor, "minor should be the same")
        
        //Test that mapping a reference type works as expected while not relying on the return value
        var username: String = "Barack Obama"
        var identifier: String = "Political"
        var photoCount: Int = 1000000000
        
        let json2: [String: AnyObject] = ["username": username, "identifier": identifier, "photoCount": photoCount]
        let user = User()
        Mapper().map(json2, toObject: user)
        XCTAssertEqual(user.username, username, "Usernames should be the same")
        XCTAssertEqual(user.identifier!, identifier, "identifiers should be the same")
        XCTAssertEqual(user.photoCount, photoCount, "photo count should be the same")
    }
    
	func testNestedKeys(){
		let heightInCM = 180.0
		
		let userJSONString = "{\"username\":\"bob\", \"height\": {\"value\": \(heightInCM), \"text\": \"6 feet tall\"} }"
		
		let user = Mapper().map(string: userJSONString, toType: User.self)

		XCTAssertEqual(user.heightInCM!, heightInCM, "Username should be the same")
	}
	
	func testNullObject() {
		let userJSONString = "{\"username\":\"bob\"}"
		
		let user = Mapper().map(string: userJSONString, toType: User.self)
		
		XCTAssert(user.heightInCM == nil, "Username should be the same")
	}
	
    func testToJSONAndBack(){
        var user = User()
        user.username = "tristan_him"
        user.identifier = "tristan_him_identifier"
        user.photoCount = 0
        user.age = 28
        user.weight = 150
        user.drinker = true
        user.smoker = false
        user.arr = ["cheese", 11234]
        user.birthday = NSDate()
        user.y2k = NSDate(timeIntervalSince1970: 946684800)
        user.imageURL = NSURL(string: "http://google.com/image/1234")
        user.intWithString = 12345
        
        let jsonString = Mapper().toJSONString(user, prettyPrint: true)
        println(jsonString)
		
		
		var parsedUser = Mapper().map(string: jsonString, toType: User.self)
		
        XCTAssertEqual(user.identifier!, parsedUser.identifier!, "Identifier should be the same")
        XCTAssertEqual(user.photoCount, parsedUser.photoCount, "PhotoCount should be the same")
        XCTAssertEqual(user.age!, parsedUser.age!, "Age should be the same")
        XCTAssertEqual(user.weight!, parsedUser.weight!, "Weight should be the same")
        XCTAssertEqual(user.drinker, parsedUser.drinker, "Drinker should be the same")
        XCTAssertEqual(user.smoker!, parsedUser.smoker!, "Smoker should be the same")
        XCTAssertEqual(user.imageURL!, parsedUser.imageURL!, "Image URL should be the same")
        XCTAssertEqual(user.intWithString, parsedUser.intWithString, "Int value from/to String should be the same")
//        XCTAssert(user.birthday.compare(parsedUser.birthday) == .OrderedSame, "Birthday should be the same")
        XCTAssert(user.y2k.compare(parsedUser.y2k) == .OrderedSame, "Y2k should be the same")
    }

    func testUnknownPropertiesIgnored() {
        let userJSONString = "{\"username\":\"bob\",\"identifier\":\"bob1987\", \"foo\" : \"bar\", \"fooArr\" : [ 1, 2, 3], \"fooObj\" : { \"baz\" : \"qux\" } }"
		let user = Mapper().map(string: userJSONString, toType: User.self)
        
        XCTAssert(user != nil, "User should not be nil")
    }
    
    func testInvalidJsonResultsInNilObject() {
        let userJSONString = "{\"username\":\"bob\",\"identifier\":\"bob1987\"" // missing ending brace

		let user = Mapper().map(string: userJSONString, toType: User.self)
		
        XCTAssert(user == nil, "User should be nil due to invalid JSON")
    }
	
	func testMapArrayJSON(){
		let name1 = "Bob"
		let name2 = "Jane"
		
		let arrayJSONString = "[{\"name\": \"\(name1)\", \"UUID\": \"3C074D4B-FC8C-4CA2-82A9-6E9367BBC875\", \"major\": 541, \"minor\": 123},{ \"name\": \"\(name2)\", \"UUID\": \"3C074D4B-FC8C-4CA2-82A9-6E9367BBC876\", \"major\": 54321,\"minor\": 13 }]"
	
		let students: [Student] = Mapper().mapArray(string: arrayJSONString, toType: Student.self)

		XCTAssert(!students.isEmpty, "Student Array should not be empty")
		XCTAssert(students.count == 2, "There should be 2 students in array")
		XCTAssert(students[0].name == name1, "First student's does not match")
		XCTAssert(students[1].name == name2, "Second student's does not match")
	}

	// test mapArray() with JSON string that is not an array form
	// should return a collection with one item
	func testMapArrayJSONWithNoArray(){
		let name1 = "Bob"
		
		let arrayJSONString = "{\"name\": \"\(name1)\", \"UUID\": \"3C074D4B-FC8C-4CA2-82A9-6E9367BBC875\", \"major\": 541, \"minor\": 123}"
		
		let students = Mapper().mapArray(string: arrayJSONString, toType: Student.self)

		XCTAssert(!students.isEmpty, "Student Array should not be empty")
		XCTAssert(students.count == 1, "There should be 1 student in array")
		XCTAssert(students[0].name == name1, "First student's does not match")
	}

	func testDoubleParsing(){
		
		let percentage1: Double = 0.1
		let percentage2: Double = 1792.41
		
		let JSON = "{ \"tasks\": [{\"taskId\":103,\"percentage\":\(percentage1)},{\"taskId\":108,\"percentage\":\(percentage2)}] }"
		
		let plan = Mapper().map(string: JSON, toType: Plan.self)
		
		if let tasks = plan.tasks {
			let task1 = tasks[0]
			XCTAssertEqual(task1.percentage!, percentage1, "Percentage 1 should be the same")
			
			let task2 = tasks[1]
			XCTAssertEqual(task2.percentage!, percentage2, "Percentage 2 should be the same")
		} else {
			XCTAssert(false, "Tasks not mapped")
		}
	}
	
	func testMappingAGenericObject(){
		let code: Int = 22
		let JSON = "{\"result\":{\"code\":\(code)}}"
		
		let response = Mapper().map(string: JSON, toType: Response<Status>.self)
		
		if let status = response.result?.status {
			XCTAssertEqual(status, code, "Code was not mapped correctly")
		} else {
			XCTAssert(false, "Generic object FAILED to map")
		}
	}

	func testToJSONArray(){
		var task1 = Task()
		task1.taskId = 1
		task1.percentage = 11.1
		var task2 = Task()
		task2.taskId = 2
		task2.percentage = 22.2
		var task3 = Task()
		task3.taskId = 3
		task3.percentage = 33.3
		
		var taskArray = [task1, task2, task3]
		
		let JSONArray = Mapper().toJSONArray(taskArray, toType: Task.self)
		println(JSONArray)
		
		let taskId1 = JSONArray[0]["taskId"] as Int
		let percentage1 = JSONArray[0]["percentage"] as Double
		
		XCTAssertEqual(taskId1, task1.taskId!, "TaskId1 was not mapped correctly")
		XCTAssertEqual(percentage1, task1.percentage!, "percentage1 was not mapped correctly")

		let taskId2 = JSONArray[1]["taskId"] as Int
		let percentage2 = JSONArray[1]["percentage"] as Double
		
		XCTAssertEqual(taskId2, task2.taskId!, "TaskId2 was not mapped correctly")
		XCTAssertEqual(percentage2, task2.percentage!, "percentage2 was not mapped correctly")
		
		let taskId3 = JSONArray[2]["taskId"] as Int
		let percentage3 = JSONArray[2]["percentage"] as Double
		
		XCTAssertEqual(taskId3, task3.taskId!, "TaskId3 was not mapped correctly")
		XCTAssertEqual(percentage3, task3.percentage!, "percentage3 was not mapped correctly")
	}

    func testISO8601DateTransformWithInvalidInput() {
        var JSON: [String: AnyObject] = ["y2kOpt": ""]
		let user1: User! = Mapper().map(JSON, toType: User.self)

        XCTAssert(user1 != nil, "ISO8601DateTransform must not crash for empty string")
        XCTAssert(user1.y2kOpt == nil, "ISO8601DateTransform should return nil for empty string")

        JSON["y2kOpt"] = "incorrect format"
		let user2: User! = userMapper.map(JSON, toType: User.self)

        XCTAssert(user2 != nil, "ISO8601DateTransform must not crash for incorrect format")
        XCTAssert(user2.y2kOpt == nil, "ISO8601DateTransform should return nil for incorrect format")
    }
    
    func testJsonToObjectModelOptionalDictionnaryOfPrimitives() {
        var json = ["dictStringString":["string": "string"], "dictStringBool":["string": false], "dictStringInt":["string": 1], "dictStringDouble":["string": 1.1], "dictStringFloat":["string": 1.2]]
		
		let testSet = Mapper().map(json, toType: TestCollectionOfPrimitives.self)
        
        XCTAssertTrue(testSet.dictStringString.count == 1)
        XCTAssertTrue(testSet.dictStringInt.count == 1)
        XCTAssertTrue(testSet.dictStringBool.count == 1)
        XCTAssertTrue(testSet.dictStringDouble.count == 1)
        XCTAssertTrue(testSet.dictStringFloat.count == 1)
    }
    
    func testObjectToModelDictionnaryOfPrimitives() {
        var object = TestCollectionOfPrimitives()
        object.dictStringString = ["string": "string"]
        object.dictStringBool = ["string": false]
        object.dictStringInt = ["string": 1]
        object.dictStringDouble = ["string": 1.2]
        object.dictStringFloat = ["string": 1.3]
        
		let json = Mapper().toJSON(object)
        
        XCTAssertTrue((json["dictStringString"] as [String:String]).count == 1)
        XCTAssertTrue((json["dictStringBool"] as [String:Bool]).count == 1)
        XCTAssertTrue((json["dictStringInt"] as [String:Int]).count == 1)
        XCTAssertTrue((json["dictStringDouble"] as [String:Double]).count == 1)
        XCTAssertTrue((json["dictStringFloat"] as [String:Float]).count == 1)
        let dict:[String: String] = json["dictStringString"] as [String:String]
        let value = dict["string"]! as String
        XCTAssertTrue(value == "string")
    }
	
	func testSubClasses(){
		
		var subclass = Subclass<String>()
		subclass.base = "base class var"
		subclass.sub = "subclass var"
		
		let string = Mapper().toJSONString(subclass, prettyPrint: true)
		println(string)
	}
}

class Response<T: Mappable>: Mappable {
	var result: T?
	
	required init() {
	}
	
	func map(mapper: Mapper) {
		result <= mapper["result"]
	}
}

class Status: Mappable {
	var status: Int?
	
	required init() {
	}
	
	func map(mapper: Mapper) {
		status <= mapper["code"]
	}
}

class Plan: Mappable {
	var tasks: [Task]?
	
	required init(){
		
	}
	
	func map(mapper: Mapper) {
		tasks <= mapper["tasks"]
	}
}

class Task: Mappable {
	var taskId: Int?
	var percentage: Double?
	
	required init(){
		
	}
	
	func map(mapper: Mapper) {
		taskId <= mapper["taskId"]
		percentage <= mapper["percentage"]
	}
}

// Confirm that struct can conform to `Mappable`
struct Student: Mappable {
	var name: String?
	var UUID: String?
	var major: Int?
	var minor: Int?
	
	init(){
		
	}
	
	mutating func map(mapper: Mapper) {
		name <= mapper["name"]
		UUID <= mapper["UUID"]
		major <= mapper["major"]
		minor <= mapper["minor"]
	}
}

class User: Mappable {
    
    var username: String = ""
    var identifier: String?
    var photoCount: Int = 0
    var age: Int?
    var weight: Double?
    var float: Float?
    var drinker: Bool = false
    var smoker: Bool?
    var arr: [AnyObject] = []
    var arrOptional: [AnyObject]?
    var dict: [String : AnyObject] = [:]
    var dictOptional: [String : AnyObject]?
	var dictString: [String : String]?
    var friendDictionary: [String : User]?
    var friend: User?
    var friends: [User]? = []
    var birthday: NSDate = NSDate()
    var birthdayOpt: NSDate?
    var y2k: NSDate = NSDate()
    var y2kOpt: NSDate?
    var imageURL: NSURL?
    var intWithString: Int = 0
	var heightInCM: Double?
	
    required init() {
		
    }
	
	func map(mapper: Mapper) {
		username         <= mapper["username"]
		identifier       <= mapper["identifier"]
		photoCount       <= mapper["photoCount"]
		age              <= mapper["age"]
		weight           <= mapper["weight"]
		float            <= mapper["float"]
		drinker          <= mapper["drinker"]
		smoker           <= mapper["smoker"]
		arr              <= mapper["arr"]
		arrOptional      <= mapper["arrOpt"]
		dict             <= mapper["dict"]
		dictOptional     <= mapper["dictOpt"]
		friend           <= mapper["friend"]
		friends          <= mapper["friends"]
		friendDictionary <= mapper["friendDictionary"]
		dictString		 <= mapper["dictString"]
		birthday         <= (mapper["birthday"], DateTransform<NSDate, Double>())
		birthdayOpt      <= (mapper["birthdayOpt"], DateTransform<NSDate, Double>())
        y2k              <= (mapper["y2k"], ISO8601DateTransform<NSDate, String>())
        y2kOpt           <= (mapper["y2kOpt"], ISO8601DateTransform<NSDate, String>())
		imageURL         <= (mapper["imageURL"], URLTransform<NSURL, String>())
        intWithString    <= (mapper["intWithString"], TransformOf<Int, String>(fromJSON: { $0?.toInt() }, toJSON: { $0.map { String($0) } }))
		heightInCM		 <= mapper["height.value"]
	}
	
    var description : String {
        return "username: \(username) \nid:\(identifier) \nage: \(age) \nphotoCount: \(photoCount) \ndrinker: \(drinker) \nsmoker: \(smoker) \narr: \(arr) \narrOptional: \(arrOptional) \ndict: \(dict) \ndictOptional: \(dictOptional) \nfriend: \(friend)\nfriends: \(friends) \nbirthday: \(birthday)\nbirthdayOpt: \(birthdayOpt) \ny2k: \(y2k) \ny2kOpt: \(y2k) \nweight: \(weight)"
    }
}

class TestCollectionOfPrimitives : Mappable {
    var dictStringString: [String: String] = [:]
    var dictStringInt: [String: Int] = [:]
    var dictStringBool: [String: Bool] = [:]
    var dictStringDouble: [String: Double] = [:]
    var dictStringFloat: [String: Float] = [:]
    var arrayString: [String] = []
    var arrayInt: [Int] = []
    var arrayBool: [Bool] = []
    var arrayDouble: [Double] = []
    var arrayFloat: [Float] = []
    
    required init() {}
    
    func map(mapper: Mapper) {
        dictStringString    <= mapper["dictStringString"]
        dictStringBool      <= mapper["dictStringBool"]
        dictStringInt       <= mapper["dictStringInt"]
        dictStringDouble    <= mapper["dictStringDouble"]
        dictStringFloat     <= mapper["dictStringFloat"]
        arrayString         <= mapper["arrayString"]
        arrayInt            <= mapper["arrayInt"]
        arrayBool           <= mapper["arrayBool"]
        arrayDouble         <= mapper["arrayDouble"]
        arrayFloat          <= mapper["arrayFloat"]
    }
}

class Base: Mappable {

	var base: String?
	
	required init(){
		
	}
	
	func map(mapper: Mapper) {
		base <= mapper["base"]
	}
}

class Subclass<T>: Base, Mappable {

	var sub: String?
	
	required init(){
		
	}

	override func map(mapper: Mapper) {
		super.map(mapper)
		
		sub <= mapper["sub"]
	}
}
