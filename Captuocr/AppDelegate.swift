//
//  AppDelegate.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Carbon
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
        // Singleton
        container.register(HistoryCenter.self) { _ in
            return HistoryCenter()
        }.inObjectScope(.container)

        // Singleton
        container.register(PreferenceWindowController.self) { _ in
            let wvc = PreferenceWindowController(windowNibName: NSNib.Name("PreferenceWindow"))
            wvc.window?.level = NSWindow.Level.floating
            return wvc
        }.inObjectScope(.container)

        // Singleton
        container.register(HistoryWindowController.self) { _ in
            let hvc = HistoryWindowController(windowNibName: NSNib.Name("HistoryWindow"))
            hvc.window?.level = NSWindow.Level.floating
            return hvc
        }.inObjectScope(.container)

        // scope
        container.register(Recognizer.self) { r in
            let settings = r.resolve(Settings.self)!
            if settings.appearence.apitype == .baiduocr {
                return BaiduRecognizer()
            }

            return GoogleVisionRecognizer()
        }
        return container
    }()

    func applicationDidFinishLaunching(_: Notification) {
        // initialize status bar
        PrintOptions.Active = [.ShouldExtendNSObject, .MissingProtocol, .InvalidType, .InvalidValue, .InvalidClass, .EnumWithoutAssociatedValue]
        _ = container.resolve(StatusBarCenter.self)
        if let setting = container.resolve(Settings.self), setting.appearence.showInDock {
            var psn: ProcessSerialNumber = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
            TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
        }

        _ = container.resolve(HistoryCenter.self)
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
