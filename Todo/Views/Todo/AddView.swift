//
//  AddView.swift
//  Todo
//
//  Created by 이윤오 on 2022/11/03.
//

import SwiftUI

import RealmSwift

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var title = TextBindingManager(limit: 15)
    
    @State var type = ""
    private var types = ["회사", "학교", "개인", "기타"]
    private var priority = ["높음", "보통", "낮음"]
    
    @State var isShowingTypePicker = false
    @State var selectedType = "회사"
    @State var isShowingPriorityPicker = false
    @State var selectedPriority = "높음"
    @State var selectedDate = Date()
    
    var body: some View {
        List {
            Section("내용") {
                TextField("할일을 입력하세요 (15자 이내)", text: $title.text)
            }
            
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
            
            Section("날짜") {
                DatePicker("날짜 선택", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
//                Form {
//                    DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
//                }
            }
         
            Section() {
                HStack(alignment: .center) {
                    Button {
                        createTODO()
                    } label: {
                        Text("추가하기").font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    func createTODO() {
        let todo = Todo()
        
        guard title.text == "" else {
            
            return
        }
        
        todo.title = title.text
        todo.type = selectedType
        todo.priority = selectedPriority
        todo.date = selectedDate

        let store = TodoDataStore.shared
        store.write(todo) { isSuccess in
            if isSuccess {
                dismiss()
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
