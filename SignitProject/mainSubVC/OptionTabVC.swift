

import UIKit

class OptionTabVC: UIViewController {

    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var sep: UIImageView!
    
    var optionChangeProtocol: OptionChangeProtocol?
    var doneProtocol : DoneProtocol!
    
    @IBAction func doneClick(_ sender: UIButton) {
        if doneProtocol != nil {
            doneProtocol.doneClicked()
        }
    }
    
    @IBAction func colorChanged(_ sender: UISlider) {
        if(optionChangeProtocol != nil){
            optionChangeProtocol?.changeColor(color: colorSlider.value)
        }
    }
    
    @IBAction func sizeChanged(_ sender: UISlider) {
        sizeSlider.value = roundf(sizeSlider.value)
        if(optionChangeProtocol != nil){
            optionChangeProtocol?.changeSize(size: sizeSlider.value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    

}
