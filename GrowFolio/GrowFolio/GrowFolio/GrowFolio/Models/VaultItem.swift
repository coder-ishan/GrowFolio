//
//  VaultItem.swift
//  GrowFolio
//
//  Created by Ishan Singh on 27/09/25.
//

import SwiftUI

// MARK: - Data Models
struct VaultItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let apy: String
    let tvl: String
    let risk: String
    let color: Color
    let icon: String
}
