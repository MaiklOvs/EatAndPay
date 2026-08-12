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

    var city: String = ""
    var street: String = ""
    var flat: String = ""
    var floor: String = ""
    var entrance: String = ""
    var intercomCode: String = ""
    var comment: String = ""

    private let networkService: NetworkServices

    init(networkService: NetworkServices = NetworkServicesImpl()) {
        self.networkService = networkService
    }

    private func addressLineWithoutFlat(_ addressLine: String) -> String {
        let components = addressLine.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard components.count > 1 else { return addressLine }
        return components.dropLast().joined(separator: ", ")
    }

    func geocodeAddress() async -> CLLocationCoordinate2D? {
        let addressString = "\(city) \(street)"
        guard !city.isEmpty, !street.isEmpty else {
            print("City or street is missing")
            return nil
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = addressString
        request.resultTypes = .address

        do {
            let response = try await MKLocalSearch(request: request).start()
            guard let item = response.mapItems.first else {
                print("No coordinates found for address")
                return nil
            }
            return item.placemark.coordinate
        } catch {
            print("Geocoding failed: \(error)")
            return nil
        }
    }

    func addAddress() async -> Bool {
        let addressLine: String
        let coordinate: CLLocationCoordinate2D

        if let selectedAddress = selectedAddress, let selectedCoordinate = selectedCoordinate {
            let baseAddress = flat.isEmpty ? selectedAddress : addressLineWithoutFlat(selectedAddress)
            addressLine = baseAddress + (flat.isEmpty ? "" : ", \(flat)")
            coordinate = selectedCoordinate
        } else if !city.isEmpty, !street.isEmpty {
            addressLine = "\(city), \(street)"
            guard let geocodedCoordinate = await geocodeAddress() else {
                print("Failed to geocode manual address")
                return false
            }
            coordinate = geocodedCoordinate
        } else {
            print("Address or coordinate is missing")
            return false
        }

        let body = Components.Schemas.Address(
            coordinates: [coordinate.longitude, coordinate.latitude],
            addressLine: addressLine,
            floor: floor.isEmpty ? nil : floor,
            entrance: entrance.isEmpty ? nil : entrance,
            intercomCode: intercomCode.isEmpty ? nil : intercomCode,
            comment: comment.isEmpty ? nil : comment
        )

        let input = Operations.post_sol_addresses.Input(body: .json(body))

        do {
            let _ = try await networkService.addAddress(input: input)
            return true
        } catch {
            return false
        }
    }

    func updateAddress(id: String) async -> Bool {
        let addressLine: String
        let coordinate: CLLocationCoordinate2D

        if let selectedAddress = selectedAddress, let selectedCoordinate = selectedCoordinate {
            let baseAddress = flat.isEmpty ? selectedAddress : addressLineWithoutFlat(selectedAddress)
            addressLine = baseAddress + (flat.isEmpty ? "" : ", \(flat)")
            coordinate = selectedCoordinate
        } else if !city.isEmpty, !street.isEmpty {
            addressLine = "\(city), \(street)"
            guard let geocodedCoordinate = await geocodeAddress() else {
                return false
            }
            coordinate = geocodedCoordinate
        } else {
            return false
        }

        let body = Components.Schemas.Address(
            coordinates: [coordinate.longitude, coordinate.latitude],
            addressLine: addressLine,
            floor: floor.isEmpty ? nil : floor,
            entrance: entrance.isEmpty ? nil : entrance,
            intercomCode: intercomCode.isEmpty ? nil : intercomCode,
            comment: comment.isEmpty ? nil : comment
        )

        let input = Operations.put_sol_addresses_sol__lcub_id_rcub_.Input(
            path: .init(id: id),
            body: .json(body)
        )

        do {
            let _ = try await networkService.updateAddress(input: input)
            return true
        } catch {
            return false
        }
    }
}
