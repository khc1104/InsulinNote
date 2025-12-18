//
//  ErrorManager.swift
//  InsulinNote
//
//  Created by 권희철 on 12/2/25.
//

import SwiftUI
import Observation


@Observable
final class ErrorManager {
    var error: ModelError? = nil
    
    var isAlertError: Bool {
        guard let error = error else { return false }
        switch error {
        case .updateDataError: return true
        default: return false
        }
    }
    
    var isCriticalError: Bool {
        guard let error = error else { return false }
        switch error {
        case .fetchRecordError,
                .fetchSettingError,
                .createInitSettingError,
                .unknwonedError:
            return true
        default: return false
        }
    }
    
    func showError(_ error: ModelError) {
        Task{ @MainActor in
            self.error = error
            print(error)
        }
    }
}
