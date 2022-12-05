//
//  ContentView.swift
//  Todo
//
//  Created by 이윤오 on 2022/11/03.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .todo
    
    enum Tab {
        case todo
        case calendar
    }
    
    var body: some View {
        TodoHome()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
