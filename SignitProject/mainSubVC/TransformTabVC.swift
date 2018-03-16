
import UIKit

class TransformTabVC: UIViewController {
    
    var rotateChangeProtocol: RotateChangeProtocol?
    var doneProtocol : DoneProtocol!
    
    
    @IBAction func doneClick(_ sender: UIButton) {
        if doneProtocol != nil {
            doneProtocol.doneClicked()
        }
    }
    
    @IBAction func leftRotateStart(_ sender: UIButton) {
        
        if rotateChangeProtocol != nil {
            rotateChangeProtocol?.leftRotateClick(isIn: true)
        }
    }
    
    @IBAction func leftRotateEnd(_ sender: UIButton) {
        if rotateChangeProtocol != nil {
            rotateChangeProtocol?.leftRotateClick(isIn: false)
        }
    }
    
    @IBAction func leftRotateOut(_ sender: UIButton) {
        if rotateChangeProtocol != nil {
            rotateChangeProtocol?.leftRotateClick(isIn: false)
        }
    }
    
    @IBAction func rightRotateStart(_ sender: UIButton) {
        if rotateChangeProtocol != nil {
            rotateChangeProtocol?.rightRotateClick(isIn: true)
        }
    }
    
    @IBAction func rightRotateEnd(_ sender: UIButton) {
        if rotateChangeProtocol != nil {
            rotateChangeProtocol?.rightRotateClick(isIn: false)
        }
    }
    
    @IBAction func rightRotateOut(_ sender: UIButton) {
        if rotateChangeProtocol != nil {
            rotateChangeProtocol?.rightRotateClick(isIn: false)
        }
    }
    
    @IBAction func centerRotateClick(_ sender: UIButton) {
        if rotateChangeProtocol != nil {
            rotateChangeProtocol?.centerRotateClick()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }



}
