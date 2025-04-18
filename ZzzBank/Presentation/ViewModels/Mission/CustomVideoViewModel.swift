//
//  CustomVideoViewModel.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/17/25.
//

import Foundation
import SRTParser

struct SubTitle {
    let start: TimeInterval
    let end: TimeInterval
    let text: String
}

final class CustomVideoViewModel {
    
    func getVideoURL() -> URL {
        return URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    }
    
    func loadSubTitles() -> [SubTitle] {
        var subtitles: [SubTitle] = []
        
        guard let path = Bundle.main.path(forResource: "BigBuckBunny", ofType: "srt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return []
        }
        
        do {
            let parser = SRTParser()
            let result = try parser.parse(content)
            
            for cue in result.cues {
                subtitles.append(SubTitle(start: convert(cue.metadata.timing.start), end: convert(cue.metadata.timing.end), text: cue.text.plainString))
            }
        } catch {
            print("자막 로딩 실패")
        }

        return subtitles
    }
    
    func subTitle(for time: TimeInterval, in subtitles: [SubTitle]) -> String? {
        for subtitle in subtitles {
            if subtitle.start <= time && time <= subtitle.end {
                return subtitle.text
            }
        }
        
        return nil
    }
    
    func convert(_ srtTime: SRT.Time) -> TimeInterval {
        let h = Double(srtTime.hours)
        let m = Double(srtTime.minutes)
        let s = Double(srtTime.seconds)
        let ms = Double(srtTime.milliseconds)
        return h * 3600 + m * 60 + s + ms / 1000
    }
}

extension SRT.StyledText {
    var plainString: String {
        return components.map { $0.flattenedText() }.joined()
    }
}

extension SRT.StyledText.Component {
    func flattenedText() -> String {
        switch self {
        case .plain(let text):
            return text
        case .bold(let children),
             .italic(let children),
             .underline(let children),
             .color(_, let children):
            return children.map { $0.flattenedText() }.joined()
        }
    }
}
