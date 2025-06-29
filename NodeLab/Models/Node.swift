//
//  Node.swift
//  NodeLab
//
//  Created by Aditi More on 6/28/25.
//


import Foundation
import SwiftUI

struct Node: Identifiable, Codable, Equatable {
    let id: UUID
    var type: NodeType
    var position: CGPoint
    var label: String

    init(type: NodeType, position: CGPoint, label: String? = nil) {
        self.id = UUID()
        self.type = type
        self.position = position
        self.label = label ?? type.rawValue
    }
}
