//
//  ImageLoader.swift
//  EatAndPay
//
//  Created by Ovsyannikov.M10 on 14.08.2026.
//

import Foundation
import SwiftUI
import CryptoKit

actor ImageLoader {

    static let shared = ImageLoader()

    private let memoryCache = NSCache<NSString, UIImage>()
    private var inProgressTasks: [String: Task<Data, Error>] = [:]
    private let fileManager = FileManager.default

    private var cacheDirectory: URL {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("ImageCache", isDirectory: true)
    }

    private func prepareCacheDirectory() {
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(
                at: cacheDirectory,
                withIntermediateDirectories: true
            )
        }
    }

    private func fileURL(for urlString: String) -> URL? {
        guard let data = urlString.data(using: .utf8) else { return nil }
        let hash = SHA256.hash(data: data)
        let filename = hash.compactMap { String(format: "%02x", $0) }.joined()
        return cacheDirectory.appendingPathComponent(filename)
    }

    private func removeTask(for urlString: String) {
        inProgressTasks.removeValue(forKey: urlString)
    }

    func loadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }

        if let cache = memoryCache.object(forKey: urlString as NSString) {
            return cache
        }

        prepareCacheDirectory()

        if let fileURL = fileURL(for: urlString),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: urlString as NSString)
            return image
        }

        let task: Task<Data, Error> = {
            if let existing = inProgressTasks[urlString] {
                return existing
            }
            let task = Task<Data, Error> {
                return try await URLSession.shared.data(from: url).0
            }
            inProgressTasks[url.absoluteString] = task
            return task
        }()

        do {
            let data = try await task.value
            removeTask(for: urlString)
            guard let image = UIImage(data: data) else { return nil }
            memoryCache.setObject(image, forKey: urlString as NSString)
            if let fileURL = fileURL(for: urlString) {
                try? data.write(to: fileURL)
            }
            return image
        } catch {
            removeTask(for: urlString)
            return nil
        }
    }
}
