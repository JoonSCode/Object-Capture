//
//  ContentView.swift
//  ObjectCapture
//
//  Created by eden on 2023/08/15.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    var forMock: Bool = false
    
    var body: some View {
        if forMock {
            MockResultView()
                .environmentObject(appViewModel)
        } else {
            CapturePrimaryView()
                .environmentObject(appViewModel)
        }
    }
}
