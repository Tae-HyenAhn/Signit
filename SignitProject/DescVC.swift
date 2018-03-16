
import UIKit
import AVFoundation
import Photos


class DescVC: UIViewController {
    
    var micAllowed : Bool! = false
    var photoAllowed : Bool! = false
    
    var index : Int!
    
    var permissionProtocol : PermissionCompleteProtocol?
    
    @IBOutlet weak var photoCheckbox: UIButton!
    @IBOutlet weak var micCheckbox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if micAllowed == true {
            self.micCheckbox.imageView?.image = UIImage(named: "d3btnok")
        }
        
        if photoAllowed == true {
            self.photoCheckbox.imageView?.image = UIImage(named: "d3btnok")
        }
        
    }
    
    @IBAction func micTextBtnClick(_ sender: Any) {
        getPermissionForMic()
    }
    
    @IBAction func micBtnClick(_ sender: Any) {
        getPermissionForMic()
    }
    
    @IBAction func photoTextBtnClick(_ sender: Any) {
        getPermissionForPhotoLibrary()
    }
    
    @IBAction func photoBtnClick(_ sender: Any) {
        getPermissionForPhotoLibrary()
    }
    
    func getPermissionForMic() {
        if AVAudioSession.sharedInstance().recordPermission() == AVAudioSessionRecordPermission.undetermined {
            
            AVAudioSession.sharedInstance().requestRecordPermission { (isAllowed) in
                if isAllowed {
                    
                    DispatchQueue.main.async {
                        
                        self.micCheckbox.imageView?.image = UIImage(named: "d3btnok")
                        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                            
                            if self.permissionProtocol != nil {
                                self.permissionProtocol?.permissionAllOK()
                            }
                            
                        }
                    }
                    
                } else {
                    let dialog = UIAlertController(title: "Mic permission was not allowed.", message: "Please go setting and allow the permission.", preferredStyle: .alert)
                    let goSetting = UIAlertAction(title: "Go Setting", style: UIAlertActionStyle.default, handler: { (action) in
                        
                        if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                            if UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings, options: ["":""], completionHandler: nil)
                            }
                        }
                        
                    })
                    let cancel = UIAlertAction(title: "I don't want to.", style: UIAlertActionStyle.default, handler: nil)
                    dialog.addAction(goSetting)
                    dialog.addAction(cancel)
                    
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        } else if AVAudioSession.sharedInstance().recordPermission() == AVAudioSessionRecordPermission.denied {
            let dialog = UIAlertController(title: "Mic permission was not allowed.", message: "Please go setting and allow the permission.", preferredStyle: .alert)
            let goSetting = UIAlertAction(title: "Go Setting", style: UIAlertActionStyle.default, handler: { (action) in
                
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings, options: ["":""], completionHandler: nil)
                    }
                }
                
            })
            let cancel = UIAlertAction(title: "I don't want to.", style: UIAlertActionStyle.default, handler: nil)
            dialog.addAction(goSetting)
            dialog.addAction(cancel)
            
            self.present(dialog, animated: true, completion: nil)
        }
        
    }
    
    func getPermissionForPhotoLibrary() {
        let state = PHPhotoLibrary.authorizationStatus()
        
        if state == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        
                        self.photoCheckbox.imageView?.image = UIImage(named: "d3btnok")
                        
                        if AVAudioSession.sharedInstance().recordPermission() == AVAudioSessionRecordPermission.granted {
                            
                            if self.permissionProtocol != nil {
                                self.permissionProtocol?.permissionAllOK()
                            }
                            
                        }
                    }
                    
                } else if status == PHAuthorizationStatus.denied {
                    let dialog = UIAlertController(title: "Photo Library access permission was not allowed.", message: "Please go setting and allow the permission.", preferredStyle: .alert)
                    let goSetting = UIAlertAction(title: "Go Setting", style: UIAlertActionStyle.default, handler: { (action) in
                        
                        if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                            if UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings, options: ["":""], completionHandler: nil)
                            }
                        }
                        
                    })
                    let cancel = UIAlertAction(title: "I don't want to.", style: UIAlertActionStyle.default, handler: nil)
                    dialog.addAction(goSetting)
                    dialog.addAction(cancel)
                    
                    self.present(dialog, animated: true, completion: nil)
                }
            })
        } else if state == PHAuthorizationStatus.denied {
            let dialog = UIAlertController(title: "Photo Library access permission was not allowed.", message: "Please go setting and allow the permission.", preferredStyle: .alert)
            let goSetting = UIAlertAction(title: "Go Setting", style: UIAlertActionStyle.default, handler: { (action) in
                
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings, options: ["":""], completionHandler: nil)
                    }
                }
                
            })
            let cancel = UIAlertAction(title: "I don't want to.", style: UIAlertActionStyle.default, handler: nil)
            dialog.addAction(goSetting)
            dialog.addAction(cancel)
            
            self.present(dialog, animated: true, completion: nil)
        }
    }
}

protocol PermissionCompleteProtocol {
    func permissionAllOK()
}
