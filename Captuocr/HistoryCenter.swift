//
//  HistoryCenter.swift
//  Captuocr
//
//  Created by Gragrance on 2017/12/4.
//  Copyright © 2017年 Gragrance. All rights reserved.
//

import Foundation
import SQLite
class HistoryCenter {
    private var db: Connection!
    /* TABLE HISTORY*/
    private let HISTORY_TABLE = Table("history")
    private let HISTORY_COLUMN_ID = Expression<Int>("id")
    private let HISTORY_COLUMN_IMGBASE64 = Expression<String>("imgbase64")
    private let HISTORY_COLUMN_TXT = Expression<String>("txt")
    private let HISTORY_COLUMN_TYPE = Expression<Int>("type")
    private let HISTORY_COLUMN_UPDATEAT = Expression<Date>("updateat")
    init() {
        // make sure folder exist
        var path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Captuocr", isDirectory: true)
        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        path = path.appendingPathComponent("history.db")
        db = try? Connection(path.absoluteString)

        // create table if not exists(throw error if table exist)
        _ = try? db.run(HISTORY_TABLE.create(ifNotExists: true) { t in
            t.column(HISTORY_COLUMN_ID, primaryKey: PrimaryKey.autoincrement)
            t.column(HISTORY_COLUMN_IMGBASE64)
            t.column(HISTORY_COLUMN_TXT)
            t.column(HISTORY_COLUMN_TYPE, defaultValue: 0)
            t.column(HISTORY_COLUMN_UPDATEAT, defaultValue: Date(timeIntervalSince1970: 0))
        })
    }

    func addRecord(record: HistoryRecord) {
        _ = try? db.run(HISTORY_TABLE.insert(
            HISTORY_COLUMN_IMGBASE64 <- record.imgBase64,
            HISTORY_COLUMN_TXT <- record.txt,
            HISTORY_COLUMN_TYPE <- record.type.rawValue,
            HISTORY_COLUMN_UPDATEAT <- Date()
        ))
    }

    func getRecordList() -> [HistoryRecord] {
        let query = HISTORY_TABLE.order(HISTORY_COLUMN_UPDATEAT.desc)
        guard let records = try? db.prepare(query) else {
            return []
        }

        return records.map { (r) -> HistoryRecord in
            let hr = HistoryRecord()
            hr.id = r[self.HISTORY_COLUMN_ID]
            hr.txt = r[self.HISTORY_COLUMN_TXT]
            hr.updateAt = r[self.HISTORY_COLUMN_UPDATEAT]
            if let t = HistoryType(rawValue: r[self.HISTORY_COLUMN_TYPE]) {
                hr.type = t
            }

            // lazy load when using later to save memory
            // hr.imgBase64 = r[self.HISTORY_COLUMN_IMGBASE64]
            return hr
        }
    }

    func getImgBase64(id: Int) -> String? {
        let query = HISTORY_TABLE.filter(HISTORY_COLUMN_ID == id)
        if let matchRecord = try? db.prepare(query), let match = (matchRecord.first { _ in true }) {
            return match[self.HISTORY_COLUMN_IMGBASE64]
        }

        return nil
    }
}
