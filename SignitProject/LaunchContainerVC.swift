//
//  LaunchContainerVC.swift
//  SignitProject
//
//  Created by 김지훈 on 20/02/2018.
//  Copyright © 2018 redish. All rights reserved.
//

import UIKit

class LaunchContainerVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    var gradient : CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bgGradientDraw()
    }
    
    func bgGradientDraw(){
        gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        
        gradient.colors = [ UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1).cgColor, UIColor.black.cgColor ]
        gradient.locations = [0, 0.8 ]
        bgView.layer.addSublayer(gradient)
    }


}
