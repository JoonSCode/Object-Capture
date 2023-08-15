//
//  AppViewModel.swift
//  ObjectCapture
//
//  Created by eden on 2023/08/15.
//

import Foundation
import RealityKit

final class AppViewModel: ObservableObject {
    var directoryManager: DirectoryManager!
    var photogrammetrySession: PhotogrammetrySession?
    
    func startNewCapture(mock: Bool = false) -> Bool {
        guard let newDirectoryManager = DirectoryManager(mock: mock) else { return false }
        directoryManager = newDirectoryManager
        return true
    }
}
