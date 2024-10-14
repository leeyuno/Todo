import ComposableArchitecture
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    let store: Store<AddCore.State, AddCore.Action>
    @ObservedObject var viewStore: ViewStore<AddCore.State, AddCore.Action>
    
    let priorityList = ["긴급", "상", "중", "하"]
    let alarmList = ["1시간 전", "30분 전", "15분 전", "시작"]
    
    init(store: Store<AddCore.State, AddCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationView {
            List {
                requiredFieldsSection
                expandableSection(
                    isExpanded: viewStore.$useLocation,
                    title: "장소",
                    content: {
                        TextField("장소를 입력해주세요.", text: viewStore.$location)
                    },
                    action: { viewStore.send(.useLocation) }
                )
                expandableSection(
                    isExpanded: viewStore.$usePriority,
                    title: "중요도",
                    content: {
                        Picker("", selection: viewStore.$priority) {
                            ForEach(priorityList, id: \.self) { Text($0) }
                        }
                    },
                    action: { viewStore.send(.usePrioity) }
                )
                expandableSection(
                    isExpanded: viewStore.$useColor,
                    title: "색상",
                    content: colorSelectionView,
                    action: { viewStore.send(.useColor) }
                )
                expandableSection(
                    isExpanded: viewStore.$useAlarm,
                    title: "알림",
                    content: {
                        Picker("언제 알려드릴까요?", selection: viewStore.$alarm) {
                            ForEach(alarmList, id: \.self) { Text($0) }
                        }
                    },
                    action: { viewStore.send(.useAlarm) }
                )
                expandableSection(
                    isExpanded: viewStore.$useDaily,
                    title: "매일반복",
                    content: {
                        Toggle("반복", isOn: viewStore.$daily)
                    },
                    action: { viewStore.send(.useDaily) }
                )
            }
            .navigationTitle("Todo")
            .toolbar {
                Button("추가") {
                    viewStore.send(.save)
                }
            }
            .onDisappear {
                viewStore.send(.disappear)
            }
            .onChange(of: viewStore.isCompleted) {
                dismiss()
            }
        }
    }
    
    // MARK: - Sections
    private var requiredFieldsSection: some View {
        Section("필수항목") {
            TextField("할일을 입력해주세요.", text: viewStore.$todo)
            DatePicker("시간을 선택해주세요.", selection: viewStore.$date, displayedComponents: .hourAndMinute)
        }
    }
    
    private func expandableSection<Content: View>(
        isExpanded: Binding<Bool>,
        title: String,
        content: @escaping () -> Content,
        action: @escaping () -> Void
    ) -> some View {
        Section(isExpanded: isExpanded) {
            content()
        } header: {
            HStack {
                Text(title)
                Spacer()
                Button(action: action) {
                    Image(systemName: isExpanded.wrappedValue ? "minus.circle" : "plus.circle")
                }
            }
        }
    }
    
    private var colorSelectionView: some View {
        HStack(alignment: .center) {
            Spacer()
            ForEach([Color.red, Color.orange, Color.yellow, Color.green, Color.blue], id: \.self) { color in
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(color)
                        .opacity(0.7)
                        .onTapGesture {
                            viewStore.send(.changeColor(color))
                        }
                    Image(systemName: "checkmark")
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .frame(width: 40, height: 40)
                        .opacity(viewStore.color == color.description ? 1 : 0)
                }
            }
            Spacer()
        }
    }
}
