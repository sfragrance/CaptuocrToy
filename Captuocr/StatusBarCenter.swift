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
        recognizeVc.view.frame = NSRect(x: 0, y: 0, width: 834, height: 474)
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
            if $0.is_separator {
                return NSMenuItem.separator()
            } else {
                let menuItem = NSMenuItem()
                menuItem.title = $0.title
                menuItem.target = self
                menuItem.action = NSSelectorFromString($0.selector)
                if let hotkey = $0.key, !hotkey.isEmpty {
                    menuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: UInt(Int(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue)))
                    menuItem.keyEquivalent = hotkey
                }
                return menuItem
            }
        }.forEach {
            tarMenu.addItem($0)
        }
    }

    @objc
    func capturePic4Txt() {
        guard let picPath = Utils.capturePic() else {
            return
        }

        recognizepic(picPath: picPath)
    }

    @objc
    func selectPic4Txt() {
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
    func capturePic4Qrcode() {
        guard let picPath = Utils.capturePic() else {
            return
        }
        
        recognizeQrcode(picPath: picPath)
    }
    
    @objc
    func selectPic4Qrcode() {
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
                recognizeQrcode(picPath: result.path)
            }
        }
    }

    @objc
    func history() {
        if let windowController = AppDelegate.container.resolve(HistoryWindowController.self) {
            windowController.reload()
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
                        self.recognizeVc.viewmodel.image.value = base64
                        self.recognizeVc.viewmodel.recognizedText.value = error.localizedDescription
                        self.showPopover()
                    }
                }
            }
        }
    }
    
    private func recognizeQrcode(picPath: String){
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
            let record = HistoryRecord()
            record.txt = qrtext
            record.imgBase64 = base64
            record.type = .qrcode
            self.historyCenter.addRecord(record: record)
            
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
