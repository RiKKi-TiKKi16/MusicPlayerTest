//
//  Font + .swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI

extension Font {
    static func custom(_ customFonts: CustomFonts, size: CGFloat) -> Font {
        Font.custom(customFonts.rawValue, size: size)
    }
}
