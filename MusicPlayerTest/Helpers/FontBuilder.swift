//
//  FontBuilder.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI

struct FontBuilder {
    let font: Font
    //let tracking: Double
    let lineSpacing: Double
    let verticalPadding: Double

    init(
        customFont: CustomFonts,
        fontSize: Double,
        //letterSpacing: Double,
        lineHeight: Double
    ) {
        self.font = Font.custom(customFont, size: fontSize)
        //self.tracking = fontSize * letterSpacing

        let uiFont = UIFont(name: customFont.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize)
        self.lineSpacing = lineHeight - uiFont.lineHeight
        self.verticalPadding = lineSpacing / 2
    }
}
