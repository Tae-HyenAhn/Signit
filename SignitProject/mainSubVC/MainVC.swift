//
//  MainVC.swift
//  SignitProject
//
//  Created by 김지훈 on 19/02/2018.
//  Copyright © 2018 redish. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var signitBtn: UIButton!
    @IBAction func signitClick(_ sender: UIButton) {
        print("signit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
