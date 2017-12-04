//
//  GoogleVisionRequest.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import EVReflection
import Foundation

class GoogleVisionReq: EVObject {
    var requests: [GVRequest] = []
    required init() {
    }

    init(imgbase64: String) {
        let gvRequest = GVRequest()
        gvRequest.image = GVRequestImage()
        gvRequest.image?.content = imgbase64
        requests = [gvRequest]
    }
}

class GVRequest: EVObject {
    var image: GVRequestImage?
    var features: [GVRequestFeature] = [GVRequestFeature()]
}

class GVRequestImage: EVObject {
    var content: String = ""
}

class GVRequestFeature: EVObject {
    var type: String = "DOCUMENT_TEXT_DETECTION"
}
