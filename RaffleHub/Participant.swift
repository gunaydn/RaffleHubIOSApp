import Foundation

struct Participant: Identifiable {
    let id = UUID()
    var name: String
    var gender: String?
}
