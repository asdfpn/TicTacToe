//
//  GameView.swift
//  TicTacToe
//
//  Created by Puneet on 16/11/24.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5, content: {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                })
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            })
        })
    }
}

#Preview {
    GameView()
}

struct GameSquareView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.pink).opacity(0.5)
            .frame(width: proxy.size.width / 3 - 15,
                   height: proxy.size.width / 3 - 15)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
