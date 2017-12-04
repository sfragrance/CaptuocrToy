//
//  PreferenceOcrapiView.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Cocoa

class PreferenceOcrapiViewController: NSViewController {
    @IBOutlet var radioBaidu: NSButton!
    @IBOutlet var radioGoogle: NSButton!
    @IBOutlet var tfBaiduAppid: NSTextField!
    @IBOutlet var tfAppKey: NSTextField!
    @IBOutlet var tfAppSecret: NSTextField!
    @IBOutlet var tfGoogleSecret: NSTextField!
    @IBOutlet var btnRestore: NSButton!
    @IBOutlet var btnOk: NSButton!
    @IBOutlet var btnGetBaiduApi: NSButton!
    @IBOutlet var btnGetGoogleApi: NSButton!
    let viewmodel = PreferenceOcrapiViewModel()
    var setting: Settings!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setting = AppDelegate.container.resolve(Settings.self)!

        bindViewmodel()
        initialize()
    }
}
