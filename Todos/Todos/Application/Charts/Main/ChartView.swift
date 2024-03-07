//
//  ChartView.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 2/23/24.
//

import ComposableArchitecture
@preconcurrency import SwiftUI

struct ChartView: View {
    let store: Store<ChartCore.State, ChartCore.Action>
    @ObservedObject var viewStore: ViewStore<ChartCore.State, ChartCore.Action>
    
    init(store: Store<ChartCore.State, ChartCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        Text("여기에 차트")
    }
}

//#Preview {
//    ChartView()
//}
