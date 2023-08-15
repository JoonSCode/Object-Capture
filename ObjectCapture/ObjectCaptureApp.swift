//
//  ObjectCaptureApp.swift
//  ObjectCapture
//
//  Created by eden on 2023/08/15.
//

import SwiftUI

@main
struct ObjectCaptureApp: App {
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
}
