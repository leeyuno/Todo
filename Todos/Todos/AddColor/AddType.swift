//
//  AddColor.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import ComposableArchitecture
import SwiftUI

struct SquareColorPickerView: View {
    
    @Binding var colorValue: Color
    
    var body: some View {
        
        colorValue
            .frame(width: 40, height: 40, alignment: .center)
            .cornerRadius(10.0)
            .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.white, style: StrokeStyle(lineWidth: 5)))
            .padding(10)
            .background(AngularGradient(gradient: Gradient(colors: [.red,.yellow,.green,.blue,.purple,.pink]), center:.center).cornerRadius(20.0))
            .overlay(ColorPicker("", selection: $colorValue).labelsHidden().opacity(0.015))
            .shadow(radius: 5.0)

    }
}

struct AddTypeView: View {
    let store: Store<AddType.State, AddType.Action>
    @ObservedObject var viewStore: ViewStore<AddType.State, AddType.Action>
    
    @State var colorValue: Color = Color.yellow
    
    init(store: Store<AddType.State, AddType.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                Text("할일을 색깔로 표현해보세요!")
                SquareColorPickerView(colorValue: self.viewStore.$color)
                
                Text(viewStore.item.title)
                Spacer()
            }.toolbar {
                NavigationLink {
                    AddTimeView(
                        store: self.timeStore
                    )
                } label: {
                    Text("중요도")
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
        }
    }
}

extension AddTypeView {
    private var timeStore: Store<AddTime.State, AddTime.Action> {
        return store.scope(state: { $0.timeState }, action: AddType.Action.next)
    }
}
