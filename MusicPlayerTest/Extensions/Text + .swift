//
//  Text + .swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI

extension Text {
    func font(_ customFonts: CustomFonts, size: CGFloat) -> Text {
        self.font(Font.custom(customFonts, size: size))
    }
}
