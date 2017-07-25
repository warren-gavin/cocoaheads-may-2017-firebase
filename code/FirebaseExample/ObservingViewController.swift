//
//  ObservingViewController.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 16/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import UIKit

final class ObservingViewController: UIViewController, Sink {
    @IBOutlet var dataLabel: UILabel!

    private var store: Store? {
        didSet {
            store?.start()
        }
    }
    
    lazy var writeData: (Int) -> Void = { value in
        DispatchQueue.main.async { [unowned self] in
            self.dataLabel.text = "\(value)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLabel.text = nil
        
        let source = Data.source()
        let onComplete: (Bool) -> Void = { [unowned self] ok in
            if ok {
                self.store = DataStore(source: source, sinks: [self])
            }
        }
        
        if let setupRequired = source as? SetupRequiring {
            setupRequired.setup(onComplete: onComplete)
        }
        else {
            onComplete(true)
        }
    }
}
