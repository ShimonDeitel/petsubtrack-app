import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [SubscriptionItem] = []
    @Published var isPro: Bool = false

    static let freeLimit = 15

    private let fileName = "petsubtrack_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([SubscriptionItem].self, from: data) else {
            items = [
        SubscriptionItem(name: "BarkBox", petName: "Rex", monthlyCost: 29.0, nextDelivery: "2026-07-20"),
        SubscriptionItem(name: "Chewy Autoship", petName: "Luna", monthlyCost: 45.0, nextDelivery: "2026-07-15"),
        SubscriptionItem(name: "KitNipBox", petName: "Milo", monthlyCost: 22.0, nextDelivery: "2026-07-25")
            ]
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    @discardableResult
    func add(_ item: SubscriptionItem) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: SubscriptionItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: SubscriptionItem) {
        items.removeAll(where: { $0.id == item.id })
        save()
    }
}
