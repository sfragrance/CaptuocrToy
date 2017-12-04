//
//  Recognizer.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Alamofire
import EVReflection
import Foundation

class Settings {
    let appearence: Appearence
    /// life circle with app
    var baiduocr_access_token: String?
    init() {
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Captuocr", isDirectory: true)
            .appendingPathComponent("Appearence.json")
        let appearencejson = try? String(contentsOf: path)
        var _appearence = Appearence(json: appearencejson)
        if !_appearence.valid {
            _appearence = Appearence()
        }

        appearence = _appearence
    }

    func save() {
        var path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Captuocr", isDirectory: true)
        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        path = path.appendingPathComponent("Appearence.json")
        let appearenceJson = appearence.toJsonString()
        try? appearenceJson.write(to: path, atomically: true, encoding: .utf8)
    }
}
