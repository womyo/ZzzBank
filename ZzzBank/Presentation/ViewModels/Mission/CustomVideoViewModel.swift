//
//  CustomVideoViewModel.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/17/25.
//

import Foundation

final class CustomVideoViewModel {
    func getVideoURL() -> URL {
        return URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    }
}
