//
//  GoogleVisionResponse.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import EVReflection
import Foundation
class GoogleVisionResponse: EVObject {
    var responses: [GVRsp] = []
}

class GVRsp: EVObject {
    var textAnnotations: [GVTextAnnotation] = []
}

class GVTextAnnotation: EVObject {
    var descrip: String = ""
    override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return [(keyInObject: "descrip", keyInResource: "description")]
    }
}

class GoogleVisionError: EVObject {
    var code: Int = 0
    var message: String?
}
