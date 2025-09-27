//
//  LendingItem.swift
//  GrowFolio
//
//  Created by Ishan Singh on 27/09/25.
//
import SwiftUI

struct LendingItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let apy: String
    let available: String
    let `protocol`: String
    let color: Color
    let icon: String
}
