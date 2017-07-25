//
//  DataGenerator.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 15/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import Foundation

final class DataGenerator: Source {
    var onData: (Int) -> Void = { _ in }
    
    private var generateData = false {
        didSet {
            DispatchQueue.global(qos: .background).async { [unowned self] in
                while self.generateData {
                    self.onData(Int(arc4random_uniform(1000000)))
                    sleep(1)
                }
            }
        }
    }
    
    // MARK: SessionSupporting
    func start() {
        generateData = true
    }
    
    func stop() {
        generateData = false
    }
}
