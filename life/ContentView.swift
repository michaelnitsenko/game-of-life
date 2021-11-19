//
//  ContentView.swift
//  life
//
//  Created by Michael on 11/19/21.
//

import SwiftUI

struct Cell {
    var isAlive: Bool
}

struct ContentView: View {
    private let timer = Timer
        .publish(every: 0.15, on: .current, in: .common)
        .autoconnect()
    
    @State private var cells: [[Cell]] = []
    @Binding var isPlaying: Bool
    
    var body: some View {
        let rows = 50
        let columns = 100
        let cellSize: CGFloat = 10
        
        ZStack {
            if cells.isEmpty {
                EmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0 ..< rows) { i in
                            HStack(spacing: 0) {
                                ForEach(0 ..< columns) { j in
                                    let cell = cells[i][j]
                                    
                                    Rectangle()
                                        .fill(cell.isAlive ? Color.black : Color.white)
                                        .border(Color.gray, width: 0.5)
                                        .frame(width: cellSize, height: cellSize)
                                        .onTapGesture {
                                            cells[i][j].isAlive.toggle()
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(width: CGFloat(columns) * cellSize,
               height: CGFloat(rows) * cellSize)
        .onAppear {
            var cells: [[Cell]] = []
            for _ in 0 ..< rows {
                var row: [Cell] = []
                for _ in 0 ..< columns {
                    row.append(.init(isAlive: false))
                }
                
                cells.append(row)
            }
            
            self.cells = cells
        }
        .onReceive(timer) { _ in
            guard isPlaying, !self.cells.isEmpty else {
                return
            }
            
            let neighboursAlive: (Int, Int) -> UInt = { i, j in
                var count: UInt = 0
                
                // top-left
                if i > 0 {
                    if j > 0 {
                        count += self.cells[i - 1][j - 1].isAlive ? 1 : 0
                    }
                }
                
                // top
                if i > 0 {
                    count += self.cells[i - 1][j].isAlive ? 1 : 0
                }
                
                // top-right
                if i > 0 {
                    if j < columns - 1 {
                        count += self.cells[i - 1][j + 1].isAlive ? 1 : 0
                    }
                }
                
                // left
                if j > 0 {
                    count += self.cells[i][j - 1].isAlive ? 1 : 0
                }
                
                // right
                if j < columns - 1 {
                    count += self.cells[i][j + 1].isAlive ? 1 : 0
                }
                
                // bottom-left
                if i < rows - 1 {
                    if j > 0 {
                        count += self.cells[i + 1][j - 1].isAlive ? 1 : 0
                    }
                }
                
                // bottom
                if i < rows - 1 {
                    count += self.cells[i + 1][j].isAlive ? 1 : 0
                }
                
                // bottom-right
                if i < rows - 1 {
                    if j < columns - 1 {
                        count += self.cells[i + 1][j + 1].isAlive ? 1 : 0
                    }
                }
                
                return count
            }
            
            var cells: [[Cell]] = []
            for i in 0 ..< rows {
                var rows: [Cell] = []
                for j in 0 ..< columns {
                    let count = neighboursAlive(i, j)
                    let isAlive: Bool
                    if self.cells[i][j].isAlive {
                        isAlive = count == 2 || count == 3
                    } else {
                        isAlive = count == 3
                    }
                    
                    rows.append(.init(isAlive: isAlive))
                }
                
                cells.append(rows)
            }
            
            self.cells = cells
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isPlaying: .constant(false))
    }
}
