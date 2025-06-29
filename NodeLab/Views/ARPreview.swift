// ARPreview.swift

import SwiftUI
import RealityKit
import ARKit

struct ARPreview: UIViewRepresentable {
    var nodes: [Node]
    var connections: [Connection]

    class Coordinator: NSObject {
        weak var arView: ARView?
        var nodes: [Node]
        var connections: [Connection]

        init(nodes: [Node], connections: [Connection]) {
            self.nodes = nodes
            self.connections = connections
            super.init()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(runManually),
                name: .runGraphManually,
                object: nil)
        }

        @objc func runManually() {
            print("▶️ Manual Run tapped")
            guard let cube = arView?.scene.findEntity(named: "targetCube") else {
                print("❌ No cube in scene"); return
            }
            runGraph(on: cube)
        }

        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard
                let arView = recognizer.view as? ARView,
                let hit    = arView.entity(at: recognizer.location(in: arView)),
                hit.name == "targetCube"
            else { return }
            runGraph(on: hit)
        }

        func runGraph(on entity: Entity) {
            guard let start = nodes.first(where: { $0.type == .tapEvent }) else {
                print("❌ No Tap Event node"); return
            }

            var visited: Set<UUID> = []

            func runNode(_ node: Node) {
                visited.insert(node.id)
                guard let nextID = connections.first(where: { $0.fromNode == node.id })?.toNode,
                      let next = nodes.first(where: { $0.id == nextID }),
                      !visited.contains(next.id) else { return }

                perform(next) {
                    runNode(next)
                }
            }

            runNode(start)
        }

        private func rotate(_ entity: Entity) {
            let q = simd_quatf(angle: .pi, axis: [0,1,0])
            entity.move(to: Transform(rotation: q),
                        relativeTo: entity,
                        duration: 1.0)
            print("⚙️ rotate executed")
        }

        private func changeColor(_ entity: Entity) {
            guard var model = entity as? ModelEntity else { return }
            let color = UIColor(red: .random(in: 0...1),
                               green: .random(in: 0...1),
                               blue: .random(in: 0...1),
                               alpha: 1)
            model.model?.materials = [SimpleMaterial(color: color, isMetallic: false)]
            print("🎨 color changed")
        }

        private func spawn(_ entity: Entity) {
            guard let parent = entity.parent else { return }
            let clone = entity.clone(recursive: true)
            clone.position.x += 0.4
            parent.addChild(clone)
            print("🆕 cube spawned")
        }

        private func perform(_ node: Node, completion: @escaping () -> Void) {
            guard let cube = arView?.scene.findEntity(named: "targetCube") else { completion(); return }
            switch node.type {
            case .rotateObject:
                rotate(cube); completion()
            case .changeColor:
                changeColor(cube); completion()
            case .spawnObject:
                spawn(cube); completion()
            case .delay:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { completion() }
            case .tapEvent:
                completion()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(nodes: nodes, connections: connections)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView

        arView.environment.background = .color(.white)
        arView.session.run(ARWorldTrackingConfiguration())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let cube = ModelEntity(mesh: .generateBox(size: 0.3))
            cube.model?.materials = [ SimpleMaterial(color: .yellow, isMetallic: false) ]
            cube.name = "targetCube"
            let anchor = AnchorEntity(world: [0, 0.1, -0.5])
            anchor.addChild(cube)
            arView.scene.anchors.append(anchor)
            print("📦 targetCube added")
        }

        arView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap(_:))
            )
        )

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.nodes = nodes
        context.coordinator.connections = connections
    }
}
