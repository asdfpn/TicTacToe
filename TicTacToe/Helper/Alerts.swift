//
//  Alerts.swift
//  TicTacToe
//
//  Created by Puneet on 16/11/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win"),
                                    message: Text("Amazing, You beat the AI"),
                                    buttonTitle: Text("Close"))
    
    static let computerWin = AlertItem(title: Text("You Lost"),
                                       message: Text("The AI is smarter than your, better luck next time!"),
                                       buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw"),
                                message: Text("Nice try, it's a draw!"),
                                buttonTitle: Text("Try Again"))
}
