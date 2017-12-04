//
//  Appearence.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import EVReflection
import Foundation
class Appearence: EVObject {
    var apitype: ApiType
    var baidu_appid: String?
    var baidu_appkey: String?
    var baidu_appsecret: String?
    var google_appsecret: String?
    var isKeyGlobal = false
    var fontsize :Double = 13
    var showInDock = false
    var enableQrcode = false
    required init() {
        apitype = .baiduocr
        baidu_appid = "10438145"
        baidu_appkey = "N7GWF63CRc2RM8iYHih6GBjZ"
        baidu_appsecret = "McqgCdBOprgOjdiysA7U18FTouX1iwDz"
    }

    var valid: Bool {
        return (apitype == .baiduocr && baidu_appid != nil && baidu_appkey != nil && baidu_appsecret != nil)
            || (apitype == .googlevision && google_appsecret != nil)
    }

    override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> Void), encodeConverter: (() -> Any?))] {
        return [(
            key: "apitype",
            decodeConverter: { self.apitype =
                ($0 as? Int) == ApiType.googlevision.rawValue
                ? .googlevision
                : .baiduocr },
            encodeConverter: { self.apitype.rawValue })]
    }
}

enum ApiType: Int {
    case baiduocr
    case googlevision
}
