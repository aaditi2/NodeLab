// NodeLabView.swift

import SwiftUI
import RealityKit
import ARKit

struct NodeLabView: View {
    @State var nodes: [Node]
    @State var connections: [Connection]

    var body: some View {
        ZStack {
            // Full-screen AR preview
            ARPreview(nodes: nodes, connections: connections)
                .ignoresSafeArea()

            VStack {
                // 1) Horizontal editable list of nodes
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach($nodes) { $node in
                            NodeView(node: $node)
                                .frame(width: 140)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 50)

                Spacer()

                // 2) Run-graph button
                Button {
                    NotificationCenter.default
                        .post(name: .runGraphManually, object: nil)
                } label: {
                    Label("▶ Run Node Graph", systemImage: "play.fill")
                        .bold()
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct NodeLabView_Previews: PreviewProvider {
    static var previews: some View {
        // Create one tap-event node at (0,0)
        let sampleNode = Node(
            type: .tapEvent,
            position: CGPoint(x: 0, y: 0)
        )
        // Make a loopback connection
        let sampleConn = Connection(
            fromNode: sampleNode.id,
            toNode:   sampleNode.id
        )
        return NodeLabView(
            nodes:       [sampleNode],
            connections: [sampleConn]
        )
    }
}
