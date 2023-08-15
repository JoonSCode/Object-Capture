//
//  DirectoryManager.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//

import Foundation

final class DirectoryManager: ObservableObject {
    var scansDirectoryURL: URL
    var timeStampDirectoryURL: URL
    var imagesDirectoryURL: URL
    var snapshotsDirectoryURL: URL
    
    init?(mock: Bool = false) {
        let rootDirectory = DirectoryManager.getDocumentsDirectory()
        guard let scansURL = DirectoryManager.createDirectoryIfNotExists(at: rootDirectory) else { return nil }
        
        self.scansDirectoryURL = scansURL
        
        if mock {
            let fileManager = FileManager.default
            // 디렉토리 내의 파일 목록을 가져옵니다.
            do {
                let files = try fileManager.contentsOfDirectory(at: scansDirectoryURL, includingPropertiesForKeys: nil)
                timeStampDirectoryURL = files[0]
                imagesDirectoryURL = timeStampDirectoryURL.appendingPathComponent("Images")
                snapshotsDirectoryURL = timeStampDirectoryURL.appendingPathComponent("Snapshots")
            } catch {
                return nil
            }
        } else {
            
            let timeStamp = Int(Date().timeIntervalSince1970)
            let timeStampDirectory = scansURL.appendingPathComponent("\(timeStamp)")
            guard let timeStampURL = DirectoryManager.createDirectoryIfNotExists(at: timeStampDirectory) else { return nil }
            
            let imagesDirectory = timeStampURL.appendingPathComponent("Images")
            guard let imagesURL = DirectoryManager.createDirectoryIfNotExists(at: imagesDirectory) else { return nil }
            
            let snapshotsDirectory = timeStampURL.appendingPathComponent("Snapshots")
            guard let snapshotsURL = DirectoryManager.createDirectoryIfNotExists(at: snapshotsDirectory) else { return nil }
            
            self.timeStampDirectoryURL = timeStampURL
            self.imagesDirectoryURL = imagesURL
            self.snapshotsDirectoryURL = snapshotsURL
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Scans")
    }
    
    private static func createDirectoryIfNotExists(at url: URL) -> URL? {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("\(url.lastPathComponent) 디렉토리가 성공적으로 생성되었습니다.")
                return url
            } catch {
                print("\(url.lastPathComponent) 디렉토리를 생성하는 데 오류가 발생했습니다: \(error)")
                return nil
            }
        }
        return url
    }
    
    static func printFiles(in url: URL) {
        do {
            let fileManager = FileManager.default
            
            // 디렉토리 내의 파일 목록을 가져옵니다.
            let files = try fileManager.contentsOfDirectory(atPath: url.path)
            
            // 파일 목록을 출력합니다.
            for file in files {
                print("File: \(file)")
            }
        } catch {
            print("파일 목록을 가져오는 데 오류가 발생했습니다: \(error)")
        }
    }
    
    func isFileExist(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.absoluteString)
    }
}
