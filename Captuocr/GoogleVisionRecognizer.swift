//
//  GoogleVisionRecognizer.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Alamofire
import Async
import Foundation

class GoogleVisionRecognizer: Recognizer {
    func recognize(picBase64: String, progress: ((Double) -> Void)? = nil) throws -> String {
        progress?(0)
        guard let setting = AppDelegate.container.resolve(Settings.self),
            setting.appearence.apitype == .googlevision,
            let googlesecret = setting.appearence.google_appsecret else {
            throw NSError(domain: "Inner exception", code: 0, userInfo: nil)
        }

        var error: NSError?
        var rtn: String?
        let group = AsyncGroup()
        group.enter()

        var urlRequest = try! URLRequest(
            url: URL(string: "https://vision.googleapis.com/v1/images:annotate?fields=responses%2FtextAnnotations%2Fdescription&key=\(googlesecret)")!,
            method: HTTPMethod.post)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let gvRequest = GoogleVisionReq(imgbase64: picBase64)

        let rq = Alamofire.upload(gvRequest.toJsonData(), to: urlRequest.url!, headers: urlRequest.allHTTPHeaderFields)
        rq.uploadProgress(queue: .global(qos: .background)) { p in
            progress?((0.6 * p.fractionCompleted).rounded(toPlaces: 3))
        }
        rq.responseString(
            queue: .global(qos: .background),
            encoding: .utf8) { response in
            guard let statuscode = response.response?.statusCode, let result = response.result.value else {
                group.leave()
                return
            }

            if statuscode == 200 {
                let ocrresponse = GoogleVisionResponse(json: result)
                rtn = ocrresponse
                    .responses
                    .flatMap({ $0.textAnnotations })
                    .first?
                    .descrip
            } else {
                let gve = GoogleVisionError(json: result)
                if let errordiscription = gve.message {
                    error = NSError(domain: errordiscription, code: 0, userInfo: nil)
                }
            }
            group.leave()
        }

        group.wait(seconds: 15)
        progress?(1)
        guard let final = rtn else {
            throw error ?? NSError(domain: "Ocr failed", code: 0, userInfo: nil)
        }
        return final
    }
}
