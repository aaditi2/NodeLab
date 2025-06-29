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
        guard let start = nodes.first(where: { $0.type == .tapEvent }) else {
            return "❌ Add a Tap Event node"
        }

        var visited = Set<UUID>()
        var current = start
        var parts = ["✅ When tapped"]

        while let nextID = connections.first(where: { $0.fromNode == current.id })?.toNode,
              let next = nodes.first(where: { $0.id == nextID }),
              !visited.contains(next.id) {
            visited.insert(next.id)
            parts.append(next.type.rawValue)
            current = next
        }

        return parts.joined(separator: " → ")
    }
}
