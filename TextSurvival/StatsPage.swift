//
//  StatsPage.swift
//  TextSurvival
//
//  Created by David Wells on 7/9/26.
//

import SwiftUI

struct StatsPage : View {
    @State var viewModel = StatsViewModel()
    @AppStorage("highScore")
    private var highScore: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(Int(viewModel.score).description)
                    .font(.largeTitle.monospacedDigit())
                
                let columns = Array(repeating: GridItem(.fixed(32), spacing: 0), count: 10)
                
                ZStack {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(0..<100, id: \.self) { index in
                            let row = index / 10
                            let col = index % 10
                            let gridSquare = viewModel.grid[row][col]
                            
                            Button {
                                viewModel.select(row: row, col: col)
                            } label: {
                                Rectangle()
                                    .fill(gridSquare.getColor())
                                    .frame(width: 32, height: 32)
                                    .border(gridSquare.getGeneralColor(), width: 4)
                            }
                        }
                    }
                    if (viewModel.message != "") {
                        VStack {
                            Text(viewModel.message)
                                .font(.largeTitle.bold())
                            Text("Time \(Int(viewModel.elapsedTime))s")
                            Text("Score: \(Int(viewModel.score))\n High Score: \(highScore)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }.padding()
                            .background(.white)
                            .clipShape(Capsule())
                    }
                }
                HStack() {
                    IconStat(systemName: "heart.fill", text: Int(viewModel.health).description,
                             color: .red)
                    Spacer()
                    IconStat(systemName: "carrot.fill", text: Int(viewModel.satiation).description,
                             color: .green)
                    Spacer()
                    IconStat(systemName: "drop.fill", text: Int(viewModel.hydration).description,
                             color: .blue)
                    Spacer()
                    IconStat(systemName: "bolt.fill", text: Int(viewModel.energy).description,
                             color: .yellow)
                }
                HStack {
                    VStack {
                        ActionButton(
                            action: { viewModel.plantMode = .DRINK},
                            highlight: viewModel.plantMode == .DRINK,
                            text: "Plant -10",
                            color: .green
                        )
                        ActionButton(
                            action: { viewModel.plantMode = .WATER},
                            highlight: viewModel.plantMode == .WATER,
                            text: "Water -10",
                            color: .blue
                        )
                    }
                    VStack {
                        ActionButton(
                            action: { viewModel.plantMode = .EAT},
                            highlight: viewModel.plantMode == .EAT,
                            text: "Consume -10",
                            color: .yellow
                        )
                        ActionButton(
                            action: { viewModel.plantMode = .KILL},
                            highlight: viewModel.plantMode == .KILL,
                            text: "Kill -1",
                            color: .red
                        )
                    }
                }
                Spacer()
                HStack(spacing:12) {
                    Spacer()
                    ActionButton(action: {viewModel.reset()},
                                 highlight: false,
                                 text: "Reset Game",
                                 color: .black)
                    NavigationLink {
                        StartingScreen()
                    } label: {
                        Text("Quit")
                            .padding()
                            .background(.black)
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                }
            }.task {
                let interval = 0.01
                Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
                    viewModel.passTime(Float(interval))
                    if highScore < Int(viewModel.score) {
                        highScore = Int(viewModel.score)
                    }
                })
            }.navigationBarBackButtonHidden(true)
        }
    }
}

struct ActionButton: View {
    let action: () -> Void
    let highlight: Bool
    let text: String
    let color: Color
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
        }
        .frame(width: 120)
        .padding()
        .background(color)
        .clipShape(Capsule())
        .padding(2)
        .background(highlight ? .black : color)
        .clipShape(Capsule())
        .foregroundColor(.white)
    }
}

struct IconStat: View {
    let systemName: String
    var text: String
    var color: Color = .black
    
    var body: some View {
        HStack {
            Text(text)
            LoneIcon(systemName: systemName, color:color)
        }
    }
}

struct LoneIcon: View {
    let systemName: String
    let color: Color
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width:30, height: 30)
            .foregroundColor(color)
    }
}
