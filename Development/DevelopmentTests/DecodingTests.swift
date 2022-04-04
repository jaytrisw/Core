import XCTest
@testable import Development

final class DecodingTests: XCTestCase {
    let decoder = JSONDecoder()

    enum ExampleKeys: CodingKey {
        case value
    }

    struct User: Equatable {
        var name: String
        var age: Int
        var city: String?

        enum CodingKeys: CodingKey {
            case name
            case age
            case city
        }
    }

    struct Account: Equatable {
        var id: UUID
        var user: User?

        enum CodingKeys: CodingKey {
            case id
            case user
        }
    }
    
    struct Some {
        var property1: Int
        var property2: Int
        var property3: Int
        var property4: Int
        var property5: Int
        var property6: Int
        var property7: Int
        var property8: Int
        var property9: Int
        
        enum CodingKeys: CodingKey {
            case property1
            case property2
            case property3
            case property4
            case property5
            case property6
            case property7
            case property8
            case property9
        }
    }

    func testMap_WithClosure() {
        XCTAssertEqual(
            "test string",
            try decoder.decode(
                "\"TEST STRING\"".data(using: .utf8)!,
                using: .singleValue.map { $0.lowercased() }
            )
        )
    }

    func testMap_WithKeypath() {
        XCTAssertEqual(
            5,
            try decoder.decode(
                "\"abcde\"".data(using: .utf8)!,
                using: Decoding<String>.singleValue.map(\.count)
            )
        )
    }

    func testCombiningDecoders_ZipWith() throws {
        let json = """
        {
            "name": "Joe Bloggs",
            "age": 18,
            "city": "London"
        }
        """

        let name = Decoding<String>
            .withKey(User.CodingKeys.name)

        let age = Decoding<Int>
            .withKey(User.CodingKeys.age)

        let city = Decoding<String>
            .optionalWithKey(User.CodingKeys.city)

        let user = try decoder.decode(
            json.data(using: .utf8)!,
            using: zip(name, age, city)
                .map(User.init)
        )

        XCTAssertEqual("Joe Bloggs", user.name)
        XCTAssertEqual(18, user.age)
        XCTAssertEqual("London", user.city)
    }
    
    func testCombiningDecoders_ZipWithAll() throws {
        let json = """
        {
            "property1": 1,
            "property2": 2,
            "property3": 3,
            "property4": 4,
            "property5": 5,
            "property6": 6,
            "property7": 7,
            "property8": 8,
            "property9": 9
        }
        """
        
        let property1 = Decoding<Int>
            .withKey(Some.CodingKeys.property1)
        
        let property2 = Decoding<Int>
            .withKey(Some.CodingKeys.property2)
        
        let property3 = Decoding<Int>
            .withKey(Some.CodingKeys.property3)
        
        let property4 = Decoding<Int>
            .withKey(Some.CodingKeys.property4)
        
        let property5 = Decoding<Int>
            .withKey(Some.CodingKeys.property5)
        
        let property6 = Decoding<Int>
            .withKey(Some.CodingKeys.property6)
        
        let property7 = Decoding<Int>
            .withKey(Some.CodingKeys.property7)
        
        let property8 = Decoding<Int>
            .withKey(Some.CodingKeys.property8)
        
        let property9 = Decoding<Int>
            .withKey(Some.CodingKeys.property9)
        
        let some = try decoder.decode(
            json.data(using: .utf8)!,
            using: zip(
                property1,
                property2,
                property3,
                property4,
                property5,
                property6,
                property7,
                property8,
                property9)
            .map(Some.init)
        )
        
        XCTAssertEqual(1, some.property1)
        XCTAssertEqual(2, some.property2)
        XCTAssertEqual(3, some.property3)
        XCTAssertEqual(4, some.property4)
        XCTAssertEqual(5, some.property5)
        XCTAssertEqual(6, some.property6)
        XCTAssertEqual(7, some.property7)
        XCTAssertEqual(8, some.property8)
        XCTAssertEqual(9, some.property9)
    }

    func testReplaceMissingValuesWithDefault() throws {
        let json = """
        {
            "name": "Joe Bloggs",
            "age": 18
        }
        """

        let name = Decoding<String>
            .withKey(User.CodingKeys.name)

        let age = Decoding<Int>
            .withKey(User.CodingKeys.age)

        let city = Decoding<String>
            .optionalWithKey(User.CodingKeys.city)
            .replaceNil(with: "Unknown")

        let user = try decoder.decode(
            json.data(using: .utf8)!,
            using: zip(name, age, city)
                .map(User.init)
        )

        XCTAssertEqual("Joe Bloggs", user.name)
        XCTAssertEqual(18, user.age)
        XCTAssertEqual("Unknown", user.city)
    }

