import Foundation

struct Connection: Identifiable, Codable, Equatable {
    let id = UUID()
    let fromNode: UUID
    let toNode: UUID
}
