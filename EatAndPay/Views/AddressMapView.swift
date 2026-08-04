//
//  AddressMapView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 04.08.2026.
//

import SwiftUI
@preconcurrency import MapKit
import DesignSystem

struct AddressMapView: View {

    @State private var mapModel = AddressMapModel()
    @Environment(\.dismiss) private var dismiss

    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

                guard let request = MKReverseGeocodingRequest(location: location) else {
                    print("Invalid location provided.")
                    return
                }

                let mapItems = try await request.mapItems

                guard let mapItem = mapItems.first else {
                    print("No address found for this location.")
                    return
                }

                await MainActor.run {
                    mapModel.selectedAddress = mapItem.address?.description ?? "Address not available"
                }

            } catch {
                print("Reverse geocoding failed: \(error)")
                await MainActor.run {
                    mapModel.selectedAddress = "Failed to get address"
                }
            }
        }
    }

    var body: some View {
        ZStack {
            Map(initialPosition: MapCameraPosition.region(mapModel.region))
                .mapStyle(.standard(elevation: .flat))
                .onMapCameraChange { context in
                    mapModel.region = context.region
                }
                .overlay(alignment: .top) {
                    CloseMapButton(action: { dismiss() })
                        .padding(.leading, 323)
                        .padding(.leading, 12)
                        .padding(.top, 19)
                }
            DSMapPin()
        }
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("Новая Басманная ул., 35 ст1")
                    .font(DSTypography.addressMapTitle)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                HStack {
                    DSButton(
                        action: {},
                        buttonTitle: "Ввести другой",
                        style: .inputAddress
                    )
                    DSButton(
                        action: {},
                        buttonTitle: "Выбрать адрес"
                    )
                }
                .padding(.horizontal, 12)
                .padding(.top, 24)
                .padding(.bottom, 64)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 20,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 20
                )
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AddressMapView()
}
