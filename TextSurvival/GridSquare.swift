//
//  GridSquare.swift
//  TextSurvival
//
//  Created by David Wells on 7/10/26.
//
import SwiftUI

@Observable
class GridSquare {
    var red = 0.0
    var green = 0.0
    var blue = 0.0
    private let d2 = 0.1
    
    func getPower() -> Double {
        return red + green + blue
    }
    func resetRed() {
        reset()
        red = 1.0
    }
    func reset() {
        red = 0.0
        green = 0.0
        blue = 0.0
    }
    func moveTowardsGeneralColorIfPresent(_ delta: Float) {
        switch(getGeneralColor()) {
        case .green: assimilateTowards(r: 0.0, g: 1.0, b: 0.0, delta: delta)
        case .red: assimilateTowards(r: 1.0, g: 0.0, b: 0.0, delta: delta)
        case .blue: assimilateTowards(r: 0.0, g: 0.0, b: 1.0, delta: delta)
        default: break
        }
    }
    
    func purity(r: Double, g: Double, b: Double) -> Double {
        let maxValue = max(r, g, b)
        let minValue = min(r, g, b)

        return maxValue - minValue
    }
    
    func assimilateTowards(r: Double, g: Double, b: Double, delta: Float) {
        let nearColor = TextSurvival.getGeneralColor(red: r, green: g, blue: b)

        let purity = purity(r: r, g: g, b: b)

        // 0 = gray, 1 = pure color
        let speed = 0.1 + purity * 0.53

        red += (r - red) * Double(delta) * speed
        green += (g - green) * Double(delta) * speed * 2
        blue += (b - blue) * Double(delta) * speed * 2
//        var allMult = 1.0
//        let nearColor = TextSurvival.getGeneralColor(red: r, green: g, blue: b)
//        
//        var rMult = 0.1 * (r)
//        var gMult = 0.1 * (g)
//        var bMult = 0.1 * (b)
//        
//        switch(nearColor) {
//        case .red: rMult *= 3.0
//        case .green: gMult *= 3.0
//        case .blue: bMult *= 3.0
//        default: allMult *= 1.0
//        }
//        red += (r - red) * Double(delta) * rMult * allMult
//        green += (g - green) * Double(delta) * gMult * allMult
//        blue += (b - blue) * Double(delta) * bMult * allMult
    }
    func getColor() -> Color {
        return Color(red: red, green: green, blue: blue)
    }
    func getGeneralColor() -> Color {
        return TextSurvival.getGeneralColor(red: red, green: green, blue: blue)
    }
}

func getGeneralColor(red: Double, green: Double, blue: Double) -> Color {
    let d1: Double = 0.3

    if(red + green + blue < 0.5) {
        return .white
    }
    if(red > green + d1 && red > blue + d1) {
        return .red
    } else if (green > red + d1 && green > blue + d1) {
        return .green
    } else if (blue > red + d1 && blue > green + d1) {
        return .blue
    } else {
        return .white
    }
}
