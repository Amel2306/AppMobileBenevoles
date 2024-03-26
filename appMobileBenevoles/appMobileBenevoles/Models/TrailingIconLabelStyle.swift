//
//  TrailingIconLabelStyle.swift
//  appMobileBenevoles
//
//  Created by Amel  on 26/03/2024.
//

import Foundation
import SwiftUI


struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}


extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
