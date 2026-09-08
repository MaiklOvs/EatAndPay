//
//  UserProfileView.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 24.08.2026.
//

import SwiftUI
import DesignSystem

struct UserProfileView: View {

    let user: UserProfileViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var birthday: String = ""

    private var hasChanges: Bool {
        name != (user.userProfile?.name ?? "")
        || birthday != (user.userProfile?.birthday ?? "")
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Button {
                    dismiss()
                } label: {
                    Image(.backButton)
                }
                Spacer()
                Circle()
                    .fill(DSColors.lightGradient)
                    .frame(width: 88, height: 88)
                    .overlay(
                        Text(user.userProfile?.name.prefix(1) ?? "A")
                            .font(DSTypography.userName)
                    )
                Spacer()
                Menu {
                    Button {
                        Task {
                            await user.logoutUserProfile()
                        }
                    } label: {
                        Text("Выйти")
                            .foregroundStyle(.black)
                    }

                    Button(role: .destructive) {
                        Task {
                            await user.deleteUserProfile()
                        }
                    } label: {
                        Text("Удалить аккаунт")
                    }
                } label: {
                    Image(.settings)
                }

            }
            .padding(.horizontal, 12)
            .padding(.top, 19)
            Section(header: Text("Имя").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                TextField(user.userProfile?.name ?? "", text: $name)
                    .foregroundStyle(.black)
            }
            Divider()
            Section(header: Text("Телефон").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                HStack(spacing: 8) {
                    Image(.lock)
                        .foregroundStyle(.gray)
                    TextField(user.userProfile?.phone.asPhoneNumber ?? "", text: $phone)
                        .disabled(true)
                        .foregroundStyle(.gray)
                }
            }
            Divider()
            Section(header: Text("День рождения").font(DSTypography.caption).foregroundStyle(.gray).padding(.top, 24)) {
                TextField(user.userProfile?.birthday ?? "", text: $birthday)
                    .foregroundStyle(.black)
            }
            Divider()
            DSButton(
                action: {
                    Task {
                        await user.updateUserProfile(
                            name: name,
                            birthday: birthday
                        )
                        dismiss()
                    }
                },
                buttonTitle: "Сохранить изменения",
                isLoading: user.isLoading,
                disabled: !hasChanges
            )
            .animation(.easeInOut(duration: 0.2), value: hasChanges)
            Spacer()
        }
        .onAppear {
            name = user.userProfile?.name ?? ""
            phone = user.userProfile?.phone.asPhoneNumber ?? ""
            birthday = user.userProfile?.birthday ?? ""
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    UserProfileView(
        user: UserProfileViewModel(networkService: NetworkServicesImpl())
    )
}
