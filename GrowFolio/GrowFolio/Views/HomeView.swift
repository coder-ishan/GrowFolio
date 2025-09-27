//
//  ContentView.swift
//  StableFolio
//
//  Created by Ishan Singh on 27/09/25.
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Header
                    HeaderView()

                    // Vaults Section
                    VaultsSection()
                    
                    // Lending/Borrowing Section
                    LendingBorrowingSection()

                    // Trending Strategies
                    TrendingSection()

                    // Market Strategies
                    MarketStrategiesSection()

                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
                
            }
            .navigationBarHidden(true)
            .background(Color.darkBackground.ignoresSafeArea())
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
                
            Text("GrowFolio")
                .font(.system(size: 32, weight: .bold, design: .default))
                .foregroundColor(.white)

            Spacer()
           
        }
        .padding(.top, 10)
    }
}

// MARK: - Vaults Section
struct VaultsSection: View {
    let vaults = [
        VaultItem(
            title: "sPyUSD Auto Vault",
            subtitle: "Auto-compounding",
            apy: "15.2%",
            tvl: "$2.4M",
            risk: "Low",
            color: .accentPurple,
            icon: "lock.shield.fill"
        ),
        VaultItem(
            title: "USDC Yield Vault",
            subtitle: "Stable returns",
            apy: "8.7%",
            tvl: "$5.1M",
            risk: "Very Low",
            color: .accentBlue,
            icon: "dollarsign.circle.fill"
        ),
        VaultItem(
            title: "Multi-Asset Vault",
            subtitle: "Diversified",
            apy: "12.3%",
            tvl: "$1.8M",
            risk: "Medium",
            color: .accentGreen,
            icon: "chart.pie.fill"
        ),
        VaultItem(
            title: "ETH Staking Vault",
            subtitle: "ETH 2.0 rewards",
            apy: "5.4%",
            tvl: "$8.2M",
            risk: "Low",
            color: .accentOrange,
            icon: "triangle.fill"
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HorizontalSectionHeader(title: "Vaults", actionText: "View More")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vaults) { vault in
                        NavigationLink(destination: VaultDetailView(vault: vault)) {
                            HorizontalVaultCard(vault: vault)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

// MARK: - Lending/Borrowing Section
struct LendingBorrowingSection: View {
    let lendingOptions = [
        LendingItem(
            title: "USDC Lending",
            subtitle: "Compound Protocol",
            apy: "6.8%",
            available: "$1.2M",
            protocol: "Compound",
            color: .accentGreen,
            icon: "arrow.up.circle.fill"
        ),
        LendingItem(
            title: "USDT Borrowing",
            subtitle: "Aave Protocol",
            apy: "4.2%",
            available: "$850K",
            protocol: "Aave",
            color: .accentOrange,
            icon: "arrow.down.circle.fill"
        ),
        LendingItem(
            title: "DAI Lending",
            subtitle: "MakerDAO",
            apy: "7.1%",
            available: "$2.1M",
            protocol: "MakerDAO",
            color: .accentPurple,
            icon: "arrow.up.circle.fill"
        ),
        LendingItem(
            title: "ETH Borrowing",
            subtitle: "Compound Protocol",
            apy: "3.9%",
            available: "$3.4M",
            protocol: "Compound",
            color: .accentBlue,
            icon: "arrow.down.circle.fill"
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HorizontalSectionHeader(title: "Lending & Borrowing", actionText: "View More")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(lendingOptions) { lending in
                        NavigationLink(destination: LendingDetailView(lending: lending)) {
                            HorizontalLendingCard(lending: lending)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

// MARK: - Horizontal Section Header
struct HorizontalSectionHeader: View {
    let title: String
    let actionText: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)

            Spacer()

            Button(action: {
                // Handle view more action
                print("View more tapped for \(title)")
            }) {
                Text(actionText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.accentPurple)
            }
        }
    }
}

// MARK: - Horizontal Vault Card
struct HorizontalVaultCard: View {
    let vault: VaultItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with icon and risk
            HStack {
                Circle()
                    .fill(vault.color.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: vault.icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(vault.color)
                    )

                Spacer()

                Text(vault.risk)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.textTertiary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.06))
                    )
            }

            // Title and subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(vault.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)

                Text(vault.subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }

            // Stats
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("APY")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textTertiary)
                    Spacer()
                    Text(vault.apy)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.accentGreen)
                }

                HStack {
                    Text("TVL")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textTertiary)
                    Spacer()
                    Text(vault.tvl)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(16)
        .frame(width: 200, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .contentShape(Rectangle())
    }
}

// MARK: - Horizontal Lending Card
struct HorizontalLendingCard: View {
    let lending: LendingItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with icon and protocol
            HStack {
                Circle()
                    .fill(lending.color.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: lending.icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(lending.color)
                    )

                Spacer()

                Text(lending.protocol)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.textTertiary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.06))
                    )
            }

            // Title and subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(lending.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)

                Text(lending.subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }

            // Stats
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Rate")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textTertiary)
                    Spacer()
                    Text(lending.apy)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(lending.color)
                }

                HStack {
                    Text("Available")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textTertiary)
                    Spacer()
                    Text(lending.available)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(16)
        .frame(width: 200, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .contentShape(Rectangle())
    }
}





