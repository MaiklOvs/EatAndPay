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
    @State private var isSelectAddressPresented = false
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
                    mapModel.selectedAddress = mapItem.address?.fullAddress ?? "Address not available"
                }
            } catch {
                print("Reverse geocoding failed: \(error)")
                await MainActor.run {
                    mapModel.selectedAddress = "Failed to get address"
                }
            }
        }
    }

    private func zoomIn() {
        guard var region = mapModel.cameraPosition.region else { return }
        region.span.latitudeDelta *= 0.5
        region.span.longitudeDelta *= 0.5
        mapModel.cameraPosition = .region(region)
    }

    private func zoomOut() {
        guard var region = mapModel.cameraPosition.region else { return }
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
        mapModel.cameraPosition = .region(region)
    }

    private func moveToUserLocation() {
        Task {
            let manager = CLLocationManager()
            manager.requestWhenInUseAuthorization()

            guard let location = manager.location else {
                print("User location not available")
                return
            }

            let coordinate = location.coordinate
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )

            await MainActor.run {
                mapModel.cameraPosition = .region(region)
                reverseGeocode(coordinate)
            }
        }
    }

    var body: some View {
        ZStack {
            Map(position: $mapModel.cameraPosition)
                .mapStyle(.standard(elevation: .flat))
                .onMapCameraChange { context in
                    mapModel.cameraPosition = .region(context.region)
                    mapModel.selectedCoordinate = context.region.center
                    reverseGeocode(context.region.center)
                }
                .overlay { 
                    CloseMapButton(action: { dismiss() })
                        .padding(.leading, 323)
                        .padding(.top, 50)
                        .padding(.bottom, 800)
                    PlusMapButton(action: { zoomIn() })
                        .padding(.leading, 323)
                        .padding(.top, 143)
                        .padding(.bottom, 600)
                    MinusMapButton(action: { zoomOut() })
                        .padding(.leading, 323)
                        .padding(.top, 240)
                        .padding(.bottom, 600)
                    LocationMapButton(action: { moveToUserLocation() })
                        .padding(.leading, 323)
                        .padding(.top, 240)
                        .padding(.bottom, 500)
                }
            DSMapPin()
        }
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(mapModel.selectedAddress ?? "")
                    .font(DSTypography.addressMapTitle)
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                HStack {
                    DSButton(
                        action: {},
                        buttonTitle: "Ввести другой",
                        style: .inputAddress
                    )
                    .frame(height: 50)
                    DSButton(
                        action: { isSelectAddressPresented = true },
                        buttonTitle: "Выбрать адрес"
                    )
                    .frame(height: 50)
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
        .sheet(isPresented: $isSelectAddressPresented) {
            AddressSelectView(mapModel: mapModel)
        }
    }
}

#Preview {
    AddressMapView()
}
