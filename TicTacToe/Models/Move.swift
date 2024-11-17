//
//  Move.swift
//  TicTacToe
//
//  Created by Puneet on 16/11/24.
//

import Foundation

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
