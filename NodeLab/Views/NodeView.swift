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
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .frame(maxWidth: 200)
        .padding(.horizontal, 10) // add spacing from edges if needed
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
