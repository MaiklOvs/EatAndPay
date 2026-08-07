//
//  AddressSelectView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 05.08.2026.
//

import SwiftUI
import DesignSystem

struct AddressSelectView: View {

    @State private var mapModel: AddressMapModel
    @Environment(\.dismiss) private var dismiss
    var onSave: () -> Void
    var isManualAddress: Bool

    init(
        mapModel: AddressMapModel,
        onSave: @escaping () -> Void = {},
        isManualAddress: Bool = false
    ) {
        self.mapModel = mapModel
        self.onSave = onSave
        self.isManualAddress = isManualAddress
    }

    var body: some View {
        VStack(alignment: .leading) {
            if isManualAddress {
                Text("Введите адрес")
                    .font(DSTypography.addressMapTitle)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
            } else {
                Text(mapModel.selectedAddress ?? "")
                    .font(DSTypography.addressMapTitle)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
            }
            VStack(alignment: .leading) {
                if isManualAddress {
                    Section(header: Text("Город").font(DSTypography.caption).foregroundStyle(.gray)) {
                        TextField("Город", text: $mapModel.city)
                    }
                    Divider()
                    Section(header: Text("Улица").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                        TextField("Улица", text: $mapModel.street)
                    }
                    Divider()
                }
                Section(header: Text("Квартира/офис").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, isManualAddress ? 24 : 0)) {
                    TextField("Квартира/офис", text: $mapModel.flat)
                }
                Divider()
                Section(header: Text("Подъезд").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                    TextField("Подъезд", text: $mapModel.entrance)
                }

                Divider()
                Section(header: Text("Этаж").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                    TextField("Этаж", text: $mapModel.floor)
                }
                Divider()
                Section(header: Text("Код домофона").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                    TextField("Код домофона", text: $mapModel.intercomCode)
                }
                Divider()
                Section(header: Text("Комментарий").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                    TextField("Комментарий", text: $mapModel.comment)
                }
                Divider()
                Spacer()
                DSButton(action: {
                    Task {
                        await mapModel.addAddress()
                    }
                    dismiss()
                    onSave()
                }, buttonTitle: "Сохранить")
            }
            .padding(.horizontal, 12)
        }
    }
}

#Preview {
    AddressSelectView(mapModel: AddressMapModel())
}
