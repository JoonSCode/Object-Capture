
//
//  CapturePrimaryView.swift
//
//  Created by eden on 2023/08/15.
//
import RealityKit
import SwiftUI
import OSLog

@MainActor
struct CapturePrimaryView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State var session: ObjectCaptureSession = .init()
    @State var sessionCanStart: Bool = false
    
    var body: some View {
        if !sessionCanStart {
            VStack {
                Spacer()
                RoundRectangleButton {
                    if appViewModel.startNewCapture() {
                        sessionCanStart = true
                    }
                } label: {
                    Text("start new Capture")
                        .foregroundStyle(.black)
                }
                Spacer()
            }
            .onAppear(perform: {
                 if appViewModel.startNewCapture() {
                    sessionCanStart = true
                }
            })
        }
        else if session.userCompletedScanPass {
            CaptureResultView(session: session)
                .environmentObject(appViewModel)
        }
        else {
            ZStack {
                ObjectCaptureView(session: session)
                switch session.state {
                case .initializing:
                    EmptyView()
                    
                case .ready:
                    VStack {
                        Text("Ready")
                            .foregroundStyle(.black)
                        Spacer()
                        RoundRectangleButton {
                            session.startDetecting()
                        } label: {
                            Text("Start Detecting")
                                .foregroundStyle(.black)
                        }
                    }
                    
                case .detecting:
                    VStack {
                        Text("Detecting")
                            .foregroundStyle(.black)
                        Spacer()
                        HStack {
                            RoundRectangleButton {
                                session.resetDetection()
                            } label: {
                                Text("Reset")
                                    .foregroundStyle(.black)
                            }
                            RoundRectangleButton {
                                session.startCapturing()
                            } label: {
                                Text("Start Capturing")
                                    .foregroundStyle(.black)
                            }
                        }.padding()
                    }
                    
                case .capturing:
                    VStack {
                        Text("capture")
                            .foregroundStyle(.black)
                        Spacer()
                        if session.canRequestImageCapture {
                            RoundRectangleButton {
                                session.requestImageCapture()
                            } label: {
                                Text("requestImageCapture")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                case .finishing:
                    Text("Finishing")
                    
                case .completed:
                    Text("completed")
                    //사용자가 object 정보를 저장하는 view가 present
                    
                case .failed(let error):
                    CapturePrimaryView()
                    
                @unknown default:
                    Text("unknown default")
                }
            }
            .onAppear(perform: {
                var configuration = ObjectCaptureSession.Configuration()
                configuration.checkpointDirectory = appViewModel.directoryManager.snapshotsDirectoryURL
                configuration.isOverCaptureEnabled = true
                session.start(imagesDirectory: appViewModel.directoryManager.imagesDirectoryURL, configuration: configuration)
            })
        }
    }
}
