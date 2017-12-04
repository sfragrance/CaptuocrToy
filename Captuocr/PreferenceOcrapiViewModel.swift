//
//  PreferenceOcrapiViewModel.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Foundation
import ReactiveKit
class PreferenceOcrapiViewModel {
    var type = Property<ApiType>(.baiduocr)
    var baiduAppId = Property<String>("")
    var baiduAppKey = Property<String>("")
    var baiduAppSecret = Property<String>("")
    var googleAppSecret = Property<String>("")
}

extension PreferenceOcrapiViewController {
    func bindViewmodel() {
        viewmodel.type.observeNext { t in
            if t == .baiduocr {
                self.radioBaidu.state = NSControl.StateValue.on
                self.tfBaiduAppid.isEnabled = true
                self.tfAppKey.isEnabled = true
                self.tfAppSecret.isEnabled = true
                self.tfGoogleSecret.isEnabled = false
            } else {
                self.radioGoogle.state = NSControl.StateValue.on
                self.tfBaiduAppid.isEnabled = false
                self.tfAppKey.isEnabled = false
                self.tfAppSecret.isEnabled = false
                self.tfGoogleSecret.isEnabled = true
            }
        }.dispose(in: radioBaidu.bag)

        radioBaidu.reactive.controlEvent.observeNext { _ in
            self.viewmodel.type.value = .baiduocr
        }.dispose(in: radioBaidu.bag)

        radioGoogle.reactive.controlEvent.observeNext { _ in
            self.viewmodel.type.value = .googlevision
        }.dispose(in: radioGoogle.bag)

        viewmodel.baiduAppId.bidirectionalBind(to: tfBaiduAppid.reactive.editingString)
        viewmodel.baiduAppKey.bidirectionalBind(to: tfAppKey.reactive.editingString)
        viewmodel.baiduAppSecret.bidirectionalBind(to: tfAppSecret.reactive.editingString)
        viewmodel.googleAppSecret.bidirectionalBind(to: tfGoogleSecret.reactive.editingString)

        btnRestore.reactive.controlEvent.observeNext { _ in
            self.initialize()
        }.dispose(in: btnRestore.bag)

        btnOk.reactive.controlEvent.observeNext { _ in
            self.setting.appearence.apitype = self.viewmodel.type.value
            self.setting.appearence.baidu_appid = self.viewmodel.baiduAppId.value
            self.setting.appearence.baidu_appkey = self.viewmodel.baiduAppKey.value
            self.setting.appearence.baidu_appsecret = self.viewmodel.baiduAppSecret.value
            self.setting.appearence.google_appsecret = self.viewmodel.googleAppSecret.value
            self.setting.baiduocr_access_token = nil
            self.setting.save()
            AppDelegate.container.resolve(PreferenceWindowController.self)?.close()
        }.dispose(in: btnOk.bag)

        btnGetBaiduApi.reactive.controlEvent.observeNext { _ in
            NSWorkspace.shared.open(NSURL(string: "https://console.bce.baidu.com/ai/#/ai/ocr/overview/index")! as URL)
        }.dispose(in: btnGetBaiduApi.bag)

        btnGetGoogleApi.reactive.controlEvent.observeNext { _ in
            NSWorkspace.shared.open(NSURL(string: "https://console.cloud.google.com/apis/api/vision.googleapis.com/")! as URL)
        }.dispose(in: btnGetGoogleApi.bag)
    }

    func initialize() {
        viewmodel.type.value = setting.appearence.apitype
        viewmodel.baiduAppId.value = setting.appearence.baidu_appid ?? ""
        viewmodel.baiduAppKey.value = setting.appearence.baidu_appkey ?? ""
        viewmodel.baiduAppSecret.value = setting.appearence.baidu_appsecret ?? ""
        viewmodel.googleAppSecret.value = setting.appearence.google_appsecret ?? ""
    }
}
