import AppIntents
import SwiftData

public struct InsulinSettingQuery: EntityQuery {
    public func suggestedEntities() async throws -> [InsulinSettingModel] {
        return try await InsulinModelActor.shared.fetchAllSettings()
    }
    
    public func entities(for identifiers: [UUID]) async throws -> [InsulinSettingModel] {
        return try await InsulinModelActor.shared.fetchSettings(with: identifiers)
            
    }
    
    public func defaultResult() async -> InsulinSettingModel? {
        try? await suggestedEntities().first
    }
    
    public init(){}
    
}
