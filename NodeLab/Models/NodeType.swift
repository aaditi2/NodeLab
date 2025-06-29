//
//  NodeType.swift
//  NodeLab
//
//  Created by Aditi More on 6/28/25.
//

import Foundation
import SwiftUI


enum NodeType: String, Codable, CaseIterable {
    case tapEvent = "Tap Event"
    case rotateObject = "Rotate Object"
    case playSound = "Play Sound"
    case spawnObject = "Spawn Object"
    case delay = "Wait"

    var color: Color {
        switch self {
        case .tapEvent: return .blue
        case .rotateObject: return .purple
        case .playSound: return .orange
        case .spawnObject: return .green
        case .delay: return .gray
        }
    }
}

