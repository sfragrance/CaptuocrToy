//
//  AppDelegate.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Cocoa
import EVReflection
import Swinject
import SwinjectPropertyLoader

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let container: Container = {
        let container = Container()
        let loader = JsonPropertyLoader(bundle: .main, name: "MenuInfo")
        try! container.applyPropertyLoader(loader)
        // Singleton
        container.register(StatusBarCenter.self) { r in
            let n: [NSDictionary] = r.property("menu")!
            let minfos = n.map { try? MenuInfo($0) }.filter { $0 != nil }.map { $0! }
            return StatusBarCenter(minfos: minfos)
        }.inObjectScope(.container)

        // Singleton
        container.register(Settings.self) { _ in
            return Settings()
        }.inObjectScope(.container)

        // scope
        container.register(Recognizer.self) { r in
            let settings = r.resolve(Settings.self)!
            if settings.appearence.apitype == .baiduocr {
                return BaiduRecognizer()
            }

            return BaiduRecognizer()
        }
        return container
    }()

    func applicationDidFinishLaunching(_: Notification) {
        // initialize status bar
        PrintOptions.Active = [.ShouldExtendNSObject, .MissingProtocol, .InvalidType, .InvalidValue, .InvalidClass, .EnumWithoutAssociatedValue]
        _ = container.resolve(StatusBarCenter.self)
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate {
    static var container: Container {
        return (NSApplication.shared.delegate as! AppDelegate).container
    }
}
