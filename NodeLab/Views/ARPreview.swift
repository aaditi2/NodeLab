// ARPreview.swift

import SwiftUI
import RealityKit
import ARKit
import AVFoundation
import AudioToolbox

struct ARPreview: UIViewRepresentable {
    var nodes: [Node]
    var connections: [Connection]

    class Coordinator: NSObject {
        weak var arView: ARView?
        var avPlayer: AVPlayer?
        var systemSoundID: SystemSoundID = 0
        let nodes: [Node]
        let connections: [Connection]

        init(nodes: [Node], connections: [Connection]) {
            self.nodes = nodes
            self.connections = connections
            super.init()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(runManually),
                name: .runGraphManually,
                object: nil)

            // prepare system sound
            if let url = Bundle.main.url(forResource: "ding", withExtension: "mp3") {
                AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
                print("✅ SystemSoundID prepared")
            } else {
                print("❌ ding.mp3 not found for SystemSoundID")
            }
        }

        @objc func runManually() {
            print("▶️ Manual Run tapped")
            guard let cube = arView?.scene.findEntity(named: "targetCube") else {
                print("❌ No cube in scene"); return
            }
            rotate(cube)

            // 1) Try AVPlayer
            playWithAVPlayer()

            // 2) Try SystemSound
            playWithSystemSound()
        }

        private func playWithAVPlayer() {
            guard let url = Bundle.main.url(forResource: "ding", withExtension: "mp3") else {
                print("❌ ding.mp3 not found for AVPlayer"); return
            }
            avPlayer = AVPlayer(url: url)
            avPlayer?.play()
            print("🔊 AVPlayer.play() called")
        }

        private func playWithSystemSound() {
            guard systemSoundID != 0 else { return }
            AudioServicesPlaySystemSound(systemSoundID)
            print("🔔 SystemSound played")
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
            // your existing graph logic…
        }

        private func rotate(_ entity: Entity) {
            let q = simd_quatf(angle: .pi, axis: [0,1,0])
            entity.move(to: Transform(rotation: q),
                        relativeTo: entity,
                        duration: 1.0)
            print("⚙️ rotate executed")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(nodes: nodes, connections: connections)
    }

    func makeUIView(context: Context) -> ARView {
        // configure audio session for playback
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            print("✅ AVAudioSession configured")
        } catch {
            print("❌ AVAudioSession error:", error)
        }

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

    func updateUIView(_ uiView: ARView, context: Context) {}
}
