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
    var inputs: [UUID] = []
    var outputs: [UUID] = []

    init(type: NodeType, position: CGPoint) {
        self.id = UUID()
        self.type = type
        self.position = position
    }
}
