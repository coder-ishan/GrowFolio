//
//  AccountView.swift
//  StableFolio
//
//  Created by Ishan Singh on 27/09/25.
//
import SwiftUI

struct AccountView: View {
    @StateObject private var auth = PayPalAuthController()
    @State private var showDeposit = false
    @State private var usdBalance: Decimal = 12500.42 // replace with real balance source

    var body: some View {
        NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    switch auth.state {
                    case .success:
                        ToolbarItem(placement: .principal) {
                            EmptyView()
                        }
                        
                    default:
                        ToolbarItem(placement: .principal) {
                            Text("Account")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                        }
                    }

                  
                    
                }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            auth.onAuthSuccess = { _ in /* optional side effects, e.g. fetch balances */ }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch auth.state {
        case .idle:
            LoginPrompt(login: auth.login)
        case .inProgress:
            ProgressView("Signing in…")
                .tint(.accentBlue)
                .padding()
                .background(Color.darkBackground.ignoresSafeArea())
        case .failure(let message):
            VStack(spacing: 16) {
                Text("Sign‑in failed: \(message)")
                    .foregroundColor(.textSecondary)
                Button("Try Again") { auth.login() }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.darkBackground.ignoresSafeArea())
        case .success(let user):
            SignedInContent(user: user,
                            usdBalance: usdBalance,
                            showDeposit: $showDeposit,
                            onLogout: auth.logout)
                .sheet(isPresented: $showDeposit) {
                    EmptyView()
                        .preferredColorScheme(.dark)
                }
        }
    }
}

private struct LoginPrompt: View {
    let login: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Manage profile and settings")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            Spacer()
            Button {
                login()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "p.circle.fill")
                        .font(.title2)
                    Text("Log in with PayPal")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.accentBlue))
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .background(Color.darkBackground.ignoresSafeArea())
        .navigationTitle("Account")
    }
}

private struct SignedInContent: View {
    let user: PayPalUser
    let usdBalance: Decimal
    @Binding var showDeposit: Bool
    let onLogout: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Account")
                        .font(.largeTitle.bold())
                        .foregroundColor(.textPrimary)
                    Text("Manage profile, balance and sessions")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 8)

                // Profile card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.accentBlue.opacity(0.2))
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.accentBlue)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name ?? "PayPal User")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            Text(user.email ?? "—")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )

                // Balance card
                VStack(alignment: .leading, spacing: 12) {
                    Text("USD Balance")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.textSecondary)
                    Text(usdBalance, format: .currency(code: "USD"))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )

                // Actions
                VStack(spacing: 12) {
                    Button {
                        showDeposit = true
                    } label: {
                        Text("Deposit")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.accentBlue))
                    }

                    Button {
                        // TODO: present withdraw flow
                    } label: {
                        Text("Withdraw")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                            )
                    }
                }

                // Session
                VStack(alignment: .leading, spacing: 8) {
                    Text("Session")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.textSecondary)

                    Button(role: .destructive) {
                        onLogout()
                    } label: {
                        Text("Log Out")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.red.opacity(0.12)))
                    }
                }
            }
            .padding(24)
        }
        .background(Color.darkBackground.ignoresSafeArea())
    }
}

// MARK: - Preview

#Preview {
    AccountView()
        .environmentObject(PayPalAuthController())
}
