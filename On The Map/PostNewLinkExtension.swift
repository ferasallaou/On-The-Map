//
//  PostNewLinkExtension.swift
//  On The Map
//
//  Created by Feras Allaou on 2/1/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit

extension PostNewLinkViewController: UITextViewDelegate, UITextFieldDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.mediaURLTextField.text == "What are you studying?" {
        self.mediaURLTextField.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.mediaURLTextField.text == "" {
            self.mediaURLTextField.text = "What are you studying?"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkURLIfValid(_ urlString: String?) -> Bool {
        guard let urlString = urlString,
            let mURL = URL(string: urlString) else {
                return false
        }
        
        return UIApplication.shared.canOpenURL(mURL)
    }
  
}
