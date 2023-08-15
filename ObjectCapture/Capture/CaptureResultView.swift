//
//  CaptureResultView.swift
//  ObjectCapture
//
//  Created by eden on 2023/08/15.
//

import SwiftUI
import RealityKit

struct CaptureResultView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    var session: ObjectCaptureSession
    
    @State var fileName: String = ""
    var savedFileURL: URL {
        appViewModel.directoryManager.scansDirectoryURL.appendingPathComponent(savedFileName)
    }
    private var savedFileName: String {
        return "\(UUID().uuidString)/\(fileName).usdz"
    }
    @State var showReconstruction: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ObjectCapturePointCloudView(session: session)
                    .frame(maxHeight: .infinity)
                
                VStack(alignment: .center, spacing: 10) {
                    Spacer()
                    HStack {
                        TextField(text: $fileName, label: {
                            Text("저장할 파일 이름을 입력해주세요.")
                        })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        Button {
                            if !fileName.isEmpty, !appViewModel.directoryManager.isFileExist(url: savedFileURL) {
                                showReconstruction = true
                            }
                        } label: {
                            Text("중복 확인")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    
                    if showReconstruction {
                        NavigationLink("reconstruction",
                                       destination: ReconstructionView(savedFileURL: savedFileURL)
                            .environmentObject(appViewModel))
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}
