//
//  ReconstructionListViews.swift
//  ObjectCapture
//
//  Created by eden on 2023/08/27.
//

import SwiftUI

struct ReconstructionListView: View {
    var body: some View {
        LazyVStack {
            ForEach(DirectoryManager.fileList(), id: \.self) { url in
                NavigationLink(destination: ReconstructionResultView(url: url)) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.blue)
                        Text(url.deletingPathExtension().lastPathComponent)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }.onAppear()
    }
}

#Preview {
    ReconstructionListView()
}
