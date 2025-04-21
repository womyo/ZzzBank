//
//  AVPlayer+Extensions.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/21/25.
//

import AVFoundation

extension AVPlayer{ // 영상이 현재 진행중인지 판단하는 부분
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
