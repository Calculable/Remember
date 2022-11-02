import Foundation

extension Bundle {
    
    /// Decodes a JSON-File
    /// - Parameter url: location of the JSON-File
    /// - Returns: A value of the requested type.
    func decode<T: Codable>(_ url: URL) throws -> T {
        guard let data = try? Data(contentsOf: url) else {
            throw "Failed to load \(url) from bundle."
        }
        return try decode(data)
    }
    
    /// Decodes a JSON-String
    /// - Parameter content: The encoded JSON-String
    /// - Returns: A value of the requested type.
    func decode<T: Codable>(_ content: String) throws -> T {
        let data = content.data(using: .utf8)!
        return try decode(data)
    }
    
    private func decode<T: Codable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        let loaded = try decoder.decode(T.self, from: data)
        return loaded
    }
    
}
