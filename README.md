# NodeLab – AR Visual Scripting Playground

NodeLab is a modular SwiftUI + RealityKit-based app that lets you **build and run logic flows visually in AR**. Inspired by node-based editors like Unreal Blueprints, this is a hands-on, immersive way to teach or demo **event-driven logic** using virtual objects.

---

## 🚀 Features

- 🪄 **Tap-to-Trigger Logic:** Begin with a `Tap Event` node to start your custom logic graph.
- 🧩 **Node Types:**
  - `Tap Event`: Entry point
  - `Rotate Object`: Rotates the AR cube 360°
  - `Change Color`: Randomizes cube color
  - `Spawn Object`: Duplicates cube nearby
  - `Wait`: Adds delay between steps
- 🧶 **Live Graph Traversal:** Executes your connected nodes step-by-step using `DispatchQueue`.
- 🕹️ **AR Preview:** Visualize your logic in real-time with a tappable AR cube.
- 🔗 **Dynamic Connections:** Easily connect nodes to define execution flow.
- 🧼 **No Hardcoding:** Node data and connections are fully dynamic.

---

## 🛠️ Technologies

- SwiftUI
- RealityKit
- ARKit
- Combine
- AVAudioSession (for AR audio, optional)


---


## 📁 Project Structure

```bash
NodeLab/
├── Models/
│   └── Node.swift
│   └── Connection.swift
│   └── NodeType.swift
├── Views/
│   └── ContentView.swift
│   └── ARPreview.swift
│   └── GraphView.swift
│   └── Notification+Extension.swift
