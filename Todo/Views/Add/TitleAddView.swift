//
//  TitleAddViw.swift
//  Todo
//
//  Created by 이윤오 on 2022/12/05.
//

import SwiftUI

struct TitleAddView: View {
    @ObservedObject var title = TextBindingManager(limit: 15)
    @State var isEditingTitle: Bool = false
    @State var presentingNextView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("일정을 입력해주세요 (15자 이내)", text: $title.text, onEditingChanged: { isEditing in
                    isEditingTitle = isEditing
                })
                    .frame(height: 50)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                    .textFieldStyle(PlainTextFieldStyle())
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(isEditingTitle ? .pink : Color(uiColor: .lightGray), lineWidth: isEditingTitle ? 2.0 : 2.0))
                    .shadow(color: isEditingTitle ? .pink : .clear, radius: isEditingTitle ? 10 : 0)
                    .padding([.horizontal], 24)
                    .padding([.top], 160)
                //
                Spacer()
            }
            .toolbar {
                NavigationLink(destination: TypeAddView()) {
                    Text("다음")
                }.navigationBarTitle("일정")
//                Button {
//                    self.presentingNextView = true
//                } label: {
//                    Text("다음").padding([.trailing], 10).font(.headline)
//                }.sheet(isPresented: $presentingNextView) {
//
//
//                }
            }
        }
    }
}

struct TitleAddViw_Previews: PreviewProvider {
    static var previews: some View {
        TitleAddView()
    }
}
