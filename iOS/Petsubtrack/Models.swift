import Foundation

struct SubscriptionItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var petName: String
    var monthlyCost: Double
    var nextDelivery: String
    var dateAdded: Date = Date()
}
