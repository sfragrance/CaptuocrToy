//
//  HistoryCell.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Cocoa
import Foundation
class HistoryCell: NSTableCellView {
    static let name = "HistoryCell"
    @IBOutlet var tfMain: NSTextField!
    @IBOutlet var tfAt: NSTextField!
    @IBOutlet var img: NSImageView!
    var _type: HistoryType?
    var type: HistoryType? {
        get {
            return _type
        }
        set {
            _type = newValue
            img.image = _type == HistoryType.qrcode ? NSImage(named: NSImage.Name("icons8-qr-code-50")) : NSImage(named: NSImage.Name("icons8-ocr-50"))
        }
    }
}
