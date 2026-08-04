//
//  AddressMapModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 04.08.2026.
//

import Foundation
import MapKit

@Observable
final class AddressMapModel {
    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var selectedCoordinate: CLLocationCoordinate2D?
    var selectedAddress: String?
}
