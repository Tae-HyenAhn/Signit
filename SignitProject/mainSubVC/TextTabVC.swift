//
//  TextTabVC.swift
//  SignitProject
//
//  Created by 김지훈 on 20/02/2018.
//  Copyright © 2018 redish. All rights reserved.
//

import UIKit

class TextTabVC: UIViewController {

    @IBOutlet weak var sliderTest: UISlider!
    
    @IBAction func sliderChange(_ sender: UISlider) {
        print(sliderTest.value)
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
