//
//  SizePreferenceKey.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/31/24.
//

import SwiftUI

struct SizePreferenceKey:PreferenceKey{
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
