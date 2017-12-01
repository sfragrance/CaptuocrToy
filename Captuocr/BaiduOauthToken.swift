//
//  BaiduOauthToken.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import EVReflection
import Foundation
class BaiduOauthToken: EVObject {
    var access_token: String?
}

class BaiduOauthError: EVObject {
    var error: String?
    var error_description: String?
}

class BaiduOcrResponse: EVObject {
    var log_id: Int = 0
    var words_result_num: Int = 0
    var words_result: [WordResult] = []
    var error_msg: String?
    var error_code: Int = 0
}

class WordResult: EVObject {
    var words: String = ""
}
