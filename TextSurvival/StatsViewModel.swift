//
//  Untitled.swift
//  TextSurvival
//
//  Created by David Wells on 7/9/26.
//
import SwiftUI

@Observable
class StatsViewModel {
    var health: Float = 100
    var satiation: Float = 50
    var hydration: Float = 50
    var energy: Float = 100
    
    var plantMode: PlantMode = PlantMode.PLANT
    var elapsedTime: Float = 0.0
    var message = ""
    var score:Float = 0.0
    
    var grid: [[GridSquare]] = (0..<10).map { _ in
        (0..<10).map { _ in
            GridSquare()
        }
    }
    var selectedRow = -1
    var selectedCol = -1
    
    private func eat() {
        satiation += 10
        hydration -= 5
        energy -= 10
        score += 100
    }
    private func drink() {
        hydration += 10
        energy -= 5
        score += 100
    }
    func select(row: Int, col: Int) {
        selectedRow = row
        selectedCol = col
        let color = grid[row][col].getGeneralColor()
        switch(plantMode) {
        case PlantMode.EAT:
            if(color == .green) {
                grid[row][col].resetRed()
                eat()
            }
            else if(color == .blue) {
                grid[row][col].resetRed()
                drink()
            }
        case PlantMode.KILL:
            grid[row][col].reset()
            energy -= 1
        case PlantMode.WATER:
            if(energy > 10) {
                water(row, col)
            }
        default: //PLANT
            if(energy > 10) {
                plant(row, col)
            }
        }
        
    }
    
    func plant(_ row: Int, _ col: Int) {
        energy -= 10
        grid[row][col].reset()
        grid[row][col].green = 1.0
        score += 100
    }
    func water(_ row: Int, _ col: Int) {
        energy -= 10
        grid[row][col].reset()
        grid[row][col].blue = 1.0
        score += 100
    }
    func reset() {
        health = 100
        satiation = 50
        hydration = 50
        energy = 100
        elapsedTime = 0.0
        message = ""
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                grid[row][col].reset()
            }
        }
    }
    
    func passTime(_ delta: Float) {
        if(health > 0) {
            updateStats(delta)
            updateGrid(delta)
            updateScore(delta)
            elapsedTime += delta
        } else {
            atEndGame()
        }
    }
    
    func atEndGame() {
        energy = 0
        message = "Game Over."
    }
    
    func updateScore(_ delta: Float) {
        score = score + Float(satiation + hydration) * delta * 0.1
    }
    
    func updateGrid(_ delta: Float) {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                grid[row][col].moveTowardsGeneralColorIfPresent(delta/2)
                
                let thisPower = grid[row][col].getPower()
                //from above
                if(row > 0) {
                    let o = grid[row-1][col]
                    if(thisPower < o.getPower()) {
                        grid[row][col].assimilateTowards(
                            r: o.red, g: o.green, b: o.blue, delta: delta)
                    }
                }
                //from left
                if(col > 0) {
                    let o = grid[row][col-1]
                    if(thisPower < o.getPower()) {
                        grid[row][col].assimilateTowards(
                            r: o.red, g: o.green, b: o.blue, delta: delta)
                    }
                }
                //from right
                if(row < grid.count-1) {
                    let o = grid[row+1][col]
                    if(thisPower < o.getPower()) {
                        grid[row][col].assimilateTowards(
                            r: o.red, g: o.green, b: o.blue, delta: delta)
                    }
                }
                //from below
                if(col < grid[0].count-1) {
                    let o = grid[row][col+1]
                    if(thisPower < o.getPower()) {
                        grid[row][col].assimilateTowards(
                            r: o.red, g: o.green, b: o.blue, delta: delta)
                    }
                }
            }
        }
    }
    func updateStats(_ delta: Float) {
        if hydration > 50 && satiation > 10 {
            if(Int(health) != 100 && energy > delta) {
                health += delta*2
                energy -= delta
            }
        }
        else {
            energy += delta
        }
        if (hydration <= 0) {
            health -= delta*2
        }
        if (satiation <= 0) {
            health -= delta*2
        }
        if (energy <= 0) {
            health -= delta
        }
        if(health > 0 && satiation > 0 && hydration > 0) {
            energy += delta * 2 + delta * ((health / 100.0 * satiation / 100.0 * hydration / 100.0) * 2.0)
        }
        satiation -= delta
        hydration -= delta
        normalizeStats()
    }
    func normalizeStats() {
        clamp(&health)
        clamp(&satiation)
        clamp(&hydration)
        clamp(&energy)
    }
    func clamp(_ stat: inout Float) {
        stat = min(max(stat, 0), 100)
    }
}

enum PlantMode {
    case KILL
    case EAT
    case DRINK
    case WATER
    case PLANT
}
