//
//  UserDefaults + shared.swift
//  InsulinNote
//
//  Created by 권희철 on 12/22/25.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.HeeCheol.InsulinNote"
        return UserDefaults(suiteName: appGroupId)!
    }
}
