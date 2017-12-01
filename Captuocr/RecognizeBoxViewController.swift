//
//  RecognizeBox.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Bond
import Cocoa
import ReactiveKit

class RecognizeBoxViewController: NSViewController {

    @IBOutlet var layout: NSView!
    @IBOutlet var vLine: NSBox!
    @IBOutlet var vLineCenter: NSLayoutConstraint!
    @IBOutlet var imageArea: NSImageView!
    @IBOutlet var textArea: NSTextView!
    let viewmodel: RecognizeBoxViewModel = RecognizeBoxViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        bindViewModel()
    }
}
