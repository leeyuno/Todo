//
//  AddView.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 1/10/24.
//

import ComposableArchitecture
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    let store: Store<AddCore.State, AddCore.Action>
    @ObservedObject var viewStore: ViewStore<AddCore.State, AddCore.Action>
    
    let priorityList: [String] = ["긴급", "상", "중", "하"]
    let alarmList: [String] = ["1시간 전", "30분 전", "15분 전", "시작"]
    
    init(store: Store<AddCore.State, AddCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("필수항목") {
                    TextField("할일를 입력해주세요.", text: viewStore.$todo)
                    DatePicker("시간을 선택해주세요.", selection: viewStore.$date, displayedComponents: .hourAndMinute)
                }
                
                Section(isExpanded: viewStore.$useLocation) {
                    TextField("장소를 입력해주세요.", text: viewStore.$location)
                } header: {
                    HStack {
                        Text("장소")
                        Spacer()
                        Button(
                            "",
                            systemImage: viewStore.useLocation ? "minus.circle" : "plus.circle"
                        ) {
                            viewStore.send(.useLocation)
                        }
                    }
                }
                
                Section(isExpanded: viewStore.$usePriority) {
                    Picker("", selection: viewStore.$priority) {
                        ForEach(priorityList, id: \.self) {
                            Text($0)
                        }
                    }
                } header: {
                    HStack {
                        Text("중요도")
                        Spacer()
                        Button(
                            "",
                            systemImage: viewStore.usePriority ? "minus.circle" : "plus.circle"
                        ) {
                            viewStore.send(.usePrioity)
                        }
                    }
                }
                
                Section(isExpanded: viewStore.$useColor) {
                    HStack(alignment: .center) {
                        Spacer()
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.red)
                                .opacity(0.7)
                                .onTapGesture {
                                    viewStore.send(.changeColor(.red))
                                }
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundStyle(Color.white)
                                .frame(width: 40, height: 40)
                                .opacity(viewStore.color == "red" ? 1 : 0)
                        }
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.orange)
                                .opacity(0.7)
                                .onTapGesture {
                                    viewStore.send(.changeColor(.orange))
                                }
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundStyle(Color.white)
                                .frame(width: 40, height: 40)
                                .opacity(viewStore.color == "orange" ? 1 : 0)
                        }
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.yellow)
                                .opacity(0.7)
                                .onTapGesture {
                                    viewStore.send(.changeColor(.yellow))
                                }
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundStyle(Color.white)
                                .frame(width: 40, height: 40)
                                .opacity(viewStore.color == "yellow" ? 1 : 0)
                        }
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.green)
                                .opacity(0.7)
                                .onTapGesture {
                                    viewStore.send(.changeColor(.green))
                                }
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundStyle(Color.white)
                                .frame(width: 40, height: 40)
                                .opacity(viewStore.color == "green" ? 1 : 0)
                        }
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.blue)
                                .opacity(0.7)
                                .onTapGesture {
                                    viewStore.send(.changeColor(.blue))
                                }
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundStyle(Color.white)
                                .frame(width: 40, height: 40)
                                .opacity(viewStore.color == "blue" ? 1 : 0)
                        }
                    }
                } header: {
                    HStack {
                        Text("색상")
                        Spacer()
                        Button(
                            "",
                            systemImage: viewStore.useColor ? "minus.circle" : "plus.circle"
                        ) {
                            viewStore.send(.useColor)
                        }
                    }
                }
                Section(isExpanded: viewStore.$useAlarm) {
                    Picker("언제 알려드릴까요?", selection: viewStore.$alarm) {
                        ForEach(alarmList, id: \.self) {
                            Text($0)
                        }
                    }
                } header: {
                    HStack {
                        Text("알림")
                        Spacer()
                        Button(
                            "",
                            systemImage: viewStore.useAlarm ? "minus.circle" : "plus.circle"
                        ) {
                            viewStore.send(.useAlarm)
                        }
                    }
                }
                Section(isExpanded: viewStore.$useDaily) {
                    HStack {
                        Toggle("반복", isOn: viewStore.$daily)
                    }
                } header: {
                    HStack {
                        Text("매일반복")
                        Spacer()
                        Button(
                            "",
                            systemImage: viewStore.useAlarm ? "minus.circle" : "plus.circle"
                        ) {
                            viewStore.send(.useDaily)
                        }
                    }
                }
            }
        }
        .toolbar {
            Button("추가") {
                viewStore.send(.save)
            }
        }
        .navigationTitle("Todo")
        .onDisappear {
            viewStore.send(.disappear)
        }
        .onChange(of: viewStore.isCompleted, {
            dismiss()
        })
    }
}
