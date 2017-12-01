//
//  Utils.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Foundation
class Utils {
    static func capturePic() -> String? {
        let destinationPath = "/tmp/\(UUID().uuidString).png"
        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", "-r", destinationPath]
        task.launch()
        task.waitUntilExit()
        var notDir = ObjCBool(false)
        return FileManager.default.fileExists(atPath: destinationPath, isDirectory: &notDir)
            ? destinationPath
            : nil
    }
}
