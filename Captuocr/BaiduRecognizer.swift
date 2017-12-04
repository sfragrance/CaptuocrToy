//
//  BaiduRecognizer.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Alamofire
import Async
import Foundation

class BaiduRecognizer: Recognizer {
    func recognize(picBase64: String, progress: ((Double) -> Void)? = nil) throws -> String {
        progress?(0)
        guard let setting = AppDelegate.container.resolve(Settings.self), setting.appearence.apitype == .baiduocr else {
            throw NSError(domain: "Inner exception", code: 0, userInfo: nil)
        }

        var error: NSError?
        if setting.baiduocr_access_token == nil {
            let group = AsyncGroup()
            group.enter()
            Alamofire.request("https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=\(setting.appearence.baidu_appkey!)&client_secret=\(setting.appearence.baidu_appsecret!)", method: .post).responseString(queue: .global(qos: .background)) { response in
                guard let statuscode = response.response?.statusCode, let result = response.result.value else {
                    group.leave()
                    return
                }

                if statuscode == 200 {
                    let oauthmodel = BaiduOauthToken(json: result)
                    setting.baiduocr_access_token = oauthmodel.access_token
                } else {
                    let oauth = BaiduOauthError(json: result)
                    if let errordiscription = oauth.error_description {
                        error = NSError(domain: errordiscription, code: 0, userInfo: nil)
                    }
                }

                group.leave()
            }

            group.wait(seconds: 15)
        }
        progress?(0.2)
        guard let accesstoken = setting.baiduocr_access_token else {
            throw error ?? NSError(domain: "Oauth failed", code: 0, userInfo: nil)
        }

        var rtn: String?
        let group = AsyncGroup()
        group.enter()

        let urlRequest = try! URLRequest(url: URL(string: "https://aip.baidubce.com/rest/2.0/ocr/v1/general?access_token=\(accesstoken)")!, method: HTTPMethod.post)
        let encodedURLRequest = try? URLEncoding.default.encode(urlRequest, with: ["image": picBase64])
        let data = encodedURLRequest?.httpBody!

        let rq = Alamofire.upload(data!, to: urlRequest.url!)
        rq.uploadProgress(queue: .global(qos: .background)) { p in
            progress?(0.2 + (0.6 * p.fractionCompleted).rounded(toPlaces: 3))
        }
        rq.responseString(
            queue: .global(qos: .background),
            encoding: .utf8) { response in
            guard let statuscode = response.response?.statusCode, let result = response.result.value else {
                group.leave()
                return
            }

            if statuscode == 200 {
                let ocrresponse = BaiduOcrResponse(json: result)
                if ocrresponse.error_code > 0 {
                    if let errordiscription = ocrresponse.error_msg {
                        error = NSError(domain: errordiscription, code: 0, userInfo: nil)
                    }
                } else {
                    rtn = ocrresponse.words_result.map { $0.words.trimmingCharacters(in: .whitespaces) }.joined(separator: "\n")
                }
            } else {
                let oauth = BaiduOauthError(json: result)
                if let errordiscription = oauth.error_description {
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
