//
//  AddressListView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.08.2026.
//

import SwiftUI
import DesignSystem

struct AddressListView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var isAddressMapPresenter = false

    var body: some View {
        HStack {
            Text("Мои адреса")
                .font(DSTypography.hugeTitle)
            Spacer()
            CloseButton(action: { dismiss() })
        }
        .padding(.horizontal, 12)
        .padding(.top, 18)
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                AddressCell(
                    address: "Новая Басманная ул., 35 ст1, 59\n",
                    details: "3 этаж, 4 подъезд, код домофона 15809",
                    isSelected: true
                )
                Button {
                    isAddressMapPresenter = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("Новый адрес")
                    }
                    .padding(.horizontal, 12)
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $isAddressMapPresenter) {
                    AddressMapView()
                }
            }
        }
        Spacer()
        DSButton(
            action: {},
            buttonTitle: "Привезти сюда"
        )
        .padding(.horizontal, 12)
    }
}

#Preview {
    AddressListView()
}
