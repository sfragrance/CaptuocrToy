//
//  PreferenceGeneralViewModel.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit
class PreferenceGeneralViewModel {
    var fontSize = Property<Double>(15)
    var showInDock = Property<Bool>(false)
    var enableQrcode = Property<Bool>(false)
}

extension PreferenceGeneralViewController {
    func bindViewmodel() {
        viewmodel.showInDock
            .map { $0 ? NSControl.StateValue.on : NSControl.StateValue.off }
            .bind(to: checkShowInDock.reactive.state)
            .dispose(in: checkShowInDock.reactive.bag)
        checkShowInDock.reactive.controlEvent.observeNext { _ in
            self.viewmodel.showInDock.value = !self.viewmodel.showInDock.value
            self.labelNextTime.isHidden = self.setting.appearence.showInDock
            self.setting.appearence.showInDock = self.viewmodel.showInDock.value
            self.setting.save()
        }.dispose(in: checkShowInDock.reactive.bag)
        viewmodel.showInDock.observeNext { v in
            if v {
                var psn: ProcessSerialNumber = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
                TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
            } /*else {
                TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToUIElementApplication))
            }*/
        }.dispose(in: checkShowInDock.reactive.bag)
        viewmodel.fontSize.map{"\($0)"}.bind(to: tfFontsize.reactive.stringValue).dispose(in: self.tfFontsize.bag)
        stepperFontsize.reactive.controlEvent.observeNext { (_) in
            self.viewmodel.fontSize.value = self.stepperFontsize.doubleValue
            self.setting.appearence.fontsize = self.viewmodel.fontSize.value
            self.setting.save()
        }.dispose(in: self.stepperFontsize.reactive.bag)
    }

    func initialize() {
        viewmodel.fontSize.value = setting.appearence.fontsize
        stepperFontsize.doubleValue = setting.appearence.fontsize
        viewmodel.showInDock.value = setting.appearence.showInDock
        viewmodel.enableQrcode.value = setting.appearence.enableQrcode
    }
}
