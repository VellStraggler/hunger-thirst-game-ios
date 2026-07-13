//
//  StartingScreen.swift
//  TextSurvival
//
//  Created by David Wells on 7/10/26.
//
import SwiftUI

struct StartingScreen : View {
    @AppStorage("highScore")
    private var highScore = 0
    
    
    var body: some View {
        NavigationStack {
            Spacer()
            HStack {
                LoneIcon(systemName: "heart.fill", color: .red)
                LoneIcon(systemName: "carrot.fill", color: .green)
                LoneIcon(systemName: "drop.fill", color: .blue)
                LoneIcon(systemName: "bolt.fill", color: .yellow)
            }
            Text("Hunger & Thirst")
                .font(.largeTitle.bold())
            Text("Description")
                .font(.headline)
            Text("Grow your resources to survive. Don't ruin your crop. Survive as long as you can.")
            Spacer()
            NavigationLink {
                StatsPage()
            } label : {
                Text("Start")
                    .padding()
                    .background(.green)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
            }
            Text("Highest Score: \(highScore)")
            Spacer()
        }.padding(24)
            .navigationBarBackButtonHidden(true)
    }
}
