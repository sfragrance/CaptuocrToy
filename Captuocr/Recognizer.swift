//
//  Recognizer.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Foundation

protocol Recognizer {
    func recognize(picBase64: String) throws -> String
    func recognize(picBase64: String, progress: ((Double) -> Void)?) throws -> String
}
