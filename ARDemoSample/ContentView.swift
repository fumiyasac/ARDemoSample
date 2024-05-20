//
//  ContentView.swift
//  ARDemoSample
//
//  Created by 酒井文也 on 2024/05/19.
//

import SwiftUI
import SceneKit

struct ContentView: View {

    // MARK: - `@State` Property

    @State private var selectedMaterial: MaterialEntity? = nil

    // MARK: - Property (Grid Layout)

    // MEMO: 「matchedGeometryEffect」Modifierを利用したAnimationで利用する名前空間
    @Namespace private var namespace

    private let effectTitleSuffix: String = "EffectTitle"
    private let effectShapeSuffix: String = "EffectShape"

    // MEMO: ばね運動をするAnimation用の設定
    private let springAnimation: Animation = .spring(
        response: 0.5,
        dampingFraction: 0.7
    )

    // MARK: - Property (Grid Layout)

    // MEMO: LazyVGridで利用するColumn定義
    private let gridColumns = [
        GridItem(spacing: 4.0),
        GridItem(spacing: 0.0)
    ]

    // MEMO: Grid表示におけるサイズ調整用①
    private let screen = UIScreen.main.bounds

    // MEMO: Grid表示におけるサイズ調整用②
    private var screenWidth: CGFloat {
        return screen.width
    }

    // MEMO: Grid表示におけるサイズ調整用③
    private var standardRectangle: CGFloat {
        return CGFloat((screen.width - 24.0) / 2)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            // 全体をZStackにして表示要素を重ねている
            // 👉 AndroidやFlutter等でよく見る「Hero」Animationの様なイメージ
            ZStack {

                // `@State`で定義した変数の状態を元にして表示状態を決定する
                if selectedMaterial == nil {
                    
                    // 一覧表示時のView全体要素 (全体はScrollView + Grid表示構成)
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 8.0) {
                            ForEach(MaterialFactory.getMaterials()) { material in

                                let name = material.materialName
                                let effectTitleID = material.materialIdentifier + effectTitleSuffix
                                let effectShapeID = material.materialIdentifier + effectShapeSuffix

                                // Grid正方形の表示要素
                                HStack {
                                    VStack {
                                        Text(name)
                                            .foregroundColor(.white)
                                            // 👉 ① Animation対象となるテキスト要素（遷移元）
                                            .matchedGeometryEffect(id: effectTitleID, in: namespace)
                                    }
                                    .frame(width: standardRectangle, height: standardRectangle)
                                    .background(
                                        Rectangle()
                                            // 👉 ② Animation対象となる矩形要素（遷移元）
                                            .matchedGeometryEffect(id: effectShapeID, in: namespace)
                                            .onTapGesture {
                                                // Animationを利用して一覧表示をする正方形をタップすると拡大表示する様に見せる
                                                // 👉 ポイントは「matchedGeometryEffect」Modifierの活用
                                                withAnimation(springAnimation) {
                                                    selectedMaterial = material
                                                }
                                            }
                                    )
                                    Spacer()
                                }
                            }
                        }
                        .padding([.leading], 8.0)
                    }
                    .frame(width: screenWidth)
                                    
                } else {

                    let name = selectedMaterial?.materialName ?? ""
                    let materialFileName = selectedMaterial?.materialIdentifier ?? ""
                    let materialScene = selectedMaterial?.materialFileName
                    let effectTitleID = materialFileName + effectTitleSuffix
                    let effectShapeID = materialFileName + effectShapeSuffix

                    // 拡大時のView全体要素
                    VStack {
                        // (1) ヘッダー表示をするためのView要素を配置する
                        HStack {
                            Text(name)
                                .foregroundColor(.white)
                                // 👉 ① Animation対象となるテキスト要素（遷移先）
                                .matchedGeometryEffect(id: effectTitleID, in: namespace)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(.top, 20.0)
                            Spacer()
                            Button(
                                action: {
                                    // Animationを利用してボタンをタップすると元のGrid表示位置に戻る様に見せる
                                    // 👉 ポイントは「matchedGeometryEffect」Modifierの活用
                                    withAnimation(springAnimation) {
                                        selectedMaterial = nil
                                    }
                                }, 
                                label: {
                                    Text("× 閉じる")
                                }
                            )
                        }
                        .padding(.horizontal, 8.0)
                        // (2) SceneKitを仕込んだView要素を配置する
                        DetailView(scene: materialScene)
                    }
                    // 表示エリアは「横幅いっぱい＆縦400px」を確保する
                    .frame(maxWidth: .infinity, maxHeight: 400.0)
                    .background(
                        Rectangle()
                            // 👉 ② Animation対象となる矩形要素（遷移先）k
                            .matchedGeometryEffect(id: effectShapeID, in: namespace)
                    )
                }
            }
            .frame(width: screenWidth)
            .navigationTitle("3Dモデルを表示して回転させよう♻️")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Entity

struct MaterialEntity: Identifiable {
    let id: UUID = UUID()
    let materialID: Int
    let materialName: String
    let materialIdentifier: String
    let materialFileName: SCNScene?
}

// MARK: - Factory

struct MaterialFactory {
    static func getMaterials() -> [MaterialEntity] {
        return [
            MaterialEntity(
                materialID: 1,
                materialName: "🥞 Pancakes",
                materialIdentifier: "pancakes",
                materialFileName: .init(named: "pancakes.scn")
            ),
            MaterialEntity(
                materialID: 2,
                materialName: "🥪 Sandwitch",
                materialIdentifier: "sandwitch",
                materialFileName: .init(named: "sandwitch.scn")
            ),
            MaterialEntity(
                materialID: 3,
                materialName: "🍔 Burger",
                materialIdentifier: "burger",
                materialFileName: .init(named: "burger.scn")
            ),
            MaterialEntity(
                materialID: 4,
                materialName: "🥟 Gyoza",
                materialIdentifier: "gyoza",
                materialFileName: .init(named: "gyoza.scn")
            ),
            MaterialEntity(
                materialID: 5,
                materialName: "🍱 Thai",
                materialIdentifier: "thai",
                materialFileName: .init(named: "thai.scn")
            ),
            MaterialEntity(
                materialID: 6,
                materialName: "🍕 Pizza",
                materialIdentifier: "pizza",
                materialFileName: .init(named: "pizza.scn")
            ),
        ]
    }
}

#Preview {
    ContentView()
}
