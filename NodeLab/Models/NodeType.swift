//
//  NodeType.swift
//  NodeLab
//
//  Created by Aditi More on 6/28/25.
//

import Foundation
import SwiftUI


enum NodeType: String, Codable, CaseIterable {
    case tapEvent    = "Tap Event"
    case rotateObject = "Rotate Object"
    case changeColor  = "Change Color"
    case spawnObject  = "Spawn Object"
    case delay        = "Delay"

    var color: Color {
        switch self {
        case .tapEvent:     return .blue
        case .rotateObject: return .purple
        case .changeColor:  return .orange
        case .spawnObject:  return .green
        case .delay:        return .gray
        }
    }
}

