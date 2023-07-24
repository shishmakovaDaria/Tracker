//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 19.07.2023.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "3452aed3-8572-4c17-ac93-2718cd98baa8") else { return }
            
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func didTapTrackerOnMain() {
        report(event: "click", params: ["screen": "Main", "item": "track"])
    }
    
    func mainIsOpened() {
        report(event: "open", params: ["screen": "Main"])
    }
    
    func mainIsClosed() {
        report(event: "close", params: ["screen": "Main"])
    }
    
    func didTapFilterOnMain() {
        report(event: "click", params: ["screen": "Main", "item": "filter"])
    }
    
    func didTapEditOnMain() {
        report(event: "click", params: ["screen": "Main", "item": "edit"])
    }
    
    func didTapDeleteOnMain() {
        report(event: "click", params: ["screen": "Main", "item": "delete"])
    }
    
    func didTapAddTrackerOnMain() {
        report(event: "click", params: ["screen": "Main", "item": "add_track"])
    }
    
    private func report(event: String, params: [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
