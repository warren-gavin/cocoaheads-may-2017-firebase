//
//  DataStore.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 15/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import Foundation

final class DataStore: Store {
    private var source: Source
    private let sinks: [Sink]

    // MARK: Store
    init(source: Source, sinks: [Sink]) {
        self.source = source
        self.sinks  = sinks
    }
    
    // MARK: SessionSupporting
    func start() {
        source.onData = { [unowned self] value in
            self.sinks.forEach {
                $0.writeData(value)
            }
        }

        source.start()
    }
    
    func stop() {
        source.onData = { _ in }
        source.stop()
    }
}
