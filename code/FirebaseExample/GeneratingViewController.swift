//
//  ViewController.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 15/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import UIKit

class GeneratingViewController: UIViewController, Sink {
    @IBOutlet var loginIndicator: UIActivityIndicatorView!
    @IBOutlet var button: UIButton!
    @IBOutlet var dataLabel: UILabel!
    
    private var running: Bool = false
    private var store: Store? {
        didSet {
            if store != nil {
                ready()
            }
            else {
                showLoginAlert()
            }
        }
    }
    
    lazy var writeData: (Int) -> Void = { [unowned self] value in
        DispatchQueue.main.async {
            self.dataLabel.text = "\(value)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLabel.text = nil
        
        let sink = Data.sink()
        let onComplete: (Bool) -> Void = { [unowned self] ok in
            if ok {
                self.store = DataStore(source: DataGenerator(), sinks: [sink, self])
            }
        }
        
        if let setupRequired = sink as? SetupRequiring {
            setupRequired.setup(onComplete: onComplete)
        }
        else {
            onComplete(true)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let store = store else {
            return
        }
        
        if running {
            sender.setTitle("Start", for: .normal)
            store.stop()
        }
        else {
            sender.setTitle("Stop", for: .normal)
            store.start()
        }
        
        running = !running
    }
}

private extension GeneratingViewController {
    func ready() {
        DispatchQueue.main.async { [unowned self] in
            self.loginIndicator.stopAnimating()
            self.button.isEnabled = true
            self.button.isHidden = false
        }
    }
    
    func showLoginAlert() {
        let alert = UIAlertController(title: "Problem",
                                      message: "If you're seeing this, login failed",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)

        DispatchQueue.main.async { [unowned self] in
            self.button.isEnabled = false
            self.present(alert, animated: true) { [unowned self] in
                self.loginIndicator.stopAnimating()
            }
        }
    }
}
