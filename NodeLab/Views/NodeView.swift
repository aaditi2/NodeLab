// NodeView.swift

import SwiftUI

struct NodeView: View {
    @Binding var node: Node

    var body: some View {
        HStack {
            Circle()
                .fill(node.type.color)
                .frame(width: 16, height: 16)

            Text(node.label)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Button {
                // You can hook up deletion here if desired…
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(white: 0.95))
        )
    }
}

struct NodeView_Previews: PreviewProvider {
    @State static var sample = Node(
        type: .tapEvent,
        position: CGPoint(x: 20, y: 20)
    )

    static var previews: some View {
        NodeView(node: $sample)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