    func testDecodingParentChildDecodings() throws {
        let json = """
        {
            "id": "00000000-0000-0000-0000-000000000001",
            "user": {
                "name": "Joe Bloggs",
                "age": 18,
                "city": "London"
            }
        }
        """

        let userDecoding = zip(
            Decoding<String>
                .withKey(User.CodingKeys.name),
            
            Decoding<Int>
                .withKey(User.CodingKeys.age),
            
            Decoding<String>
                .optionalWithKey(User.CodingKeys.city))
            .map(User.init)

        let accountDecoding = zip(
            Decoding<UUID>
                .withKey(Account.CodingKeys.id),

            userDecoding
                .withKey(Account.CodingKeys.user))
            .map(Account.init)

        let account = try decoder.decode(
            json.data(using: .utf8)!,
            using: accountDecoding
        )

        XCTAssertEqual(
            UUID(uuidString: "00000000-0000-0000-0000-000000000001"),
            account.id
        )

        XCTAssertEqual(
            User(name: "Joe Bloggs", age: 18, city: "London"),
            account.user
        )
    }

    func testDecodingParentChildDecodings_MissingOptionalChildValue() throws {
        let json = """
        {
            "id": "00000000-0000-0000-0000-000000000001"
        }
        """

        let userDecoding = zip(
            Decoding<String>
                .withKey(User.CodingKeys.name),

            Decoding<Int>
                .withKey(User.CodingKeys.age),

            Decoding<String>
                .optionalWithKey(User.CodingKeys.city))
            .map(User.init)

        let accountDecoding = zip(
            Decoding<UUID>
                .withKey(Account.CodingKeys.id),

            userDecoding
                .optionalWithKey(Account.CodingKeys.user))
            .map(Account.init)

        let account = try decoder.decode(
            json.data(using: .utf8)!,
            using: accountDecoding
        )

        XCTAssertEqual(
            UUID(uuidString: "00000000-0000-0000-0000-000000000001"),
            account.id
        )

        XCTAssertNil(account.user)
    }

    // MARK: - Decoding collections

    func testDecodingArrayOfSimpleValues() throws {
        let json = """
        [
            "one",
            "two",
            "three"
        ]
        """

        let strings = try decoder.decode(
            json.data(using: .utf8)!,
            using: Decoding<String>.array
        )

        XCTAssertEqual(["one", "two", "three"], strings)

        let uppercased = try decoder.decode(
            json.data(using: .utf8)!,
            using: Decoding<String>.arrayOf(.singleValue.map { $0.uppercased() })
        )

        XCTAssertEqual(["ONE", "TWO", "THREE"], uppercased)
    }

    func testDecodingArrayOfComplexValues() throws {
        let json = """
        [
          {
              "name": "Joe Bloggs",
              "age": 18
          },
          {
              "name": "Jane Doe",
              "age": 21,
              "city": "London"
          }
        ]
        """

        let name = Decoding<String>
            .withKey(User.CodingKeys.name)

        let age = Decoding<Int>
            .withKey(User.CodingKeys.age)

        let city = Decoding<String>
            .optionalWithKey(User.CodingKeys.city)

        let user = zip(name, age, city)
            .map(User.init)

        let users = try decoder.decode(
            json.data(using: .utf8)!,
            using: Decoding<User>.arrayOf(user)
        )

        XCTAssertEqual(
            users,
            [
                User(name: "Joe Bloggs", age: 18, city: nil),
                User(name: "Jane Doe", age: 21, city: "London")
            ]
        )
    }
    
