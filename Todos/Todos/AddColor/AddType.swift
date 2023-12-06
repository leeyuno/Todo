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
            .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.white, style: StrokeStyle(lineWidth: 3)))
            .padding(12)
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
            ZStack {
                viewStore.color
                    .animation(.default)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 20) {
                    Text("\"\(self.viewStore.title)\" 색깔로 구분해보세요!").font(.title2).bold()
//                    SquareColorPickerView(colorValue: self.viewStore.$color)
//                        .frame(height: 50)
                    Spacer()
                    HStack {
                        Spacer()
                        
                        VStack {
                            Circle()
                                .frame(
                                    width: viewStore.color == Color.blue ? 60 : 50,
                                    height: viewStore.color == Color.blue ? 60 : 50)
                                .foregroundColor(Color.blue)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(Color.white)
                                }
                                .onTapGesture {
                                    viewStore.send(.changeColor(Color.blue))
                                }
                            
                            Circle()
                                .frame(
                                    width: viewStore.color == Color.pink ? 60 : 50,
                                    height: viewStore.color == Color.pink ? 60 : 50)
                                .foregroundColor(Color.pink)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(Color.white)
                                }
                                .onTapGesture {
                                    viewStore.send(.changeColor(Color.pink))
                                }
                            
                            Circle()
                                .frame(
                                    width: viewStore.color == Color.yellow ? 60 : 50,
                                    height: viewStore.color == Color.yellow ? 60 : 50)
                                .foregroundColor(Color.yellow)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(Color.white)
                                }
                                .onTapGesture {
                                    viewStore.send(.changeColor(Color.yellow))
                                }
                            
                            Circle()
                                .frame(
                                    width: viewStore.color == Color.green ? 60 : 50,
                                    height: viewStore.color == Color.green ? 60 : 50)
                                .foregroundColor(Color.green)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(Color.white)
                                }
                                .onTapGesture {
                                    viewStore.send(.changeColor(Color.green))
                                }
                            
                            Circle()
                                .frame(
                                    width: viewStore.color == Color.orange ? 60 : 50,
                                    height: viewStore.color == Color.orange ? 60 : 50)
                                .foregroundColor(Color.red)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(Color.white)
                                }
                                .onTapGesture {
                                    viewStore.send(.changeColor(Color.orange))
                                }
                            
                            Circle()
                                .frame(
                                    width: viewStore.color == Color.purple ? 60 : 50,
                                    height: viewStore.color == Color.purple ? 60 : 50)
                                .foregroundColor(Color.purple)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(Color.white)
                                }
                                .onTapGesture {
                                    viewStore.send(.changeColor(Color.purple))
                                }
                        }
                        .animation(.easeInOut, value: viewStore.color)
                        .frame(width: 50)
                    }
                    .padding([.trailing, .bottom], 25)
                }
                
            }.toolbar {
                NavigationLink {
                    AddTimeView(
                        store: self.timeStore
                    )
                } label: {
                    Text("중요도")
                }
            }
        }
    }
}

extension AddTypeView {
    private var timeStore: Store<AddTime.State, AddTime.Action> {
        return store.scope(state: { $0.timeState }, action: AddType.Action.next)
    }
}
