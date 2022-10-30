import Foundation

///This extension allows simple strings to be thrown as error. For example:
///     throw "this is an error"
extension String: LocalizedError {
    
    public var errorDescription: String? {
        return self
    }
}
