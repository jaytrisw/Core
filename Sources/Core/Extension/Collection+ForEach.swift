import Foundation

public extension Collection {
    
    func forEach(
        perform body: (Element) throws -> Void,
        breakCondition: (Element) throws -> Bool) rethrows {
            for element in self {
                guard try breakCondition(element) == false else {
                    break
                }
                try body(element)
            }
        }
    
    func forEach(
        perform body: (Element) throws -> Void,
        continueCondition: (Element) throws -> Bool) rethrows {
            for element in self {
                guard try continueCondition(element) == false else {
                    continue
                }
                try body(element)
            }
        }
    
}
