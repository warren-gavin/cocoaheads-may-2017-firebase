//
//  DebugConsole.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 16/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import Foundation

struct DebugConsole: Sink {
    var writeData: (Int) -> Void = { value in
        print("Source generated: \(value)")
    }
}
