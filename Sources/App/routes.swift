import Vapor
import Foundation

struct VaultData: Content {
    let key: String
    let value: String
}

struct PostResponse: Content {
    let key: String
}

var vault: [String: VaultData] = [:]

func routes(_ app: Application) throws {
    app.get(":key") { req async throws -> VaultData in
        guard let key = req.parameters.get("key") else {
            throw Abort(.internalServerError)
        }
        
        guard let data = vault[key] else {
            throw Abort(.noContent)
        }
        
        return data
    }
    
    app.post { req async throws -> PostResponse in
        let data = try req.content.decode(VaultData.self)
        vault[data.key] = data
        return PostResponse(key: data.key)
    }
}
