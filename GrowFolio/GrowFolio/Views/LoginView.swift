//
//  LoginView.swift
//  StableFolio
//
//  Created by Ishan Singh on 27/09/25.
//

// LoginView.swift

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var controller: PayPalAuthController
    // If you prefer injection: use @ObservedObject var controller: PayPalAuthController

    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.trailing, 10)
                    
                Text("GrowFolio")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.blue)
                
                Text("Invest and Grow with Defi using PyUSD")
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                    .padding(.top)

                Spacer()
               
            }
            .padding(.top, 10)
           
            Button {
                controller.login()
            } label: {
                HStack {
                    Image(systemName: "p.circle")
                    Text("Continue with PayPal")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.9))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(controllerStateIsBusy)

            statusView
        }
        .padding()
    }

    private var controllerStateIsBusy: Bool {
        if case .inProgress = controller.state { return true }
        return false
    }

    @ViewBuilder
    private var statusView: some View {
        switch controller.state {
        case .idle:
            EmptyView()
        case .inProgress:
            ProgressView("Authorizing with PayPal…")
        case .success(let user):
            VStack(spacing: 8) {
                Text("Welcome, \(user.name ?? user.email ?? "PayPal user")")
                    .font(.headline)
                if let email = user.email {
                    Text(email).foregroundColor(.secondary)
                }
                if let v = user.verified {
                    Text(v ? "Email verified" : "Email not verified").foregroundColor(v ? .green : .orange)
                }
            }
        case .failure(let msg):
            Text("Login failed: \(msg)").foregroundColor(.red)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(PayPalAuthController())
}
