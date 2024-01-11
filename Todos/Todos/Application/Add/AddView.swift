//
//  AddView.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 1/10/24.
//

import ComposableArchitecture
import SwiftUI

struct AddView: View {
    let store: Store<AddCore.State, AddCore.Action>
    @ObservedObject var viewStore: ViewStore<AddCore.State, AddCore.Action>
    
    let priorityList: [String] = ["긴급", "상", "중", "하"]
    let alarmList: [String] = ["1시간 전", "30분 전", "15분 전", "시작"]
    
    @State var todo: String = ""
    
    @State private var useLocation: Bool = false
    @State private var usePriority: Bool = false
    @State private var useDate: Bool = false
    @State private var useColor: Bool = false
    @State private var useAlarm: Bool = false
    
    @State private var location: String = ""
    @State var date: Date = .now
    @State var priority: String = ""
    @State var alarm: String = ""
    
    init(store: Store<AddCore.State, AddCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationView {
//            List {
//                
//                Section("필수항목") {
//                    TextField("할일를 입력해주세요.", text: $todo)
//                    TextField("날짜를 입력해주세요.", text: $todo)
//                }
//                
//                Section("추가항목") {
//                    TextField("장소를 입력해주세요.", text: $todo)
//                    TextField("중요도를 입력해주세요.", text: $todo)
//                    TextField("색상을 입력해주세요.", text: $todo)
//                    TextField("알림 입력해주세요.", text: $todo)
//                    TextField("장소를 입력해주세요.", text: $todo)
//                }
//            }
            
            List {
                Section("필수항목") {
                    TextField("할일를 입력해주세요.", text: $todo)
                    DatePicker("시간을 선택해주세요.", selection: $date, displayedComponents: .hourAndMinute)
                }
                
                Section(isExpanded: $useLocation) {
                    TextField("장소를 입력해주세요.", text: $location)
                } header: {
                    HStack {
                        Text("장소")
                        Spacer()
                        Button(
                            "",
                               systemImage: useLocation ? "minus.circle" : "plus.circle"
                        ) {
                            useLocation.toggle()
                        }
                    }
                }
                
                Section(isExpanded: $usePriority) {
                    Picker("", selection: $priority) {
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
                               systemImage: usePriority ? "minus.circle" : "plus.circle"
                        ) {
                            usePriority.toggle()
                        }
                    }
                }
                
                Section(isExpanded: $useColor) {
                    HStack(alignment: .center) {
                        Spacer()
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.red)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.white)
                            }
                            .onTapGesture { }
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.orange)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.white)
                            }
                            .onTapGesture { }
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.yellow)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.white)
                            }
                            .onTapGesture { }
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.green)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.white)
                            }
                            .onTapGesture { }
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.blue)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.white)
                            }
                            .onTapGesture { }
                    }
                } header: {
                    HStack {
                        Text("색상")
                        Spacer()
                        Button(
                            "",
                               systemImage: useColor ? "minus.circle" : "plus.circle"
                        ) {
                            useColor.toggle()
                        }
                    }
                }
                Section(isExpanded: $useAlarm) {
                    Picker("언제 알려드릴까요?", selection: $alarm) {
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
                               systemImage: useAlarm ? "minus.circle" : "plus.circle"
                        ) {
                            useAlarm.toggle()
                        }
                    }
                }
            }
        }
        .navigationTitle("Todo")
    }
}

//#Preview {
//    AddView(store: <#T##Store<AddCore.State, AddCore.Action>#>)
//}
