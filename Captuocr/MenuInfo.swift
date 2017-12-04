//
//  MenuInfo.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Foundation
struct MenuInfo {
    var is_separator: Bool
    var title: String
    var key: String?
    var selector: String
    init(_ anyObj: NSDictionary?) throws {
        guard
            let anyObj = anyObj,
            let is_separator = anyObj["is_separator"] as? Bool,
            let title = anyObj["title"] as? String,
            let selector = anyObj["selector"] as? String else {
            throw NSError()
        }
        self.is_separator = is_separator
        self.title = title
        key = anyObj["key"] as? String
        self.selector = selector
    }
}
