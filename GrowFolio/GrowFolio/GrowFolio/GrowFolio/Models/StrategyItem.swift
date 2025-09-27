//
//  StrategyItem.swift
//  GrowFolio
//
//  Created by Ishan Singh on 27/09/25.
//


import SwiftUI

// MARK: - Strategy Item Model
struct StrategyItem : Identifiable {
    var id: UUID = UUID()
    
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let description: String
}
