//
//  TodoHome.swift
//  Todo
//
//  Created by 이윤오 on 2022/11/03.
//

import SwiftUI

import RealmSwift

struct TodoHome: View {
    @State var presentingAddView = false
    @State var todoList: [Todo] = TodoDataStore.shared.fetch()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Header").font(.headline)) {
                        ForEach(0 ..< 5) { index in
                            Text("row: \(index)")
                        }
                    }
                    
                    Section(header: Text("Header 2").font(.headline)) {
                        ForEach(0 ..< 5) { index in
                            Text("row: \(index)")
                        }
                    }
                }
                .toolbar {
                    Button {
                        self.presentingAddView = true
                    } label: {
                        Image(systemName: "plus.rectangle")
                            .resizable()
                            .padding([.trailing], 10)
                            .font(.title2)
                    }.sheet(isPresented: $presentingAddView) {
                        AddView()
                    }
                }
            }
        }
    }
}

struct TodoHome_Previews: PreviewProvider {
    static var previews: some View {
        TodoHome()
    }
}
