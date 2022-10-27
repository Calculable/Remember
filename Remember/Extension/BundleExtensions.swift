import Foundation

extension Bundle {
    func decode<T: Codable>(_ url: URL) throws -> T {
        
        guard let data = try? Data(contentsOf: url) else {
            throw "Failed to load \(url) from bundle."
        }
        
        let decoder = JSONDecoder()
        let loaded = try! decoder.decode(T.self, from: data)
        return loaded
    }
}
