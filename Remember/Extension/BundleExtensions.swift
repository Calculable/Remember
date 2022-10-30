import Foundation

extension Bundle {
    
    /// Decodes a JSON-File
    /// - Parameter url: location of the JSON-File
    /// - Returns: A value of the requested type.
    func decode<T: Codable>(_ url: URL) throws -> T {
        
        guard let data = try? Data(contentsOf: url) else {
            throw "Failed to load \(url) from bundle."
        }
        
        let decoder = JSONDecoder()
        let loaded = try! decoder.decode(T.self, from: data)
        return loaded
    }
}
