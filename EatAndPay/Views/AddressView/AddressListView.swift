//
//  AddressListView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.08.2026.
//

import SwiftUI
import DesignSystem

struct AddressListView: View {

    @State private var addressModel: AddressModel
    @Environment(\.dismiss) private var dismiss
    @State private var isAddressMapPresenter = false

    init(addressModel: AddressModel) {
        self.addressModel = addressModel
    }

    func getDetailsString(
        floor: String?,
        entrance: String?,
        intercomCode: String?
    ) -> String {
        return "\(floor ?? "") этаж, \(entrance ?? "") подъезд, код домофона \(intercomCode ?? "")"
    }

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
                ForEach(addressModel.addressViewModel ?? []) { address in
                    Button {
                        addressModel.selectedAddress = address
                    } label: {
                        AddressCell(
                            address: address,
                            addressModel: addressModel,
                            isSelected: address.id == addressModel.selectedAddress?.id
                        )
                    }
                    .buttonStyle(.plain)
                }

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
                    AddressMapView(
                        onSave: {
                            Task {
                                await addressModel.loadAddress()
                            }
                        },
                        addressModel: addressModel
                    )
                }
            }
        }
        Spacer()
        DSButton(
            action: { dismiss() },
            buttonTitle: "Привезти сюда"
        )
        .padding(.horizontal, 12)
        .task {
            await addressModel.loadAddress()
        }
    }
}

#Preview {
    AddressListView(addressModel: AddressModel(networkService: NetworkServicesImpl()))
}
