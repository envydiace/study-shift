//
//  EventColorPickerSection.swift
//  StudyShift
//
//  Created by Đức Anh on 13/5/26.
//

import SwiftUI

struct EventColorPickerSection: View {
    @Binding var selectedColorHex: String
    @Binding var isShowingDropdown: Bool

    let title: String

    private var selectedColorOption: EventColorOption {
        EventColorOption.options.first { $0.hex == selectedColorHex }
        ?? EventColorOption.defaultColor
    }

    init(
        title: String = "Color",
        selectedColorHex: Binding<String>,
        isShowingDropdown: Binding<Bool>
    ) {
        self.title = title
        self._selectedColorHex = selectedColorHex
        self._isShowingDropdown = isShowingDropdown
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation {
                    isShowingDropdown.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Circle()
                        .fill(selectedColorOption.color)
                        .frame(width: 16, height: 16)

                    Text(selectedColorOption.name)
                        .foregroundColor(.blue)

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isShowingDropdown {
                Divider()
                    .padding(.top, 12)

                VStack(spacing: 0) {
                    ForEach(EventColorOption.options) { option in
                        Button {
                            selectedColorHex = option.hex

                            withAnimation {
                                isShowingDropdown = false
                            }
                        } label: {
                            HStack {
                                if selectedColorHex == option.hex {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primary)
                                        .frame(width: 24)
                                } else {
                                    Color.clear
                                        .frame(width: 24)
                                }

                                Text(option.name)
                                    .foregroundColor(.primary)

                                Spacer()

                                Circle()
                                    .fill(option.color)
                                    .frame(width: 18, height: 18)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if option.id != EventColorOption.options.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }

//    private func sectionCard<Content: View>(
//        @ViewBuilder content: () -> Content
//    ) -> some View {
//        content()
//            .padding(16)
//            .background(Color.white)
//            .clipShape(RoundedRectangle(cornerRadius: 18))
//    }
}

//#Preview {
//    EventColorPickerSection()
//}
