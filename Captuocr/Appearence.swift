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
}

enum ApiType {
    case baiduocr
    case googlevision
}
