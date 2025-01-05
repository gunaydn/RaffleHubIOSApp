import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RaffleViewModel()
    @State private var participantName = ""
    @State private var participantGender = "Male"
    @State private var isShowingRaffleResult = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Picker("Select Game", selection: $viewModel.selectedGame) {
                    Text("Normal").tag(nil as String?)
                    Text("FIFA").tag("FIFA" as String?)
                    Text("Volleyball").tag("Volleyball" as String?)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

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

                List {
                    ForEach(viewModel.participants) { participant in
                        ParticipantCard(participant: participant) {
                            if let index = viewModel.participants.firstIndex(where: { $0.id == participant.id }) {
                                viewModel.deleteParticipant(at: IndexSet(integer: index))
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    viewModel.conductRaffle()
                    isShowingRaffleResult = true
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
                        .frame(width: 300, height: 400)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .transition(.scale)
                        .zIndex(1)
                    }
                }
            )
            .navigationBarItems(leading: HStack {
                Image("raffleUpLogo")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("RaffleHub")
                    .font(.headline)
            })
        }
    }
}


struct ParticipantCard: View {
    let participant: Participant
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(participant.name)
                    .font(.system(size: 14, weight: .medium))
            }

            Spacer()

            // Sadece Çöp Butonu Tıklanabilir
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
        // HStack'e tıklama işlevi eklenmedi
    }
}

