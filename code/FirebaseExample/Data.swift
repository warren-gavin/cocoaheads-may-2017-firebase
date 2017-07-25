//
//  Data.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 16/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

// Isolates all mention of Firebase to this file. All other classes that need to access
// Firebase do so by asking for a source or a sink.
struct Data {
    static let firebase = Firebase()

    static func sink() -> Sink {
        return firebase
    }
    
    static func source() -> Source {
        return firebase
    }
}
