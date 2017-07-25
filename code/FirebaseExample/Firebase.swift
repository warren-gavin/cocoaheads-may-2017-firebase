//
//  Firebase.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 15/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

/// The Firebase wrapper. All writing, reading, logging in etc happen here. 
class Firebase: Source, Sink, SetupRequiring {
    private enum LoginState {
        case loggedIn(User, DataReference)
        case loggedOut
    }
    
    private var counter = 0
    private var newDataObserver: UInt?
    private var state: LoginState = .loggedOut
    
    var onData: (Int) -> Void = { _ in }
    
    func start() {
        guard case .loggedIn(_, let dataRef) = state else {
            return
        }
        
        newDataObserver = dataRef.referencePath.observe(.childAdded, with: { (snapshot) in
            if let data = snapshot.value as? Int {
                self.onData(data)
            }
        })
    }
    
    func stop() {
        guard case .loggedIn(_, let dataRef) = state else {
            return
        }
        
        if let handle = newDataObserver {
            dataRef.referencePath.removeObserver(withHandle: handle)
        }
    }
    
    lazy var writeData: (Int) -> Void = { [unowned self] value in
        guard case .loggedIn(_, let dataReference) = self.state else {
            return
        }
        
        dataReference.add("\(self.counter)", value: value)
        self.counter += 1
    }
    
    func setup(onComplete: @escaping (Bool) -> Void) {
        guard case .loggedOut = state else {
            onComplete(true)
            return
        }
        
        let onUser: (User) -> Void = { [unowned self] user in
            self.state = .loggedIn(user, DataReference(for: user))
            onComplete(true)
        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                onUser(user)
            }
            else {
                auth.signInAnonymously(completion: { (user, _) in
                    if let user = user {
                        onUser(user)
                    }
                    else {
                        onComplete(false)
                    }
                })
            }
        }
    }
}

extension BackendConfiguring {
    func configureBackend() {
        FirebaseApp.configure()
    }
}

/// Represents node /sessions/{user_id}/{session_id}/data
private final class DataReference {
    fileprivate let referencePath: DatabaseReference

    init(for user: User) {
        let databaseRoot = Database.database().reference()
        referencePath = databaseRoot.child(.sessionNode).child(user.uid).childByAutoId().child(.dataNode)
    }
    
    /// Writes value to node /sessions/{user_id}/{session_id}/data/<key>
    func add(_ key: String, value: Int) {
        referencePath.child(key).setValue(value)
    }
}

// MARK: - Firebase extensions
private extension String {
    static let sessionNode = "sessions"
    static let dataNode    = "data"
}
