//
//  testViewController.swift
//  On The Map
//
//  Created by Feras Allaou on 1/26/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func gobtn(_ sender: Any) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
