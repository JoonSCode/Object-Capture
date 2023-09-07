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
    var forPrint = false
    var body: some View {
        if forPrint {
            VStack {
                RoundRectangleButton(action: {
                    DirectoryManager.printFiles(in: DirectoryManager.getDocumentsDirectory())
                }, title: "폴더구조 Print")
                
                RoundRectangleButton(action: {
                    let files = DirectoryManager.fileList(in: DirectoryManager.getDocumentsDirectory())
                    DirectoryManager.printFiles(in: files[0])
                }, title: "TimeStamp 폴더 Print")
                
                RoundRectangleButton(action: {
                    let files = DirectoryManager.fileList(in: DirectoryManager.getDocumentsDirectory())
                    DirectoryManager.printFiles(in: files[0].appendingPathComponent("Images"))
                }, title: "Images 폴더 Print")
                
                RoundRectangleButton(action: {
                    let files = DirectoryManager.fileList(in: DirectoryManager.getDocumentsDirectory())
                    DirectoryManager.printFiles(in: files[0].appendingPathComponent("Snapshots"))
                }, title: "Snapshots 폴더 Print")
            }
        } else {
            NavigationView {
                VStack {
                    NavigationLink(destination:  MockResultView()
                        .environmentObject(appViewModel)) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Go to Mock Result View")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    
                    NavigationLink(destination: ReconstructionListView()) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.blue)
                            Text("Go to Object List")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: CapturePrimaryView()
                        .environmentObject(appViewModel)) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Go to Capture View")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                }
            }
        }
    }
}
