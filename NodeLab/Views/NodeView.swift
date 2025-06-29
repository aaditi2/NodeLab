// NodeView.swift

import SwiftUI

struct NodeView: View {
    @Binding var node: Node
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack {
            Circle()
                .fill(node.type.color)
                .frame(width: 16, height: 16)

            Text(node.label)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(1)

            Spacer()

            Button {
                onDelete?()
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
