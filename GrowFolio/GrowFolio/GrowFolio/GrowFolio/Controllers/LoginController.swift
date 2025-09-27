//
//  LoginController.swift
//  GrowFolio
//
//  Created by Ishan Singh on 27/09/25.
//

import Foundation
import AuthenticationServices
import Combine
import UIKit



final class PayPalAuthController: NSObject, ObservableObject {
    @Published private(set) var state: AuthState = .idle

    private var session: ASWebAuthenticationSession?
    private var expectedState: String?
    private var expectedNonce: String?

    // Sandbox example; switch to live endpoints/creds for production
    private let clientId = "AfwGYvvUm8E8SXaL9XTGBcAmj3SGJFecrZrHma19wzCYuZ8HE8Jf1t6KXDo7yk4_ebiMD2XsBcyWHQiI"
    private let redirectScheme = "growfolio"
    private let redirectURI = "growfolio://paypal-auth"
    private let authorizeBase = "https://www.sandbox.paypal.com/signin/authorize"
    // Note: Token/UserInfo endpoints are on api-m.sandbox.paypal.com for sandbox.

    var onAuthSuccess: ((PayPalUser) -> Void)?

    func login() {
        DispatchQueue.main.async { self.state = .inProgress }

        // Generate and store CSRF and replay protections
        let nonce = UUID().uuidString
        let stateVal = UUID().uuidString
        self.expectedNonce = nonce
        self.expectedState = stateVal

        guard var comps = URLComponents(string: authorizeBase) else {
            DispatchQueue.main.async { self.state = .failure("Invalid authorize URL") }
            return
        }
        comps.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: "openid email profile"),
            URLQueryItem(name: "nonce", value: nonce),
            URLQueryItem(name: "state", value: stateVal)
        ]
        guard let authURL = comps.url else {
            DispatchQueue.main.async { self.state = .failure("Failed to compose authorize URL") }
            return
        }

        let session = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: redirectScheme
        ) { [weak self] callbackURL, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async { self.state = .failure("Auth canceled: \(error.localizedDescription)") }
                return
            }
            guard let callbackURL = callbackURL,
                  let code = Self.extractQueryItem("code", from: callbackURL),
                  let returnedState = Self.extractQueryItem("state", from: callbackURL) else {
                DispatchQueue.main.async { self.state = .failure("Missing auth code") }
                return
            }
            // Verify state
            guard returnedState == self.expectedState else {
                DispatchQueue.main.async { self.state = .failure("State mismatch") }
                return
            }

            // Exchange code for tokens (prefer backend)
            self.exchangeCodeAndFetchUser(code: code) { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.state = .success(user)
                        self.onAuthSuccess?(user)
                    }
                case .failure(let err):
                    DispatchQueue.main.async {
                        self.state = .failure(err.localizedDescription)
                    }
                }
            }
        }
        session.prefersEphemeralWebBrowserSession = true
        session.presentationContextProvider = self
        self.session = session
        _ = session.start()
    }
    
    func logout() {
            // Optionally: call a backend to revoke tokens, then reset local state
            DispatchQueue.main.async {
                self.session = nil
                self.onAuthSuccess = nil
                self.state = .idle
            }
        }

    private func exchangeCodeAndFetchUser(code: String, completion: @escaping (Result<PayPalUser, Error>) -> Void) {
        //Demo used secrets in code , actual implementation will use a backend
        exchangeDirectlyForSandbox(code: code) { result in
            switch result {
            case .success(let accessToken):
                self.fetchUserInfo(accessToken: accessToken, completion: completion)
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    // MARK: - SANDBOX-ONLY: direct exchange in app (don’t do this in production)
    // Requires a client secret; do NOT ship secrets in apps. Use only for local testing.
    private let sandboxTokenURL = URL(string: "https://api-m.sandbox.paypal.com/v1/oauth2/token")!
    private let sandboxUserInfoURL = URL(string: "https://api-m.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=openid")!
    private let clientSecret: String? = "EPi2PxdpcwzsvpoedukkKSwZjZg2wjODhPx_z_KI61RCMkKcJOQeJykYqqgZjFA_h54_GzgjPURaQ0Cw"

    private func exchangeDirectlyForSandbox(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let clientSecret = clientSecret else {
            completion(.failure(NSError(domain: "auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "No clientSecret in app; use backend for token exchange."])))
            return
        }
        var req = URLRequest(url: sandboxTokenURL)
        req.httpMethod = "POST"
        let body = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI
        ].formURLEncoded()
        req.httpBody = body.data(using: .utf8)
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basic = Data("\(clientId):\(clientSecret)".utf8).base64EncodedString()
        req.setValue("Basic \(basic)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(err)); return }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["access_token"] as? String else {
                completion(.failure(NSError(domain: "auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token exchange failed"])))
                return
            }
            completion(.success(token))
        }.resume()
    }

    private func fetchUserInfo(accessToken: String, completion: @escaping (Result<PayPalUser, Error>) -> Void) {
        var req = URLRequest(url: sandboxUserInfoURL)
        req.httpMethod = "GET"
        req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(err)); return }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(.failure(NSError(domain: "userinfo", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty user info"])))
                return
            }

            // PayPal OpenID-style fields vary; map the common ones safely
            let id = (json["user_id"] as? String) ?? (json["sub"] as? String) ?? "unknown"
            let email = json["email"] as? String
            let name = json["name"] as? String ?? {
                let given = json["given_name"] as? String
                let family = json["family_name"] as? String
                return [given, family].compactMap{$0}.joined(separator: " ").nilIfEmpty
            }()
            let verified = (json["verified"] as? Bool) ?? (json["email_verified"] as? Bool)
            let user = PayPalUser(
                name: name,
                email: email,
                userId: id,
                verified: verified
            )
            completion(.success(user))
        }.resume()
    }

    private static func extractQueryItem(_ name: String, from url: URL) -> String? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == name })?
            .value
    }
}

extension PayPalAuthController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

// MARK: - Helpers
private extension Dictionary where Key == String, Value == String {
    func formURLEncoded() -> String {
        self.map { key, val in
            let k = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            let v = val.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? val
            return "\(k)=\(v)"
        }
        .joined(separator: "&")
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
