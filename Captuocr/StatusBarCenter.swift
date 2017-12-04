//
//  StatusBarViewModel.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/1.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Alamofire
import AppKit
import Async
import Carbon
import Foundation
import CoreImage

class StatusBarCenter {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let tarMenu = NSMenu()
    let popover = NSPopover()
    var recognizeVc: RecognizeBoxViewController
    let setting: Settings
    let menuinfos: [MenuInfo]
    let historyCenter: HistoryCenter
    init(minfos: [MenuInfo]) {
        setting = AppDelegate.container.resolve(Settings.self)!
        historyCenter = AppDelegate.container.resolve(HistoryCenter.self)!
        popover.behavior = .transient
        recognizeVc = RecognizeBoxViewController(nibName: NSNib.Name("RecognizeBox"), bundle: Bundle.main)
        popover.contentViewController = recognizeVc
        menuinfos = minfos
        let icon = NSImage(named: NSImage.Name("icons8-text-16"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = tarMenu

        buildMenu()
    }

    private func buildMenu() {
        tarMenu.removeAllItems()
        menuinfos.map {
            $0.is_separator
                ? NSMenuItem.separator()
                : NSMenuItem(title: $0.title, action: NSSelectorFromString($0.selector), keyEquivalent: $0.key)
        }.forEach {
            if !$0.isSeparatorItem {
                $0.target = self
                $0.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: UInt(Int(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue)))
            }
            tarMenu.addItem($0)
        }
    }

    @objc
    func capturePic() {
        guard let picPath = Utils.capturePic() else {
            return
        }

        recognizepic(picPath: picPath)
    }
    
    @objc
    func captureQRCode() {
        guard let picPath = Utils.capturePic() else {
            return
        }
        recognizeQRCode(picPath: picPath)
    }

    @objc
    func selectPic() {
        let dialog = NSOpenPanel()
        dialog.title = "选择图片"
        dialog.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["png", "jpg", "bmp"]

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let result = dialog.url {
                recognizepic(picPath: result.path)
            }
        }
    }

    @objc
    func history() {
        if let windowController = AppDelegate.container.resolve(HistoryWindowController.self) {
            windowController.showWindow(self)
        }
    }

    @objc
    func preference() {
        if let windowController = AppDelegate.container.resolve(PreferenceWindowController.self) {
            windowController.reload()
            windowController.showWindow(self)
        }
    }

    @objc
    func quit() {
        NSApplication.shared.terminate(self)
    }

    private func recognizepic(picPath: String) {
        let picData = try? Data(contentsOf: URL(fileURLWithPath: picPath))
        if let base64 = picData?.base64EncodedString(), let recognizer = AppDelegate.container.resolve(Recognizer.self) {
            statusItem.image = nil
            statusItem.title = "0%"
            Async.background {
                do {
                    let final = try recognizer.recognize(picBase64: base64, progress: { p in
                        Async.main {
                            self.statusItem.title = "\(p * 100)%"
                        }
                    })
                    Async.main {
                        self.statusItem.image = NSImage(named: NSImage.Name("icons8-text-16"))
                        self.statusItem.title = nil
                        self.recognizeVc = RecognizeBoxViewController(nibName: NSNib.Name("RecognizeBox"), bundle: Bundle.main)
                        self.recognizeVc.view.frame = NSRect(x: 0, y: 0, width: 834, height: 474)
                        self.popover.contentViewController = self.recognizeVc
                        self.recognizeVc.viewmodel.image.value = base64
                        self.recognizeVc.viewmodel.recognizedText.value = final
                        self.showPopover()
                    }
                    let record = HistoryRecord()
                    record.txt = final
                    record.imgBase64 = base64
                    record.type = .ocr
                    self.historyCenter.addRecord(record: record)
                } catch {
                    print(error)
                    Async.main {
                        self.statusItem.image = NSImage(named: NSImage.Name("icons8-text-16"))
                        self.statusItem.title = nil
                        self.recognizeVc = RecognizeBoxViewController(nibName: NSNib.Name("RecognizeBox"), bundle: Bundle.main)
                        self.recognizeVc.view.frame = NSRect(x: 0, y: 0, width: 834, height: 474)
                        self.popover.contentViewController = self.recognizeVc
                        self.recognizeVc.viewmodel.image.value = base64
                        self.recognizeVc.viewmodel.recognizedText.value = error.localizedDescription
                        self.showPopover()
                    }
                }
            }
        }
    }

    private func recognizeQRCode(picPath: String) {
        let scanImage = CIImage(contentsOf: URL(fileURLWithPath: picPath))
        // Extract QR code features
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)!
        let features = detector.features(in: scanImage!)
        
        // Process each QR code found
        var qrtext:String=""
        for feature in features as! [CIQRCodeFeature] {
            qrtext+=feature.messageString! + "\n"
        }
        let picData = try? Data(contentsOf: URL(fileURLWithPath: picPath))
        if let base64 = picData?.base64EncodedString(){
            self.recognizeVc.viewmodel.image.value = base64
            self.recognizeVc.viewmodel.recognizedText.value = qrtext
            self.showPopover()
        }
    }

    private func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
}
