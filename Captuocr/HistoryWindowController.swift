//
//  HistoryWindow.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Cocoa

class HistoryWindowController: NSWindowController {

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var contentView: NSView!
    let viewmodel = HistoryViewModel()
    var setting: Settings!
    var historyCenter: HistoryCenter!
    override func windowDidLoad() {
        super.windowDidLoad()
        setting = AppDelegate.container.resolve(Settings.self)!
        historyCenter = AppDelegate.container.resolve(HistoryCenter.self)!
        tableView.register(NSNib(nibNamed: NSNib.Name(HistoryCell.name), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: HistoryCell.name))
        bindViewmodel()
        initialize()
    }
    
    func reload() {
        initialize()
    }
}
