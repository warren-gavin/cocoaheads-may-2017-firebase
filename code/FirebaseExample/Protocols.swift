//
//  Protocols.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 15/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import Foundation

protocol SessionSupporting {
    func start()
    func stop()
}

protocol Source: SessionSupporting {
    var onData: (Int) -> Void { get set }
}

protocol Sink {
    var writeData: (Int) -> Void { get }
}

protocol SetupRequiring {
    func setup(onComplete: @escaping (Bool) -> Void)
}

protocol Store: SessionSupporting {
    init(source: Source, sinks: [Sink])
}

protocol BackendConfiguring {
    func configureBackend()
}
