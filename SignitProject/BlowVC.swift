
import Foundation
import UIKit
import AVFoundation
import CoreAudio

class BlowVC: UIViewController {
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var blowIndicator: UIImageView!
    @IBOutlet weak var signedLabel: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    
    var dismissDataTransferProtocol : DismissDataTransferProtocol!
    var recorder : AVAudioRecorder!
    var levelTimer = Timer()
    let LEVEL_THRESHOLD : Float = -10.1
    var centerY : CGFloat!
    var animController : Bool!
    var signedText : String!
    
    @IBAction func skip(_ sender: UIButton) {
        if recorder != nil {
            recorder.stop()
        }
        
        if dismissDataTransferProtocol != nil {
            dismissDataTransferProtocol.dismissed(type: true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        if recorder != nil {
            recorder.stop()
        }
        
        if dismissDataTransferProtocol != nil {
            dismissDataTransferProtocol.dismissed(type: false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let state = UserDefaults.standard.string(forKey: "KEY_SKIP_ENABLE") {
            if state == "1" {
                skipBtn.isHidden = false
            } else if state == "0" {
               skipBtn.isHidden = true
            }
        } else {
            skipBtn.isHidden = false
            UserDefaults.standard.set("1", forKey: "KEY_SKIP_ENABLE")
        }
        
        signedLabel.text = signedText
        signedLabel.adjustsFontSizeToFitWidth = true
        centerY = blowIndicator.center.y - self.blowIndicator.bounds.height*0.25
        animController = true
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings : [String : Any] = [
            AVFormatIDKey : kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url: url, settings: recordSettings)
        } catch {
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
        
    }
    
    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        let level = recorder.averagePower(forChannel: 0)
        let isLoud = level > LEVEL_THRESHOLD
        if(isLoud){
            
            if recorder != nil {
                
                if animController == true{
                    animController = false
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                        self.blowIndicator.center.y = self.blowIndicator.center.y - self.blowIndicator.bounds.height*0.35
                        self.signedLabel.alpha = self.signedLabel.alpha + 0.31
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                            self.blowIndicator.center.y = self.centerY
                            self.signedLabel.alpha = self.signedLabel.alpha - 0.1
                        }, completion: { (complete) in
                            self.centerY = self.centerY - self.blowIndicator.bounds.height*0.25
                            self.animController = true
                            print(self.signedLabel.alpha)
                            if self.signedLabel.alpha >= 1.0 {
                                
                                if self.recorder != nil {
                                    self.recorder.stop()
                                }
                                
                                if self.dismissDataTransferProtocol != nil {
                                    self.dismissDataTransferProtocol.dismissed(type: true)
                                }
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                            
                        })
                    })
                  
                }
                
            }
            
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        if isiPhoneXScreen() {
            return false
        }
        return true
    }
    
    func isiPhoneXScreen() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        
        return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
    }

}

protocol DismissDataTransferProtocol {
    func dismissed(type : Bool)
}
