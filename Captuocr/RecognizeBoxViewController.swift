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
    @IBOutlet var imgHeight: NSLayoutConstraint!
    @IBOutlet var imgWidth: NSLayoutConstraint!
    let viewmodel: RecognizeBoxViewModel = RecognizeBoxViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.reactive.keyPath("frame", ofExpectedType: NSRect.self, context: .immediateOnMain)
            .observeNext {
                self.imgWidth.constant = $0.width * (398 / 844)
                self.imgHeight.constant = $0.height * (475 / 499)
            }
            .dispose(in: view.bag)

        bindViewModel()
    }
}
