//
//  ContentView.swift
//  ARDemoSample
//
//  Created by 酒井文也 on 2024/05/19.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    
    @State private var show = false
    @State private var selectedMaterial: MaterialEntity? = nil

    @Namespace private var namespace

    private let effectTitleSuffix: String = "EffectTitle"
    private let effectShapeSuffix: String = "EffectShape"

    //
    private let springAnimation: Animation = .spring(response: 0.5, dampingFraction: 0.7)
    
    private let gridColumns = [
        GridItem(spacing: 4.0),
        GridItem(spacing: 0.0)
    ]

    private let screen = UIScreen.main.bounds

    private var screenWidth: CGFloat {
        return screen.width
    }

    private var standardRectangle: CGFloat {
        return CGFloat((screen.width - 24.0) / 2)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !show, selectedMaterial == nil {
                    
                    //
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 8.0) {
                            ForEach(MaterialFactory.getMaterials()) { material in

                                let name = material.materialName
                                let effectTitleID = material.materialIdentifier + effectTitleSuffix
                                let effectShapeID = material.materialIdentifier + effectShapeSuffix

                                //
                                HStack {
                                    VStack {
                                        Text(name)
                                            .foregroundColor(.white)
                                            .matchedGeometryEffect(id: effectTitleID, in: namespace)
                                    }
                                    .frame(width: standardRectangle, height: standardRectangle)
                                    .background(
                                        Rectangle()
                                            .matchedGeometryEffect(id: effectShapeID, in: namespace)
                                            .onTapGesture {
                                                //
                                                withAnimation(springAnimation) {
                                                    show.toggle()
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

                    //
                    let name = selectedMaterial?.materialName ?? ""
                    let materialFileName = selectedMaterial?.materialIdentifier ?? ""
                    let materialScene = selectedMaterial?.materialFileName
                    let effectTitleID = materialFileName + effectTitleSuffix
                    let effectShapeID = materialFileName + effectShapeSuffix

                    //
                    VStack {
                        //
                        HStack {
                            Text(name)
                                .foregroundColor(.white)
                                .matchedGeometryEffect(id: effectTitleID, in: namespace)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(.top, 16.0)
                            Spacer()
                            Button(
                                action: {
                                    //
                                    withAnimation(springAnimation) {
                                        show.toggle()
                                        selectedMaterial = nil
                                    }
                                }, 
                                label: {
                                    Text("× 閉じる")
                                }
                            )
                        }
                        .padding(.horizontal, 8.0)
                        //
                        DetailView(scene: materialScene)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 400.0)
                    .background(
                        Rectangle()
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