    func testDecodingNestedDecodings() throws {
        struct Parent {
            let name: String
            let children: [Child]
            enum CodingKeys: String, CodingKey {
                case name
                case children
            }
        }
        
        struct Child {
            let name: String
            enum CodingKeys: String, CodingKey {
                case name
            }
        }
        
        let childDecoding = Decoding<String>.withKey(Child.CodingKeys.name)
                .map(Child.init)
        
        let parentDecoding = zip(
            Decoding<String>
                .withKey(Parent.CodingKeys.name),
            Decoding<Child>
                .arrayOf(childDecoding)
                .withKey(Parent.CodingKeys.children))
            .map(Parent.init)
        
        let json = """
            {
              "name" : "Anakin",
              "children" : [
                {
                  "name" : "Luke"
                },
                {
                  "name" : "Leia"
                }
              ]
            }
            """
        
        let parent = try decoder.decode(json.data(using: .utf8)!, using: parentDecoding)
        XCTAssertEqual(parent.name, "Anakin")
        XCTAssertEqual(parent.children.count, 2)
        
        XCTAssertTrue(parent.children.contains(where: { $0.name == "Luke" }))
        XCTAssertTrue(parent.children.contains(where: { $0.name == "Leia" }))
    }
    
    func testDecodingNestedDecodingOptionalWithKey() throws {
        struct Parent {
            let name: String
            let children: [Child]?
            enum CodingKeys: String, CodingKey {
                case name
                case children
            }
        }
        
        struct Child {
            let name: String
            enum CodingKeys: String, CodingKey {
                case name
            }
        }
        
        let childDecoding = Decoding<String>.withKey(Child.CodingKeys.name)
                .map(Child.init)
        
        let parentDecoding = zip(
            Decoding<String>.withKey(Parent.CodingKeys.name),
            Decoding<Child>
                .arrayOf(childDecoding)
                .optionalWithKey(Parent.CodingKeys.children))
            .map(Parent.init)
        
        let json = """
            {
              "name" : "Yoda"
            }
            """
        
        let parent = try decoder.decode(json.data(using: .utf8)!, using: parentDecoding)
        XCTAssertEqual(parent.name, "Yoda")
        XCTAssertNil(parent.children)
    }

    // MARK: - Built-in decodings

