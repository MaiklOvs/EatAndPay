//
//  AddressMapModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 04.08.2026.
//

import MapKit
import SwiftUI
import Foundation

@Observable
final class AddressMapModel {
    var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))

    var selectedCoordinate: CLLocationCoordinate2D?
    var selectedAddress: String?

    var flat: String = ""
    var floor: String = ""
    var entrance: String = ""
    var intercomCode: String = ""
    var comment: String = ""

    private let networkService: NetworkServices

    init(networkService: NetworkServices = NetworkServicesImpl()) {
        self.networkService = networkService
    }

    func addAddress() async {
        guard let addressLine = selectedAddress,
              let coordinate = selectedCoordinate else {
            print("Address or coordinate is missing")
            return
        }

        let body = Components.Schemas.Address(
            coordinates: [coordinate.longitude, coordinate.latitude],
            addressLine: addressLine,
            floor: flat.isEmpty ? nil : flat,
            entrance: entrance.isEmpty ? nil : entrance,
            intercomCode: intercomCode.isEmpty ? nil : intercomCode,
            comment: comment.isEmpty ? nil : comment
        )

        let input = Operations.post_sol_addresses.Input(body: .json(body))

        do {
            try await networkService.addAddress(input: input)
            print("Address added successfully")
        } catch {
            print("Failed to add address: \(error)")
        }
    }
}
