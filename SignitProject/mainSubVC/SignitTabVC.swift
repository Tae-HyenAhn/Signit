
import UIKit

class SignitTabVC: UIViewController, ContainerProtocol {

    
    @IBOutlet weak var signitBtn: UIButton!
    @IBOutlet weak var signitBtnLabel: UIButton!
    
    var signitClick : SignitBtnClickProtocol?
    
    
    @IBAction func signitCompleteClick(_ sender: UIButton) {
        
        if(signitClick != nil){
            signitClick?.signitClick(sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func signitLabelChange(sign: String) {
    
        signitBtnLabel.setTitle(sign, for: .normal)
        signitBtnLabel.titleLabel!.adjustsFontSizeToFitWidth = true
    }
}

