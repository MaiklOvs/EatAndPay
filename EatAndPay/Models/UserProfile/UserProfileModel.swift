//
//  UserProfileModel.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 24.08.2026.
//

import Foundation

@Observable
final class UserProfileViewModel {

    private let networkService: NetworkServices
    var userProfile: UserProfileModel?
    var isLoading: Bool

    init(networkService: NetworkServices, isLoading: Bool = false) {
        self.networkService = networkService
        self.isLoading = isLoading
    }

    func loadUserProfile() async {
        do {
            let profile = try await networkService.getUserProfile()
            userProfile = UserProfileModel(
                name: profile.name,
                phone: profile.phone,
                birthday: profile.birthday,
                imageUrl: profile.imageUrl
            )
        } catch {
            print("Failed to load user profile: \(error)")
        }
    }

    func updateUserProfile(name: String, birthday: String) async {
        defer { isLoading = false }
        do {
            isLoading = true
            let body = Operations.put_sol_users_sol_me.Input.Body.jsonPayload(
                name: name,
                birthday: birthday,
                imageUri: ""
            )

            let input = Operations.put_sol_users_sol_me.Input(body: .json(body))

            let _ = try await networkService.upadateUserProfile(input: input)
        } catch {
            print("Failed to update user profile: \(error)")
        }
    }

    func logoutUserProfile() async {
        do {
            let _ = try await networkService.logout()
        } catch {
            print("Failed to logout user profile: \(error)")
        }
    }

    func deleteUserProfile() async {
        do {
            let _ = try await networkService.deleteUserProfile()
        } catch {
            print("Failed to delete user profile: \(error)")
        }
    }
}

struct UserProfileModel: Equatable {
    let name: String
    let phone: String
    let birthday: String
    let imageUrl: String?
}
