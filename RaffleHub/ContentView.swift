import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RaffleViewModel()
    @State private var participantName = ""
    @State private var participantGender = "Male"
    @State private var isShowingRaffleResult = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Game Selector
                Picker("Select Game", selection: $viewModel.selectedGame) {
                    Text("Normal").tag(nil as String?)
                    Text("FIFA").tag("FIFA" as String?)
                    Text("Volleyball").tag("Volleyball" as String?)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Add Participant Section
                HStack {
                    TextField("Participant Name", text: $participantName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if viewModel.selectedGame == "Volleyball" {
                        Picker("Gender", selection: $participantGender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120)
                    }

                    Button(action: {
                        viewModel.addParticipant(name: participantName, gender: participantGender)
                        participantName = ""
                        participantGender = "Male"
                    }) {
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color("CustomGreen"))
                            .cornerRadius(8)
                    }
                }
                .padding()

                // Participant List
                List {
                    ForEach(viewModel.participants) { participant in
                        ParticipantCard(participant: participant) {
                            if let index = viewModel.participants.firstIndex(where: { $0.id == participant.id }) {
                                viewModel.deleteParticipant(at: IndexSet(integer: index))
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    }
                }
                .listStyle(PlainListStyle())

                // Conduct Raffle Button
                Button(action: {
                    viewModel.conductRaffle()
                    if viewModel.selectedGame == "Volleyball" {
                        isShowingRaffleResult = true
                    }
                }) {
                    Text("Conduct Raffle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("CustomGreen"))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // Refresh Button
                Button(action: viewModel.refreshRaffle) {
                    Text("Refresh")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(12)
                }
                .padding()
            }
            .overlay(
                // Pop-Up Görünümü
                Group {
                    if isShowingRaffleResult {
                        VStack(spacing: 16) {
                            Text("Raffle Results")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()

                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(viewModel.raffleResult.components(separatedBy: "\n"), id: \.self) { line in
                                        Text(line)
                                            .font(.body)
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.horizontal)
                            }

                            Button(action: {
                                isShowingRaffleResult = false
                            }) {
                                Text("Close")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .frame(width: 300, height: 400) // Küçük pencere boyutu
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .transition(.scale)
                        .zIndex(1) // Öncelikli görünüm
                    }
                }
            )
            .navigationBarItems(leading: HStack {
                Image("raffleUpLogo") // Logonuzun adı burada kullanılacak
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("RaffleHub")
                    .font(.headline)
            })
        }
    }
}

struct RaffleResultView: View {
    let raffleResult: String
    @Environment(\.dismiss) var dismiss // Pop-up'ı kapatma

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Raffle Results")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Takım sonuçlarını düzenli bir şekilde göster
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(raffleResult.components(separatedBy: "\n"), id: \.self) { line in
                            Text(line)
                                .font(.body)
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                    }
                }

                Spacer()

                // Close Button
                Button(action: { dismiss() }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ParticipantCard: View {
    let participant: Participant
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text(participant.name)
                .font(.system(size: 14, weight: .medium))

            Spacer()

            // Silme Butonu
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(6)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

