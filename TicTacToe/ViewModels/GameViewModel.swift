//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Puneet on 16/11/24.
//

import SwiftUI

final class GameViewModel : ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, for: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        //Check for win or draw
        if(checkWinCondition(for: .human, in: moves)) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            isGameBoardDisabled = false
            
            //Check for win or draw
            if(checkWinCondition(for: .computer, in: moves)) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], for index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in move: [Move?]) -> Int {
        
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        // If AI can win, then win
        let computerMoves = moves.compactMap{$0}.filter {$0.player == .computer} //Get moves of computer
        let computerPositions = Set(computerMoves.map {$0.boardIndex})    //Convert to index array
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, for: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap{$0}.filter {$0.player == .human} //Get moves of computer
        let humanPositions = Set(humanMoves.map {$0.boardIndex})    //Convert to index array
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, for: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't block, then take the middle square
        
        let centerSquare = 4
        if !isSquareOccupied(in: moves, for: centerSquare) {
            return centerSquare
        }
        
        // If AI can't take middle square, then take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: move, for: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap{$0}.filter {$0.player == player} //Get moves of a particular player
        let playerPositions = Set(playerMoves.map {$0.boardIndex})    //Convert to index array
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
