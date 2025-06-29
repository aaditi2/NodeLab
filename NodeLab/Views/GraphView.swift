// GraphView.swift

import SwiftUI

struct GraphView: View {
    @Binding var nodes: [Node]
    @Binding var connections: [Connection]

    @State private var selectedNodeID: UUID? = nil

    var body: some View {
        ZStack {
            // 1) Transparent background that captures taps as zero-distance drags
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            handleConnectionTap(at: value.location)
                        }
                )

            // 2) Draw connections
            ForEach(connections) { conn in
                if let from = nodes.first(where: { $0.id == conn.fromNode }),
                   let to   = nodes.first(where: { $0.id == conn.toNode }) {
                    Path { path in
                        path.move(to: from.position)
                        path.addLine(to: to.position)
                    }
                    .stroke(Color.gray, lineWidth: 2)
                }
            }

            // 3) Draw & drag nodes, using bindings
            ForEach($nodes) { nodeBinding in
                let nodeValue = nodeBinding.wrappedValue

                NodeView(node: nodeBinding, onDelete: {
                    delete(nodeValue)
                })
                    .position(nodeValue.position)
                    .onTapGesture {
                        handleTap(on: nodeValue)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Update the binding’s position
                                nodeBinding.position.wrappedValue = value.location
                            }
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }

    // MARK: - Tap to select or connect nodes
    private func handleTap(on node: Node) {
        if let selected = selectedNodeID {
            if selected != node.id {
                let conn = Connection(fromNode: selected, toNode: node.id)
                if !connections.contains(where: {
                    $0.fromNode == conn.fromNode && $0.toNode == conn.toNode
                }) {
                    connections.append(conn)
                    print("🔗 Connected \(selected) → \(node.id)")
                }
            }
            selectedNodeID = nil
        } else {
            selectedNodeID = node.id
            print("🎯 Selected node \(node.id)")
        }
    }

    // MARK: - Tap (drag) on background to delete connections
    private func handleConnectionTap(at point: CGPoint) {
        let tolerance: CGFloat = 20
        for conn in connections {
            if let a = nodes.first(where: { $0.id == conn.fromNode })?.position,
               let b = nodes.first(where: { $0.id == conn.toNode   })?.position,
               isPoint(point, nearLineFrom: a, to: b, tolerance: tolerance) {
                if let idx = connections.firstIndex(of: conn) {
                    connections.remove(at: idx)
                    print("❌ Deleted connection \(conn.fromNode) → \(conn.toNode)")
                }
                break
            }
        }
    }

    // MARK: - Delete a node and its connections
    private func delete(_ node: Node) {
        if let idx = nodes.firstIndex(of: node) {
            nodes.remove(at: idx)
        }
        connections.removeAll { $0.fromNode == node.id || $0.toNode == node.id }
        if selectedNodeID == node.id {
            selectedNodeID = nil
        }
        print("🗑️ Deleted node \(node.id)")
    }

    // MARK: - Utility: distance from point to line segment
    private func isPoint(_ p: CGPoint, nearLineFrom a: CGPoint, to b: CGPoint, tolerance: CGFloat) -> Bool {
        let dx = b.x - a.x
        let dy = b.y - a.y
        let len2 = dx*dx + dy*dy
        guard len2 != 0 else { return false }

        let t = max(0, min(1, ((p.x - a.x)*dx + (p.y - a.y)*dy) / len2))
        let proj = CGPoint(x: a.x + t*dx, y: a.y + t*dy)
        return hypot(p.x - proj.x, p.y - proj.y) <= tolerance
    }
}
