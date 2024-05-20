//
//  DetailView.swift
//  ARDemoSample
//
//  Created by 酒井文也 on 2024/05/19.
//

import SwiftUI
import SceneKit

// ※ .scnファイルを直接プロジェクト内部にBundleさせているから、タイムラグとかあるかも...
struct DetailView: View {

    // MARK: - Property

    // 表示対象のSCNScene（SceneKit）をStateとして定める
    @State private var scene: SCNScene?

    // DragGesture発動時に一時的に格納するための変数
    @GestureState private var temporaryOffsetValue: CGFloat = 0

    // 何秒でAnimation変化するかの秒数
    private let commonDurationValue: TimeInterval = 0.36

    // MARK: - Body

    init(scene: SCNScene?) {

        // Stateの初期値を定める
        _scene = State(initialValue: scene)

        // 👉 少し拡大＆ちょいと手前側に斜めにすることで見やすくする
        self.scene?.rootNode.rotation = SCNVector4(1, 0, 0, 0.1 * Float.pi)
        self.scene?.rootNode.scale = SCNVector3Make(1.28, 1.28, 1.28)
    }

    // MARK: - Body

    var body: some View {
        VStack {
            // ① .scnに変換したモデルを配置
            CustomSceneView(scene: $scene)
                .frame(height: 280.0)
                .padding(.top, -48.0)
            // ② 回転処理用Seekbarを配置
            RotationSeekerView()
        }
        .padding()
    }

    // MARK: - Private Function

    @ViewBuilder
    private func RotationSeekerView() -> some View {
        // スライダーつまみのView要素
        HStack(spacing: 5.0) {
            Image(systemName: "arrowtriangle.left.fill")
                .font(.headline)
            Text("回転")
            Image(systemName: "arrowtriangle.right.fill")
                .font(.body)
        }
        .foregroundColor(.white)
        .padding(.all, 16.0)
        .border(.white, width: 4.0)
        .offset(x: temporaryOffsetValue)
        .gesture(
            // DragGestureと連動して回転する様な形を実現する
            DragGesture()
                .updating($temporaryOffsetValue, body: { currentValue, outputValue, _ in
                    // MEMO:
                    outputValue = currentValue.location.x - 64.0
                }
            )
        )
        .onChange(of: temporaryOffsetValue) {
            // MEMO: 変数「offset」が変更されるので、配置したシーンオブジェクトが合わせて回転する
            rotateSceneViewObject(animate: temporaryOffsetValue == .zero)
        }
        .animation(.easeInOut(duration: commonDurationValue), value: temporaryOffsetValue == .zero)
    }

    // Drag処理変化量に合わせて水平方向回転を実施する
    private func rotateSceneViewObject(animate: Bool = false) {
        // どこかCoreAnimationの様な印象...
        // ① Transition処理を開始する
        if animate {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = commonDurationValue
        }
        // 👉 この様な条件分岐にしないと綺麗に回転しなかったんですよねー...😇
        scene?.rootNode.eulerAngles.y = Float((temporaryOffsetValue * .pi) / 180.0)
        // ② Transition処理を実行する
        if animate {
            SCNTransaction.commit()
        }
    }
}

// MARK: - UIViewRepresentable

// 実質はUIViewRepresentableをしているからUIKitの知識がある程度必要なので注意！
struct DetailCustomSceneView: UIViewRepresentable {

    // MARK: - `@Binding` Property

    @Binding var scene: SCNScene?

    // MARK: - Function

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}
