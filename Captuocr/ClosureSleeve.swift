//
//  ClosureSleeve.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import AppKit
import Foundation
final class ClosureSleeve: NSObject {
    private let _closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        _closure = closure
        super.init()
    }

    @objc func invoke() {
        _closure()
    }
}

extension NSMenuItem {
    public func addAction(_ action: @escaping () -> Void) {
        let closure = ClosureSleeve(action)
        target = closure
        self.action = #selector(closure.invoke)
        objc_setAssociatedObject(self, UUID().uuidString, closure, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
