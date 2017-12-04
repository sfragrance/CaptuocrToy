//
//  PreferenceGeneralView.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Cocoa

class PreferenceGeneralViewController: NSViewController {

    @IBOutlet var tfFontsize: NSTextField!
    @IBOutlet var stepperFontsize: NSStepper!
    @IBOutlet var checkShowInDock: NSButton!
    @IBOutlet var checkEnableQRcode: NSButton!
    @IBOutlet weak var labelNextTime: NSTextField!
    let viewmodel = PreferenceGeneralViewModel()
    var setting: Settings!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setting = AppDelegate.container.resolve(Settings.self)!

        bindViewmodel()
        initialize()
    }
}