// MARK: - Detail Views
struct VaultDetailView: View {
    let vault: VaultItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Circle()
                        .fill(vault.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: vault.icon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(vault.color)
                        )

                    Text(vault.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text(vault.subtitle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                }

                // Vault Statistics
                VStack(alignment: .leading, spacing: 16) {
                    Text("Vault Performance")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)

                    VStack(spacing: 12) {
                        StatRow(title: "Current APY", value: vault.apy, color: .green)
                        StatRow(title: "Total Value Locked", value: vault.tvl, color: .blue)
                        StatRow(title: "Risk Level", value: vault.risk, color: .orange)
                        StatRow(title: "Min Deposit", value: "$100", color: .purple)
                    }
                }

                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(vault.title)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.darkBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

struct LendingDetailView: View {
    let lending: LendingItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Circle()
                        .fill(lending.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: lending.icon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(lending.color)
                        )

                    Text(lending.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text(lending.subtitle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                }

                // Lending Statistics
                VStack(alignment: .leading, spacing: 16) {
                    Text("Lending Details")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)

                    VStack(spacing: 12) {
                        StatRow(title: "Interest Rate", value: lending.apy, color: lending.color)
                        StatRow(title: "Available", value: lending.available, color: .blue)
                        StatRow(title: "Protocol", value: lending.protocol, color: .purple)
                        StatRow(title: "Min Amount", value: "$50", color: .orange)
                    }
                }

                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(lending.title)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.darkBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

// MARK: - Existing Code (TrendingSection, MarketStrategiesSection, etc.)
struct TrendingSection: View {
    let strategies = [
        StrategyItem(
            title: "sPyUSD Vault",
            subtitle: "Automated yield",
            icon: "lock.shield.fill",
            color: .accentPurple,
            description: "Set and forget optimization"
        ),
        StrategyItem(
            title: "BTC",
            subtitle: "Token holdings",
            icon: "bitcoinsign.circle.fill",
            color: .accentOrange,
            description: "Hold and manage tokens"
        ),
        StrategyItem(
            title: "Aave",
            subtitle: "Credit protocols",
            icon: "arrow.left.arrow.right.circle.fill",
            color: .accentGreen,
            description: "Earn by lending funds"
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Trending Strategies")

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(strategies) { strategy in
                    NavigationLink(destination: StrategyDetailView(strategy: strategy)) {
                        CompactStrategyCard(strategy: strategy)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Market Strategies Section
struct MarketStrategiesSection: View {
    let strategies = [
        StrategyItem(
            title: "Staking",
            subtitle: "Network rewards",
            icon: "chart.line.uptrend.xyaxis",
            color: .accentBlue,
            description: "Stake for rewards"
        ),
        StrategyItem(
            title: "Liquidity",
            subtitle: "Pool rewards",
            icon: "drop.fill",
            color: .purple,
            description: "Provide liquidity"
        ),
        StrategyItem(
            title: "Trading",
            subtitle: "Active trading",
            icon: "chart.bar.fill",
            color: .pink,
            description: "Manual trading"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "All Strategies")

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(strategies) { strategy in
                    NavigationLink(destination: StrategyDetailView(strategy: strategy)) {
                        CompactStrategyCard(strategy: strategy)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)

            Spacer()
        }
    }
}

// MARK: - Compact Strategy Card
struct CompactStrategyCard: View {
    let strategy: StrategyItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Icon and arrow
            HStack {
                Circle()
                    .fill(strategy.color.opacity(0.2))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: strategy.icon)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(strategy.color)
                    )

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.textTertiary)
            }

            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(strategy.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Text(strategy.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)

                Text(strategy.description)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.textTertiary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
        .contentShape(Rectangle())
    }
}

// MARK: - Strategy Detail View (Dummy View)
struct StrategyDetailView: View {
    let strategy: StrategyItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Circle()
                        .fill(strategy.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: strategy.icon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(strategy.color)
                        )

                    Text(strategy.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text(strategy.subtitle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                }

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("About \(strategy.title)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text(strategy.description)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                }

                // Dummy Statistics
                VStack(alignment: .leading, spacing: 16) {
                    Text("Performance")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)

                    VStack(spacing: 12) {
                        StatRow(title: "Current APY", value: "12.5%", color: .green)
                        StatRow(title: "Total Value Locked", value: "$2.4M", color: .blue)
                        StatRow(title: "Risk Level", value: "Medium", color: .orange)
                        StatRow(title: "Min Investment", value: "$100", color: .purple)
                    }
                }

                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        // Dummy action
                        print("Invest tapped for \(strategy.title)")
                    }) {
                        Text("Start Investing")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(strategy.color)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        // Dummy action
                        print("Learn more tapped for \(strategy.title)")
                    }) {
                        Text("Learn More")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(strategy.color)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(strategy.color.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(strategy.color.opacity(0.3), lineWidth: 1)
                            )
                    }
                }

                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(strategy.title)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.darkBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

// MARK: - Stat Row
struct StatRow: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
