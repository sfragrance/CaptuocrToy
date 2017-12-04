//
//  RecognizeBoxViewModel.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit
class RecognizeBoxViewModel {
    var recognizedText = Property<String>("")
    var image = Property<String>("")
}

extension RecognizeBoxViewController {
    func bindViewModel() {
        combineLatest(viewmodel.recognizedText, viewmodel.image).observeNext { (_) in
            self.performFontSize()
        }.dispose(in: imageArea.reactive.bag)
        viewmodel.recognizedText.bind(to: textArea.reactive.string).dispose(in: layout.bag)
        viewmodel.image.map { (base64) -> NSImage? in
            if let data = Data(base64Encoded: base64, options: Data.Base64DecodingOptions(rawValue: 0)) {
                return NSImage(data: data)
            }
            return nil
        }.bind(to: imageArea.reactive.image)
    }
    
    func performFontSize()  {
        if let setting = AppDelegate.container.resolve(Settings.self) {
            textArea.font = NSFont.userFont(ofSize: CGFloat(setting.appearence.fontsize))
        }
    }
}
