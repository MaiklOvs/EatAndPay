//
//  AddressSelectView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 05.08.2026.
//

import SwiftUI
import DesignSystem

struct AddressSelectView: View {

    enum Mode {
        case create(AddressMapModel)
        case edit(AddressViewModel)
    }

    let mode: Mode

    @State private var city: String = ""
    @State private var street: String = ""
    @State private var flat: String = ""
    @State private var floor: String = ""
    @State private var entrance: String = ""
    @State private var intercomCode: String = ""
    @State private var comment: String = ""
    @State private var isMapPresented = false

    @Environment(\.dismiss) private var dismiss
    var addressModel: AddressModel
    var onSave: () -> Void
    var isManualAddress: Bool

    init(
        mode: Mode,
        addressModel: AddressModel,
        onSave: @escaping () -> Void = {},
        isManualAddress: Bool = false
    ) {
        self.mode = mode
        self.addressModel = addressModel
        self.onSave = onSave
        self.isManualAddress = isManualAddress
    }

    private var title: String {
        switch mode {
        case .create(let mapModel):
            return mapModel.selectedAddress ?? ""
        case .edit(let address):
            return address.addressLine
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                if isManualAddress {
                    Text("Введите адрес")
                        .font(DSTypography.addressMapTitle)
                        .padding(.horizontal, 12)
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                } else {
                    Text(title)
                        .font(DSTypography.addressMapTitle)
                        .padding(.horizontal, 12)
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                }
                VStack(alignment: .leading) {
                    if isManualAddress {
                        Section(header: Text("Город").font(DSTypography.caption).foregroundStyle(.gray)) {
                            TextField("Город", text: $city)
                        }
                        Divider()
                        Section(header: Text("Улица").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                            TextField("Улица", text: $street)
                        }
                        Divider()
                    }
                    Section(header: Text("Квартира/офис").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, isManualAddress ? 24 : 0)) {
                        TextField("Квартира/офис", text: $flat)
                    }
                    Divider()
                    Section(header: Text("Подъезд").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                        TextField("Подъезд", text: $entrance)
                    }

                    Divider()
                    Section(header: Text("Этаж").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                        TextField("Этаж", text: $floor)
                    }
                    Divider()
                    Section(header: Text("Код домофона").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                        TextField("Код домофона", text: $intercomCode)
                    }
                    Divider()
                    Section(header: Text("Комментарий").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                        TextField("Комментарий", text: $comment)
                    }
                    Divider()
                    Spacer()
                    DSButton(action: {
                        switch mode {
                        case .create(let mapModel):
                            mapModel.city = city
                            mapModel.street = street
                            mapModel.flat = flat
                            mapModel.floor = floor
                            mapModel.entrance = entrance
                            mapModel.intercomCode = intercomCode
                            mapModel.comment = comment
                            Task {
                                await mapModel.addAddress()
                            }
                        case .edit:
                            break
                        }
                        dismiss()
                        onSave()
                    }, buttonTitle: "Сохранить")
                }
                .padding(.horizontal, 12)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(.backButton)
                }
            }
            ToolbarItem(placement: .principal) {
                if case .edit = mode {
                    SelectMapAddressButton(onTap: {
                        isMapPresented = true
                    })
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if case .edit(let address) = mode {
                    DeleteAddressButton(action: {
                        Task {
                            await addressModel.deleteAddress(id: address.id)
                        }
                        dismiss()
                        onSave()
                    })
                } else {
                    EmptyView()
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $isMapPresented) {
            AddressMapView(onSave: {
                Task {
                    await addressModel.loadAddress()
                }
                onSave()
            })
        }
        .onAppear {
            switch mode {
            case .create(let mapModel):
                city = mapModel.city
                street = mapModel.street
                flat = mapModel.flat
                floor = mapModel.floor
                entrance = mapModel.entrance
                intercomCode = mapModel.intercomCode
                comment = mapModel.comment
            case .edit(let address):
                flat = ""
                floor = address.floor ?? ""
                entrance = address.entrance ?? ""
                intercomCode = address.intercomCode ?? ""
                comment = address.comment ?? ""
            }
        }
    }
}

#Preview {
    AddressSelectView(
        mode: .edit(AddressViewModel(coordinates: [], addressLine: "", floor: "", entrance: "", intercomCode: "", comment: "", id: "")),
        addressModel: AddressModel(networkService: NetworkServicesImpl())
    )
}
