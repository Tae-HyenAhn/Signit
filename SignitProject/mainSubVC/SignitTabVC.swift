
import UIKit

class SignitTabVC: UIViewController, ContainerProtocol {

    
    @IBOutlet weak var signitBtn: UIButton!
    @IBOutlet weak var signitLabel: UILabel!
    
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
        signitLabel.text = sign
        signitLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    
}

