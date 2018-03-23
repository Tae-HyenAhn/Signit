
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
    
    @IBAction func signLabelClick(_ sender: UIButton) {
        if signitClick != nil {
            signitClick?.signLabelClick()
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

