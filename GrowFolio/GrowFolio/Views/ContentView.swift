//
//  ContentView.swift
//  StableFolio
//
//  Created by Ishan Singh on 27/09/25.
//
// ContentView.swift

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authController: PayPalAuthController
    @State private var isAuthenticated: Bool = false

    var body: some View {
        ZStack {
            if isAuthenticated {
                MainTabs()
                    .tint(.blue)
            } else {
                LoginView()
                    .environmentObject(authController)
            }
        }
        .onReceive(authController.$state) { state in
            switch state {
            case .success(_):
                isAuthenticated = true
            default:
                isAuthenticated = false
            }
        }
        .onAppear {
            // Initialize view according to the current state (hot start)
            if case .success(_) = authController.state {
                isAuthenticated = true
            }
        }
    }
}

// Renamed to avoid confusion with SwiftUI.TabView
struct MainTabs: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)

            PortfolioView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.pie.fill" : "chart.pie")
                    Text("Portfolio")
                }
                .tag(1)

            AccountView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Account")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(PayPalAuthController())
}
