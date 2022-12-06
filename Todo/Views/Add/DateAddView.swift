//
//  DateAddView.swift
//  Todo
//
//  Created by 이윤오 on 2022/12/06.
//

import SwiftUI

struct DateAddView: View {
    @Environment(\.dismiss) var dismiss
    @State var todoItem: Todo
    @State var selectedDate: Date = Date()
    
    var body: some View {
        DatePicker("날짜 선택", selection: Binding<Date>(get: { todoItem.date ?? Date() }, set: { todoItem.date = $0 }), in: Date()..., displayedComponents: [.date, .hourAndMinute])
            .datePickerStyle(GraphicalDatePickerStyle())
            .toolbar {
                Button("저장") {
                    TodoDataStore.shared.write(todoItem) { isSuccess in
                        print(isSuccess)
                    }
//                    TodoDataStore.shared.write { isSuccess in
//                        dismiss()
//                    }
                }
            }
            .navigationTitle("날짜")
    }
}

struct DateAddView_Previews: PreviewProvider {
    static var previews: some View {
        DateAddView(todoItem: Todo())
    }
}
