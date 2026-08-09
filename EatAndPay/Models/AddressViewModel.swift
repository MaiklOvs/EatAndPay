//
//  AddressViewModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 03.08.2026.
//

import Foundation

@Observable
final class AddressModel {

    private let networkService: NetworkServices

    var addressViewModel: [AddressViewModel]?
    var selectedAddress: AddressViewModel?

    init(networkService: NetworkServices) {
        self.networkService = networkService
    }

    func loadAddress() async {
        do {
            addressViewModel = try await networkService.loadAddress()
            if selectedAddress == nil, let first = addressViewModel?.first {
                selectedAddress = first
            }
        } catch {
            print("Failed to load address: \(error)")
        }
    }

    func deleteAddress(id: String) async {
        let input = Operations.delete_sol_addresses_sol__lcub_id_rcub_.Input(path: .init(id: id))
        do {
            _ = try await networkService.deleteAddress(input: input)
            await loadAddress()
        } catch {
            print("Failed to delete address: \(error)")
        }
    }
}

struct AddressViewModel: Codable, Identifiable, Hashable {
    let coordinates: [Double]
    let addressLine: String
    let floor: String?
    let entrance: String?
    let intercomCode: String?
    let comment: String?
    let id: String
}
