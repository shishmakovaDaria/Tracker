//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 19.07.2023.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    
    func report(event: String, params: [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
