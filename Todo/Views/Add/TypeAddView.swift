//
//  TypeAddView.swift
//  Todo
//
//  Created by 이윤오 on 2022/12/05.
//

import SwiftUI

struct TypeAddView: View {
    var todoItem: Todo
    var types = ["회사", "학교", "개인", "기타"]
    var priority = ["높음", "보통", "낮음"]
    
    @State var isShowingTypePicker = false
    @State var selectedType = "회사"
    @State var isShowingPriorityPicker = false
    @State var selectedPriority = "높음"
    
    var body: some View {
        List {
            Section("타입") {
                Picker("타입", selection: $selectedType) {
                    ForEach(types, id: \.self) { type in
                        Text(type)
                    }
                }
            }
            
            Section("중요도") {
                Picker("중요도", selection: $selectedPriority) {
                    ForEach(priority, id: \.self) { type in
                        Text(type)
                    }
                }
            }
        }
//        .navigationBarItems(trailing: DateAddView())
        
        .toolbar {
            NavigationLink(destination: DateAddView(todoItem: Todo())) {
                Text("다음")
            }
        }
        .navigationBarTitle("타입")
    }
}

struct TypeAddView_Previews: PreviewProvider {
    static var previews: some View {
        TypeAddView(todoItem: Todo())
    }
}
