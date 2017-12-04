//
//  HistoryRecord.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import EVReflection
import Foundation
class HistoryRecord {
    var id = 0
    var updateAt: Date = Date()
    var type: HistoryType = .ocr
    var txt: String = ""
    var imgBase64: String = ""
}

enum HistoryType: Int {
    case ocr
    case qrcode
}
