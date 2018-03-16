

import UIKit


class OptionViewController: UIViewController {
    
    let skipEnableKey = "KEY_SKIP_ENABLE"
    @IBOutlet weak var dryskipSwitch: UISwitch!
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        if sender.isOn {
           
            UserDefaults.standard.set("1", forKey: skipEnableKey)
        } else {
            
            UserDefaults.standard.set("0", forKey: skipEnableKey)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let state = UserDefaults.standard.string(forKey: "KEY_SKIP_ENABLE") {
            if state == "1" {
                dryskipSwitch.isOn = true
            } else if state == "0" {
                dryskipSwitch.isOn = false
            }
        } else {
            dryskipSwitch.isOn = true
            UserDefaults.standard.set("1", forKey: "KEY_SKIP_ENABLE")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }

    func isiPhoneXScreen() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        
        return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
    }
    
    override var prefersStatusBarHidden: Bool {
        if isiPhoneXScreen() {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let optionWebView = segue.destination as! OptionWebView
        if segue.identifier == "toOSSegue" {
            optionWebView.url = "http://signitsignit.com/oslicense"
        }
    }
    
}
