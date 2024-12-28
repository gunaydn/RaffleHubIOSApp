import SwiftUI

class RaffleViewModel: ObservableObject {
    @Published var participants: [Participant] = []
    @Published var selectedGame: String? = nil {
        didSet {
            if selectedGame == "Volleyball" && !participants.isEmpty {
                participants.removeAll()
            }
        }
    }
    @Published var raffleResult: String = ""
    
    func addParticipant(name: String, gender: String) {
        guard !name.isEmpty else { return }
        let formattedName = name.prefix(1).uppercased() + name.dropFirst()
        participants.append(Participant(name: formattedName, gender: gender))
    }
    
    func deleteParticipant(at offsets: IndexSet) {
        participants.remove(atOffsets: offsets)
    }
    
    func conductRaffle() {
        if participants.isEmpty {
            raffleResult = "Add participants before conducting the raffle!"
            return
        }

        switch selectedGame {
        case "FIFA":
            if participants.count < 2 {
                raffleResult = "Add at least two participants for the FIFA Raffle!"
                return
            }
            let shuffled = participants.shuffled()
            if let winner1 = shuffled.first, let winner2 = shuffled.dropFirst().first {
                raffleResult = "The team is \(winner1.name) and \(winner2.name)!"
            }
        case "Volleyball":
            let males = participants.filter { $0.gender == "Male" }
            let females = participants.filter { $0.gender == "Female" }
            let unknowns = participants.filter { $0.gender == nil }

            var team1: [Participant] = []
            var team2: [Participant] = []
            
            if participants.count < 12 {
                raffleResult = "Not enough participants! Please add \(12 - participants.count) more participants"
                return
            }
            else if participants.count > 12 {
                raffleResult = "Too many participants! Please remove \(participants.count - 12) participants"
                return
            }

            // Erkek ve kadınları sırayla takımlara ekle
            let minCount = min(males.count, females.count)
            for i in 0..<minCount {
                if i % 2 == 0 {
                    team1.append(males[i])
                    team2.append(females[i])
                } else {
                    team1.append(females[i])
                    team2.append(males[i])
                }
            }

            // Artan erkekler, kadınlar ve bilinmeyenleri sırayla takımlara dağıt
            let remainingParticipants = Array(males[minCount...]) + Array(females[minCount...]) + unknowns
            for (index, participant) in remainingParticipants.enumerated() {
                if index % 2 == 0 {
                    team1.append(participant)
                } else {
                    team2.append(participant)
                }
            }

            let team1List = team1.map { $0.name }.joined(separator: ", ")
            let team2List = team2.map { $0.name }.joined(separator: ", ")

            raffleResult = "Team 1: \(team1List)\nTeam 2: \(team2List)"
        default:
            let winner = participants.randomElement()
            raffleResult = "The winner is \(winner?.name ?? "Unknown")!"
        }
    }
    
    func refreshRaffle() {
        participants.removeAll()
        raffleResult = ""
    }
}
