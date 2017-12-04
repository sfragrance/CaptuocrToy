//
//  HistoryViewModel.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

class HistoryViewModel {
    let itemsource = MutableObservableArray<HistoryRecord>([])
}

extension HistoryWindowController {
    func bindViewmodel() {
        viewmodel.itemsource.bind(to: tableView) { (source, row, tv) -> NSView? in
            let cell = tv.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: HistoryCell.name), owner: self) as! HistoryCell
            let model = source[row]
            cell.tfMain?.stringValue = model.txt
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMMM dd HH:mm"
            cell.tfAt.stringValue = dateformatter.string(from: model.updateAt)
            cell.type = model.type
            return cell
        }.dispose(in: tableView.bag)
        
        tableView.reactive.selectionDidChange.observeNext {
            guard self.tableView.selectedRow >= 0 && self.tableView.selectedRow < self.viewmodel.itemsource.count else{
                return
            }
            let model = self.viewmodel.itemsource.array[self.tableView.selectedRow]
            if let base64 = self.historyCenter.getImgBase64(id: model.id){
                let recognizeVc = RecognizeBoxViewController(nibName: NSNib.Name("RecognizeBox"), bundle: Bundle.main)
                //recognizeVc.view.frame = NSRect(x: 0, y: 0, width: 834, height: 474)
                recognizeVc.viewmodel.image.value = base64
                recognizeVc.viewmodel.recognizedText.value = model.txt
                self.contentView.subviews.removeAll()
                self.contentView.addSubview(recognizeVc.view)
                self.contentView.reactive.keyPath("frame", ofExpectedType: NSRect.self, context: .immediateOnMain)
                    .observeNext {
                        self.contentView.subviews.first?.frame = NSRect.init(x: 0, y: 0, width: $0.width, height: $0.height)
                        
                    }
                    .dispose(in: self.contentView.bag)
            }
        }.dispose(in: tableView.bag)
    }

    func initialize() {
        historyCenter.getRecordList()
            .forEach { (record) in
                viewmodel.itemsource.append(record)
        }
    }
}
