//
//  PreferenceWindow.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController {

    @IBOutlet var panel: NSView!
    @IBOutlet var toolbar: NSToolbar!
    @IBOutlet var generalCata: NSToolbarItem!
    @IBOutlet var apiCat: NSToolbarItem!
    override func windowDidLoad() {
        super.windowDidLoad()
        toolbar.selectedItemIdentifier = apiCat.itemIdentifier
        toolbar
            .reactive
            .keyPath("selectedItemIdentifier", ofExpectedType: NSToolbarItem.Identifier.self, context: .immediateOnMain)
            .map { $0 == self.generalCata.itemIdentifier
                ? PreferenceGeneralViewController(nibName: NSNib.Name("PreferenceGeneralView"), bundle: Bundle.main).view
                : PreferenceOcrapiViewController(nibName: NSNib.Name("PreferenceOcrapiView"), bundle: Bundle.main).view }
            .observeNext { childview in
                self.panel.subviews.removeAll()
                childview.frame = self.panel.frame
                self.panel.addSubview(childview)
            }.dispose(in: panel.bag)

        panel.reactive.keyPath("frame", ofExpectedType: NSRect.self, context: .immediateOnMain)
            .observeNext { self.panel.subviews.first?.frame = $0 }
            .dispose(in: panel.bag)
    }

    func reload() {
        if let apiCatalog = apiCat {
            toolbar.selectedItemIdentifier = apiCatalog.itemIdentifier
        }
    }

    @IBAction func generalClick(_: Any) {
    }

    @IBAction func ocrapiClick(_: Any) {
    }
}
