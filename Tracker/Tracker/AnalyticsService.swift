//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Глеб Хамин on 21.09.2024.
//

import Foundation
import AppMetricaCore

enum Event: String {
    case open, close, click
}

enum Screen: String {
    case Main, Creation, Category
}

enum Item: String {
    case addTrack = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}

struct AnalyticsService {
    
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "0d3abbe8-9c5c-476d-81b3-d27385bc7484") else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    func sendEvent(event: Event, screen: Screen, item: Item?) {
        var params: [AnyHashable: Any] = ["screen": screen.rawValue]
        if let item {
            params["item"] = item.rawValue
        }
        AppMetrica.reportEvent(name: event.rawValue, parameters: params)
    }
    
}
