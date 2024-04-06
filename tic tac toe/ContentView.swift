import SwiftUI

struct ContentView: View {
    @State private var playerXName: String = ""
    @State private var playerOName: String = ""
    @State private var board: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @State private var currentPlayer: Player = .x
    @State private var winner: Player?
    @State private var isGameTied: Bool = false

    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
    

            Spacer()

            if winner == nil && !isGameTied {
                Text("Current Player: \(currentPlayer.rawValue)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                TextField("Player X's Name", text: $playerXName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)

                TextField("Player O's Name", text: $playerOName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
            }

            VStack(spacing: 10) {
                ForEach(0..<3) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<3) { column in
                            CellView(player: board[row][column]) {
                                if board[row][column] == nil && winner == nil && !isGameTied {
                                    board[row][column] = currentPlayer
                                    checkForWinner()
                                    switchPlayer()
                                    checkForTie()
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.gray)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.blue, lineWidth: 5)
            )

            Spacer()

            if let winner = winner {
                VStack {
                    Text("\(winner.rawValue == "X" ? playerXName : playerOName) wins!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()

                    playAgainButton()
                }
                .transition(.scale)
                .animation(.easeInOut(duration: 0.5))
            } else if isGameTied {
                VStack {
                    Text("It's a Tie!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()

                    playAgainButton()
                }
            }
        }
        .padding()
    }

    private func checkForWinner() {
        for i in 0..<3 {
            if board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer {
                winner = currentPlayer
                return
            }

            if board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer {
                winner = currentPlayer
                return
            }
        }

        if board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer {
            winner = currentPlayer
            return
        }

        if board[0][2] == currentPlayer && board[1][1] == currentPlayer && board[2][0] == currentPlayer {
            winner = currentPlayer
        }
    }

    private func switchPlayer() {
        currentPlayer = (currentPlayer == .x) ? .o : .x
    }

    private func checkForTie() {
        let flatBoard = board.flatMap { $0 }
        if !flatBoard.contains(nil) {
            isGameTied = true
        }
    }

    private func playAgainButton() -> some View {
        Button(action: {
            withAnimation {
                resetGame()
            }
        }) {
            Text("Play Again")
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }

    private func resetGame() {
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        winner = nil
        isGameTied = false
        currentPlayer = .x
        playerXName = ""
        playerOName = ""
    }
}

enum Player: String {
    case x = "X"
    case o = "O"
}

struct CellView: View {
    var player: Player?
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(player?.rawValue ?? "")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(Color.blue)
                .cornerRadius(15)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
