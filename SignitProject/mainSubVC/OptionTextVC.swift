
import UIKit

class OptionTextVC: UIViewController {
   
    @IBOutlet weak var textSizeSlider: UISlider!
    
    @IBOutlet weak var btnTest: UIButton!
    
    @IBAction func sizeSliderChange(_ sender: UISlider) {
        print("ok")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(textSizeSlider.value)
        
    }
    

}
