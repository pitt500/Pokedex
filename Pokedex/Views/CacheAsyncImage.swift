//
//  CacheAsyncImage.swift
//  CacheAsyncImage
//
//  Created by Pedro Rojas on 13/08/21.
//

import SwiftUI

//var cache: [URL: Image] = [:]

struct CacheAsyncImage<Content>: View where Content: View {

    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    @AppStorage var cache: Data?

    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        _cache = AppStorage(url.absoluteString)
    }

    @ViewBuilder var body: some View {

        if let cached = cache {
            content(.success(cached.toImage()))
        } else {
            let _ = print("request \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        //This will modify the state during view updates
//        if case .success(let image) = phase {
//            cache[url] = image
//        }

        return content(phase)
            .onAppear {
                if case .success(let image) = phase {
                    cache = image.snapshot().pngData()
                }
            }
    }
}

struct CacheAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CacheAsyncImage(
            url: Pokemon.sample.url
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure(let error):
                ErrorView(error: error)
            @unknown default:
                fatalError()
            }
        }
    }
}

extension Image {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension Data {
    func toImage() -> Image {
        guard let uiImage = UIImage(data: self) else {
            return Image(systemName: "star")
        }

        return Image(uiImage: uiImage)
    }
}
