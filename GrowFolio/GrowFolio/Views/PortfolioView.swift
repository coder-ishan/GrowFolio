//
//  PortfolioView.swift
//  StableFolio
//
//  Created by Ishan Singh on 27/09/25.
//

import SwiftUI

// MARK: - Portfolio View
struct PortfolioView: View {
    @State private var showingDepositSheet = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Track your investments and performance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                NavigationView {
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 32) {
                            // Header Section
                            BalanceView()
                                .padding(.top, 16)
                            
                            // Quick Actions
                            QuickActionsSection(showingSheet: $showingDepositSheet)
                                .padding(.top, 16)
                                .padding(.bottom, 32)
                                .padding(.leading, 16)
                          
                            Spacer(minLength: 120)
                        }
                        .padding(.horizontal, 24)
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .background(Color.darkBackground.ignoresSafeArea())
                    .preferredColorScheme(.dark)
                }
                
                Spacer()
                
                
               
                    
            }
            .sheet(isPresented: $showingDepositSheet) {
                EmptyView()
            }
            .navigationTitle("Portfolio")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}



// MARK: - Header Section
struct BalanceView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Top Navigation
         
            
            // Balance Card
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Balance")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        Text("$0.00")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("24h")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.textTertiary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12, weight: .semibold))
                            Text("$0.00")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.accentGreen)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }
}


// MARK: - Quick Actions Section
struct QuickActionsSection: View {
    @Binding var showingSheet: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Deposit Button
            Button(action: {
                showingSheet = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Deposit")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.accentBlue)
                )
            }
            
            // Withdraw Button
            Button(action: {}) {
                HStack(spacing: 12) {
                    Image(systemName: "minus")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Withdraw")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
            }
            
            Spacer()
        }
    }
}


#Preview{
    PortfolioView()
}
