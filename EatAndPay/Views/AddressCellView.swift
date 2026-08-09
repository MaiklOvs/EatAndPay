//
//  AddressCellView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 04.08.2026.
//

import SwiftUI
import DesignSystem

struct AddressCell: View {

    let address: AddressViewModel
    let addressModel: AddressModel
    let isSelected: Bool

    @State private var isAddressEditPresenter = false

    init(
        address: AddressViewModel,
        addressModel: AddressModel,
        isSelected: Bool
    ){
        self.address = address
        self.addressModel = addressModel
        self.isSelected = isSelected
    }

    var attributedText: AttributedString {
        var result = AttributedString(address.addressLine + "\n")
        result.font = DSTypography.addressTitle

        var subtitle = AttributedString(detailsString)
        subtitle.font = DSTypography.caption
        subtitle.foregroundColor = DSColors.textSecondary

        result.append(subtitle)
        return result
    }

    private var detailsString: String {
        "\(address.floor ?? "") этаж, \(address.entrance ?? "") подъезд, код домофона \(address.intercomCode ?? "")"
    }

    var body: some View {
        HStack {
            Text(attributedText)
                .padding(.horizontal, 12)
            Spacer()
            Button {
                isAddressEditPresenter = true
            } label: {
                Image(.pencil)
                    .padding(.bottom, 26)
                    .padding(.trailing, 20)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? DSColors.lightGradient : .linearGradient(colors: [.white], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(12)
        .padding(.horizontal, 12)
        .sheet(isPresented: $isAddressEditPresenter) {
            NavigationStack {
                AddressSelectView(
                    mode: .edit(address),
                    addressModel: addressModel,
                    onSave: {
                        Task {
                            await addressModel.loadAddress()
                        }
                    }
                )
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    AddressCell(
        address: AddressViewModel(
            coordinates: [37.6173, 55.7558],
            addressLine: "Новая Басманная ул., 35 ст1, 59\n",
            floor: "3",
            entrance: "4",
            intercomCode: "15809",
            comment: nil,
            id: "preview-id"
        ),
        addressModel: AddressModel(networkService: NetworkServicesImpl()),
        isSelected: true
    )
}
