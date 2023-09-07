//
//  RoundRectangleButton.swift
//  ObjectCapture
//
//  Created by eden on 2023/08/27.
//

import SwiftUI

struct RoundRectangleButton<Content: View>: View {
    
    let action: () -> Void
    let label: () -> Content
    
    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.action = action
        self.label = label
    }
    
    init(action: @escaping () -> Void, title: String) where Content == Text {
        
        self.init(action: action, label: { Text(title) })
    }

    var body: some View {
        label().onTapGesture { action() }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(.white))
    }
    
}

#Preview {
    RoundRectangleButton(action: {}, title: "asdasd")
}