    func testDecoding_UInt16() throws {
        XCTAssertEqual(
            UInt16(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            UInt16(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            UInt16(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt16>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<UInt16>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt16>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<UInt16>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt16>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<UInt16>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt16>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<UInt16>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt16>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<UInt16>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt16>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<UInt16>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Int64() throws {
        XCTAssertEqual(
            Int64(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            Int64(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            Int64(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int64>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<Int64>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int64>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<Int64>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int64>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<Int64>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int64>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<Int64>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int64>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<Int64>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int64>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<Int64>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Int8() throws {
        XCTAssertEqual(
            Int8(-123),
            try decoder.decode(
                "-123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            Int8(-123),
            try decoder.decode(
                "[-123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            Int8(-123),
            try decoder.decode(
                "{\"value\":-123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int8>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<Int8>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int8>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<Int8>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int8>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<Int8>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int8>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<Int8>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int8>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<Int8>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int8>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<Int8>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Double() throws {
        XCTAssertEqual(
            Double(123.5),
            try decoder.decode(
                "123.5".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            Double(123.5),
            try decoder.decode(
                "[123.5]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            Double(123.5),
            try decoder.decode(
                "{\"value\":123.5}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Double>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<Double>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Double>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<Double>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Double>.some(123.5),
            try decoder.decode(
                "[123.5]".data(using: .utf8)!,
                using: Decoding<Double>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Double>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<Double>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Double>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<Double>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Double>.some(123.5),
            try decoder.decode(
                "{\"value\":123.5}".data(using: .utf8)!,
                using: Decoding<Double>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_String() throws {
        XCTAssertEqual(
            "Test String",
            try decoder.decode(
                "\"Test String\"".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            "Test String",
            try decoder.decode(
                "[\"Test String\"]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            "Test String",
            try decoder.decode(
                "{\"value\":\"Test String\"}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<String>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<String>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<String>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<String>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<String>.some("Test String"),
            try decoder.decode(
                "[\"Test String\"]".data(using: .utf8)!,
                using: Decoding<String>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<String>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<String>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<String>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<String>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<String>.some("Test String"),
            try decoder.decode(
                "{\"value\":\"Test String\"}".data(using: .utf8)!,
                using: Decoding<String>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_UInt64() throws {
        XCTAssertEqual(
            UInt64(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            UInt64(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            UInt64(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt64>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<UInt64>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt64>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<UInt64>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt64>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<UInt64>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt64>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<UInt64>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt64>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<UInt64>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt64>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<UInt64>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_UInt8() throws {
        XCTAssertEqual(
            UInt8(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            UInt8(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            UInt8(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt8>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<UInt8>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt8>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<UInt8>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt8>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<UInt8>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt8>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<UInt8>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt8>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<UInt8>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt8>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<UInt8>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Float() throws {
        XCTAssertEqual(
            Float(123.5),
            try decoder.decode(
                "123.5".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            Float(123.5),
            try decoder.decode(
                "[123.5]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            Float(123.5),
            try decoder.decode(
                "{\"value\":123.5}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Float>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<Float>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Float>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<Float>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Float>.some(123.5),
            try decoder.decode(
                "[123.5]".data(using: .utf8)!,
                using: Decoding<Float>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Float>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<Float>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Float>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<Float>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Float>.some(123.5),
            try decoder.decode(
                "{\"value\":123.5}".data(using: .utf8)!,
                using: Decoding<Float>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_UInt32() throws {
        XCTAssertEqual(
            UInt32(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            UInt32(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            UInt32(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt32>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<UInt32>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt32>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<UInt32>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt32>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<UInt32>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt32>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<UInt32>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt32>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<UInt32>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt32>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<UInt32>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_UInt() throws {
        XCTAssertEqual(
            UInt(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            UInt(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            UInt(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<UInt>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<UInt>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<UInt>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UInt>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<UInt>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<UInt>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UInt>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<UInt>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Int() throws {
        XCTAssertEqual(
            Int(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            Int(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            Int(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<Int>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<Int>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<Int>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<Int>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<Int>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<Int>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Int32() throws {
        XCTAssertEqual(
            Int32(123),
            try decoder.decode(
                "123".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            Int32(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            Int32(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int32>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<Int32>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int32>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<Int32>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int32>.some(123),
            try decoder.decode(
                "[123]".data(using: .utf8)!,
                using: Decoding<Int32>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Int32>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<Int32>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int32>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<Int32>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Int32>.some(123),
            try decoder.decode(
                "{\"value\":123}".data(using: .utf8)!,
                using: Decoding<Int32>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Bool() throws {
        XCTAssertEqual(
            true,
            try decoder.decode(
                "true".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            false,
            try decoder.decode(
                "[false]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            true,
            try decoder.decode(
                "{\"value\":true}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Bool>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<Bool>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Bool>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<Bool>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Bool>.some(true),
            try decoder.decode(
                "[true]".data(using: .utf8)!,
                using: Decoding<Bool>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<Bool>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<Bool>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Bool>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<Bool>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<Bool>.some(true),
            try decoder.decode(
                "{\"value\":true}".data(using: .utf8)!,
                using: Decoding<Bool>.optionalWithKey(ExampleKeys.value)
            )
        )
    }

    func testDecoding_Encodable() throws {
        let uuid = UUID()

        XCTAssertEqual(
            uuid,
            try decoder.decode(
                "\"\(uuid.uuidString)\"".data(using: .utf8)!,
                using: .singleValue
            )
        )
        XCTAssertEqual(
            uuid,
            try decoder.decode(
                "[\"\(uuid.uuidString)\"]".data(using: .utf8)!,
                using: .unkeyed
            )
        )
        XCTAssertEqual(
            uuid,
            try decoder.decode(
                "{\"value\":\"\(uuid.uuidString)\"}".data(using: .utf8)!,
                using: .withKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UUID>.none,
            try decoder.decode(
                "[]".data(using: .utf8)!,
                using: Decoding<UUID>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UUID>.none,
            try decoder.decode(
                "[null]".data(using: .utf8)!,
                using: Decoding<UUID>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UUID>.some(uuid),
            try decoder.decode(
                "[\"\(uuid.uuidString)\"]".data(using: .utf8)!,
                using: Decoding<UUID>.optionalUnkeyed
            )
        )
        XCTAssertEqual(
            Optional<UUID>.none,
            try decoder.decode(
                "{}".data(using: .utf8)!,
                using: Decoding<UUID>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UUID>.none,
            try decoder.decode(
                "{\"value\":null}".data(using: .utf8)!,
                using: Decoding<UUID>.optionalWithKey(ExampleKeys.value)
            )
        )
        XCTAssertEqual(
            Optional<UUID>.some(uuid),
            try decoder.decode(
                "{\"value\":\"\(uuid.uuidString)\"}".data(using: .utf8)!,
                using: Decoding<UUID>.optionalWithKey(ExampleKeys.value)
            )
        )
    }
}
