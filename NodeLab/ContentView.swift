import SwiftUI

struct ContentView: View {
    @State private var nodes: [Node] = []
    @State private var connections: [Connection] = []

    var body: some View {
        VStack(spacing: 0) {
            GraphView(nodes: $nodes, connections: $connections)
                .frame(height: 350)

            Text(outputDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))

            Divider()

            Text("📦 AR Preview")
                .font(.headline)
                .padding(.top, 4)

            Button("▶️ Run Node Graph") {
                NotificationCenter.default.post(name: .runGraphManually, object: nil)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 6)

            ARPreview(nodes: nodes, connections: connections)
                .frame(height: 300)

            Divider()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(NodeType.allCases, id: \.self) { type in
                        Button(type.rawValue) {
                            let newNode = Node(type: type, position: CGPoint(x: 150, y: 150))
                            nodes.append(newNode)
                        }
                        .padding(8)
                        .background(type.color.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    var outputDescription: String {
        guard let tap = nodes.first(where: { $0.type == .tapEvent }) else {
            return "❌ No Tap Event node"
        }

        guard let rotateID = connections.first(where: { $0.fromNode == tap.id })?.toNode,
              let rotate = nodes.first(where: { $0.id == rotateID && $0.type == .rotateObject }) else {
            return "❌ Tap is not connected to Rotate"
        }

        if let soundID = connections.first(where: { $0.fromNode == rotate.id })?.toNode,
           let _ = nodes.first(where: { $0.id == soundID && $0.type == .playSound }) {
            return "✅ When tapped → Rotate → Play Sound"
        }

        return "✅ When tapped → Rotate"
    }
}
