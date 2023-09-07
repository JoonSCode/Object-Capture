//
//  CaptureResultView.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//

import SwiftUI
import RealityKit
import OSLog

struct ReconstructionView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    var savedFileURL: URL
    @State var shouldShowProgressView: Bool = false
    @State var reconstructionFinished: Bool = false
    @State var reconstructionProgress: Double = 0.0
    @State var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            if !reconstructionFinished {
                VStack {
                    ProgressView(value: reconstructionProgress)
                        .progressViewStyle(.automatic)
                    Text("\(reconstructionProgress)")
                }.padding()
                    .task {
                        await reconstruction()
                    }
            }
            
            else {
                NavigationLink(destination: ReconstructionResultView(url: savedFileURL)) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.blue)
                        Text("Go to Detail View")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
    }
    
    func reconstruction() async {
        var configuration = PhotogrammetrySession.Configuration()
        configuration.checkpointDirectory = appViewModel.directoryManager.snapshotsDirectoryURL
        
        guard let session = try? PhotogrammetrySession(input: appViewModel.directoryManager.imagesDirectoryURL,
                                                       configuration: configuration)
        else {
            return
        }
        appViewModel.photogrammetrySession = session
        shouldShowProgressView = true
        
        Task.detached {
            do {
                for try await output in session.outputs  {
                    switch output {
                    case .processingComplete:
                        await MainActor.run {
                            reconstructionFinished = true
                            shouldShowProgressView = false
                        }
                        os_log("[log]: RealityKit has processed all requests.")
                    case .requestError:
                        os_log("[log]: Request encountered an error.")
                    case .requestComplete:
                        os_log("[log]: RealityKit has finished processing a request.")
                    case .requestProgress(_, let fractionComplete):
                        await MainActor.run {
                            reconstructionProgress = fractionComplete
                        }
                        os_log("[log]: Periodic progress update \(fractionComplete). Update UI here.")
                    case .requestProgressInfo:
                        os_log("[log]: Periodic progress info update.")
                    case .inputComplete:
                        os_log("[log]: Ingestion of images is complete and processing begins.")
                    case .invalidSample:
                        os_log("[log]: RealityKit deemed a sample invalid and didn't use it.")
                    case .skippedSample:
                        os_log("[log]: RealityKit was unable to use a provided sample.")
                    case .automaticDownsampling:
                        os_log("[log]: RealityKit downsampled the input images because of resource constraints.")
                    case .processingCancelled:
                        os_log("[log]: Processing was canceled.")
                    case .stitchingIncomplete:
                        os_log("[log]: StitchingIncomplete")
                    @unknown default:
                        os_log("[log]: Unrecognized output.")
                    }
                }
            } catch {
                os_log(.error, "Output: ERROR = \(String(describing: error))")
                // Handle error.
            }
        }
        
        do {
            try session.process(requests: [
                PhotogrammetrySession.Request.modelFile(url: savedFileURL)
            ])
        } catch {
            errorMessage = error.localizedDescription
            os_log("[log] processFail: \(error.localizedDescription)")
            return
        }
    }
}
