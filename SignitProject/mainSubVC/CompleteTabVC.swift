
import UIKit

class CompleteTabVC: UIViewController {

    var completeClickProtocol : CompleteClickProtocol?
    var doneProtocol : DoneProtocol!
    
    
    @IBAction func doneClicked(_ sender: UIButton) {
        if doneProtocol != nil {
            doneProtocol.doneClicked()
        }
    }
    
    @IBAction func instaShare(_ sender: UIButton) {
        if(completeClickProtocol != nil){
            completeClickProtocol?.instaShareClick(sender)
        }
    }
    
    @IBAction func saveImg(_ sender: UIButton) {
        if(completeClickProtocol != nil){
            completeClickProtocol?.saveImgClick(sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

 

}
