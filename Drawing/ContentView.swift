//
//  ContentView.swift
//  Drawing
//
//  Created by PBB on 2019/11/7.
//  Copyright © 2019 PBB. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var colorCycle = 0.0
    @State private var arrowThickness = 0.0
    
    var body: some View {
        VStack {
            Arrow(amount: CGFloat(arrowThickness))
                .stroke(Color.red, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .onTapGesture {
                    withAnimation {
                        if self.arrowThickness == 0 {
                            self.arrowThickness = 40
                        } else {
                            self.arrowThickness = 0
                        }
                    }
            }
            
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        
        return path
    }
}

struct Arrow: InsettableShape {
    
    var amount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: amount, y: rect.height / 3))
        path.addLine(to: CGPoint(x: rect.width - amount, y: rect.height / 3))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 0))
        
        path.addRect(CGRect(x: rect.width / 4 + amount, y: rect.height / 3, width: rect.width / 2 - amount * 2, height: rect.height / 3 * 2))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> Arrow {
        var arrow = self
        arrow.amount = amount
        return arrow
    }
    
    var animatableData: CGFloat {
        get { self.amount }
        set { self.amount = newValue }
    }
}

struct Flower: Shape {
    var petalOffset: Double = -20
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        return path
    }
}


struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { step in
                Circle()
                    .inset(by: CGFloat(step))
//                    .strokeBorder(self.color(for: step, brightness: 1), lineWidth: 2)
                .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                    self.color(for: step, brightness: 1),
                    self.color(for: step, brightness: 0.5),
                ]),startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
