//
//  ViewController.swift
//  Flash Chat
//
//  Created by Anna Zaitsava on 14.09.23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = ""
        var characterIndex = 0.0
        let titleText = K.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }

            characterIndex += 1

        }
        
    }


}


    
    

