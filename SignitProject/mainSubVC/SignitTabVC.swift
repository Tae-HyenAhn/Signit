
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
    
    
    func signitLabelChange(sign: String, fontName: String) {
        print(fontName)
        signitBtnLabel.setTitle(sign, for: .normal)
        signitBtnLabel.titleLabel!.adjustsFontSizeToFitWidth = true
        signitBtnLabel.titleLabel!.font = UIFont(name: fontName, size: signitBtnLabel.titleLabel!.font.pointSize)
    }
}

