import UIKit
import Photos
import PhotosUI
import StoreKit

class EditViewController: UIViewController, UITextFieldDelegate, OptionChangeProtocol, RotateChangeProtocol, SignitBtnClickProtocol, CompleteClickProtocol, UIViewControllerTransitioningDelegate, DoneProtocol, DismissDataTransferProtocol {
    
    var documentsInteractionsController: UIDocumentInteractionController!
    let transition = CircularTransition()
    
    var containerProtocol : ContainerProtocol!
    let saveSignTextKey = "SIGN_TEXT"
    let saveSignSizeKey = "SIGN_SIZE"
    let signCompleteCountKey = "SIGN_COUNT"
    let signIsFirst = "SIGN_FIRST"
    
    let menuState : [String] = ["none", "edit", "option", "transform", "complete"]
    var state : String!
    
    var Asset : PHAsset = PHAsset()
    var editable : Bool = false
    var count : Int = 0
    
    var rotateTimer : Timer?
    
    
    @IBOutlet weak var goAlbumBtn: UIButton!
    @IBOutlet weak var doneBtnArea: UIView!
    @IBOutlet weak var doneBtnPoint: UIView!
    @IBOutlet weak var signTF: UITextField!
    @IBOutlet weak var translateIndicator: UIImageView!
    @IBOutlet weak var optionIndicator: UIImageView!
    @IBOutlet weak var editIndicator: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var translateBtn: UIButton!
    
    @IBOutlet weak var subviewContainer: UIView!
    
    @IBOutlet weak var completeContainer: UIView!
    @IBOutlet weak var transformContainer: UIView!
    @IBOutlet weak var optionContainer: UIView!
    @IBOutlet weak var editContainer: UIView!
    @IBOutlet weak var mainSignitContainer: UIView!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editImageView: UIImageView!
    
    @IBOutlet weak var lineImg: UIImageView!
    @IBOutlet var zoomPinch: UIPinchGestureRecognizer!
    
    
    @IBAction func editTextClick(_ sender: UIButton) {
        // Settings
        signTF.layer.borderWidth = 0.0
        if state == menuState[4] {
            signTF.isUserInteractionEnabled = true
            editImageView.isUserInteractionEnabled = true
            containerView.isUserInteractionEnabled = true
        }
        goAlbumBtn.alpha = 0.4
        goAlbumBtn.isUserInteractionEnabled = false
        subviewContainer.bringSubview(toFront: editContainer)
        editIndicator.alpha = 1.0
        optionIndicator.alpha = 0.0
        translateIndicator.alpha = 0.0
        editBtn.alpha = 1.0
        optionBtn.alpha = 0.4
        translateBtn.alpha = 0.4
        
        state = menuState[1]
        
        //op
        editable = true
        signTF.becomeFirstResponder()
    }
    @IBAction func OptionTextClick(_ sender: UIButton) {
        if state == menuState[4] {
            signTF.isUserInteractionEnabled = true
            editImageView.isUserInteractionEnabled = true
            containerView.isUserInteractionEnabled = true
        }
        goAlbumBtn.alpha = 0.4
        goAlbumBtn.isUserInteractionEnabled = false
        signTF.layer.borderWidth = 0.0
        subviewContainer.bringSubview(toFront: optionContainer)
        editIndicator.alpha = 0.0
        optionIndicator.alpha = 1.0
        translateIndicator.alpha = 0.0
        editBtn.alpha = 0.4
        optionBtn.alpha = 1.0
        translateBtn.alpha = 0.4
        
        editable = false
        
        //op
        state = menuState[2]
    }
    @IBAction func TranslateTextClick(_ sender: UIButton) {
        if state == menuState[4] {
            signTF.isUserInteractionEnabled = true
            editImageView.isUserInteractionEnabled = true
            containerView.isUserInteractionEnabled = true
        }
        goAlbumBtn.alpha = 0.4
        goAlbumBtn.isUserInteractionEnabled = false
        subviewContainer.bringSubview(toFront: transformContainer)
        editIndicator.alpha = 0.0
        optionIndicator.alpha = 0.0
        translateIndicator.alpha = 1.0
        editBtn.alpha = 0.4
        optionBtn.alpha = 0.4
        translateBtn.alpha = 1.0
       
        editable = false
        
        //op
        state = menuState[3]
        
        
    }
    
    func doneClicked() {
        if state == menuState[4] {
            signTF.isUserInteractionEnabled = true
            editImageView.isUserInteractionEnabled = true
            containerView.isUserInteractionEnabled = true
        }
        goAlbumBtn.alpha = 1.0
        goAlbumBtn.isUserInteractionEnabled = true
        editIndicator.alpha = 0.0
        optionIndicator.alpha = 0.0
        translateIndicator.alpha = 0.0
        editBtn.alpha = 0.4
        optionBtn.alpha = 0.4
        translateBtn.alpha = 0.4
        view.endEditing(true)
        signTF.resignFirstResponder()
        editable = false
        subviewContainer.bringSubview(toFront: mainSignitContainer)
        state = menuState[0]
        signTF.sizeToFit()
    }
    
    
    
    @IBAction func signMove(_ sender: UIPanGestureRecognizer) {
        
        editImageView.isUserInteractionEnabled = false
        signTF.layer.borderWidth = 0.6
        signTF.layer.borderColor = signTF.textColor?.cgColor
        sender.maximumNumberOfTouches = 1
        
        let radian = atan2f(Float(signTF.transform.b), Float(signTF.transform.a))
        
        let translation = sender.translation(in: signTF)
        
        let changeX = signTF.center.x + (translation.x * CGFloat(cos(radian))) - (translation.y * CGFloat(sin(radian)))
        let changeY = signTF.center.y + (translation.y * CGFloat(cos(radian))) + (translation.x * CGFloat(sin(radian)))
        
        
        let left = editImageView.center.x - editImageView.frame.width/2
        let right = editImageView.center.x + editImageView.frame.width/2
        let top = editImageView.center.y - editImageView.frame.height/2
        let bottom = editImageView.center.y + editImageView.frame.height/2
        
        if(editImageView.frame.width > editImageView.frame.height){
            if(changeX >= 0 && changeX <= containerView.frame.width){
                if(editImageView.frame.height >= containerView.frame.height){
                    if(changeY >= 0 && changeY <= containerView.frame.height){
                        signTF.center = CGPoint(x: changeX, y: changeY)
                    }
                } else {
                    if(changeY >= top && changeY <= bottom){
                        signTF.center = CGPoint(x: changeX, y: changeY)
                    }
                }
            }
        } else {
            if(changeY >= 0 && changeY <= containerView.frame.height){
                if(editImageView.frame.width >= containerView.frame.width){
                    if(changeX >= 0 && changeX <= containerView.frame.width){
                        signTF.center = CGPoint(x: changeX, y: changeY)
                    }
                } else {
                    if(changeX >= left && changeX <= right){
                        signTF.center = CGPoint(x: changeX, y: changeY)
                    }
                }
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: signTF)
           
        let g = sender.state
        
        if g == .ended {
            editImageView.isUserInteractionEnabled = true
            signTF.layer.borderWidth = 0.0
            
            
        }
        
    }
    
    @IBAction func imgMove(_ sender: UIPanGestureRecognizer) {
        
        sender.maximumNumberOfTouches = 1
        let translation = sender.translation(in: editImageView)
        let changeX = editImageView.center.x + translation.x
        let changeY = editImageView.center.y + translation.y
        
        var state : String!
        
        if editImageView.frame.width > editImageView.frame.height{
            if(editImageView.frame.height <= containerView.frame.height){
                
                editImageView.center = CGPoint(x: changeX, y: containerView.frame.height/2)
                state = "longWidthInner"
            } else {
                
                editImageView.center = CGPoint(x: changeX, y: changeY)
                state = "longWidthOutter"
            }
        } else if editImageView.frame.width <= editImageView.frame.height{
            if(editImageView.frame.width < containerView.frame.width){
                editImageView.center = CGPoint(x: containerView.frame.width/2, y: changeY)
                state = "longHeightInner"
            } else {
                editImageView.center = CGPoint(x: changeX, y: changeY)
                state = "longHeightOutter"
            }
        }
        sender.setTranslation(CGPoint.zero, in: editImageView)
        
        let right = changeX + (editImageView.frame.width/2)
        let left = changeX - (editImageView.frame.width/2)
        let top = changeY - (editImageView.frame.height/2)
        let bottom = changeY + (editImageView.frame.height/2)
        let g = sender.state
        if(g == .began){
            lineFadeIn()
        }else if(g == .ended){
            if(state == "longWidthOutter" || state == "longHeightOutter"){
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    if(left > 0){
                        self.editImageView.center.x = self.editImageView.frame.width/2
                    }
                    if(right < self.containerView.frame.width){
                        self.editImageView.center.x = self.containerView.frame.width - self.editImageView.frame.width/2
                    }
                    if(top > 0){
                        self.editImageView.center.y = self.editImageView.frame.height/2
                        
                    }
                    if(bottom < self.containerView.frame.height){
                        self.editImageView.center.y = self.containerView.frame.height - self.editImageView.frame.height/2
                    }
                    
                }, completion: nil)
                
                
            } else {
                if state == "longWidthInner" {
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        if(left > 0){
                            self.editImageView.center.x = self.editImageView.frame.width/2
                            self.editImageView.center.y = self.containerView.frame.height/2
                        }
                        if(right < self.containerView.frame.width){
                            self.editImageView.center.x = self.containerView.frame.width - self.editImageView.frame.width/2
                            self.editImageView.center.y = self.containerView.frame.height/2
                        }
                        
                    }, completion: nil)
                    
                    
                } else if state == "longHeightInner" {
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        if(top > 0){
                            self.editImageView.center.x = self.containerView.frame.width/2
                            self.editImageView.center.y = self.editImageView.frame.height/2
                        }
                        if(bottom < self.containerView.frame.height){
                            self.editImageView.center.x = self.containerView.frame.width/2
                            self.editImageView.center.y = self.containerView.frame.height - self.editImageView.frame.height/2
                        }
                        
                    }, completion: nil)
                    
                }
            }
            lineFadeOut()
        }
        
    }
    
    func checkSignOutside() {
        let right = editImageView.center.x + editImageView.frame.width/2
        let left = editImageView.center.x - editImageView.frame.width/2
        let top = editImageView.center.y - editImageView.frame.height/2
        let bottom = editImageView.center.y + editImageView.frame.height/2
        
        if(editImageView.frame.width > editImageView.frame.height){
            //ANIM
            UIView.animate(withDuration: 0.2, animations: {
                if(self.signTF.center.x < 0){
                    self.signTF.center.x = self.signTF.frame.width/2
                }
                
                if(self.signTF.center.x > self.containerView.frame.width){
                    self.signTF.center.x = self.containerView.frame.width - (self.signTF.frame.width/2)
                }
                
                if(self.editImageView.frame.height < self.containerView.frame.height){
                    if(self.signTF.center.y < top){
                        self.signTF.center.y = top + self.signTF.frame.height/2
                    }
                    
                    if(self.signTF.center.y > bottom){
                        self.signTF.center.y = bottom - self.signTF.frame.height/2
                    }
                } else {
                    if(self.signTF.center.y < 0){
                        self.signTF.center.y = self.signTF.frame.height/2
                    }
                    
                    if(self.signTF.center.y > self.containerView.frame.height){
                        self.signTF.center.y = self.containerView.frame.height - self.signTF.frame.height/2
                    }
                }
            }, completion: nil)
            
            
        } else {
            
            UIView.animate(withDuration: 0.2, animations: {
                if(self.signTF.center.y < 0){
                    self.signTF.center.y = self.signTF.frame.height/2
                }
                
                if(self.signTF.center.y > self.containerView.frame.height){
                    self.signTF.center.y = self.containerView.frame.height - self.signTF.frame.height/2
                }
                
                if(self.editImageView.frame.width < self.containerView.frame.width){
                    if(self.signTF.center.x < left){
                        self.signTF.center.x = left + self.signTF.frame.width/2
                    }
                    
                    if(self.signTF.center.x > right){
                        self.signTF.center.x = right - self.signTF.frame.width/2
                    }
                    
                } else {
                    if(self.signTF.center.x < 0){
                        self.signTF.center.x = self.signTF.frame.width/2
                    }
                    
                    if(self.signTF.center.x > self.containerView.frame.width){
                        self.signTF.center.x = self.containerView.frame.width - self.signTF.frame.width/2
                    }
                }
            }, completion: nil)
            
        }
        
    }
    
    @IBAction func imgZoom(_ sender: UIPinchGestureRecognizer) {
        editImageView.transform = editImageView.transform.scaledBy(x: zoomPinch.scale, y: zoomPinch.scale)
        
        zoomPinch.scale = 1.0
        
        let g = sender.state
        
        switch g {
        case .began:
            lineFadeIn()
        case .ended:
            
            let right = editImageView.center.x + editImageView.frame.width/2
            let left = editImageView.center.x - editImageView.frame.width/2
            let top = editImageView.center.y - editImageView.frame.height/2
            let bottom = editImageView.center.y + editImageView.frame.height/2
            
            self.checkSignOutside()
            
            
            if editImageView.frame.width > editImageView.frame.height {
                if(editImageView.frame.width < containerView.frame.width){
                    
                    UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        let width = self.containerView.frame.width
                        let height = self.containerView.frame.height * (self.editImageView.frame.height/self.editImageView.frame.width)
                        self.editImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                        self.editImageView.center = CGPoint(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2)
                        
                    }, completion: { (isCompleted) in
                        if isCompleted {
                            self.checkSignOutside()
                        }
                    })
                    
                } else {
                    if(editImageView.frame.height <= containerView.frame.height){
                        UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            
                            if(left > 0){
                                self.editImageView.center.x = self.editImageView.frame.width/2
                            }
                            
                            if(right < self.containerView.frame.width){
                                self.editImageView.center.x = self.containerView.frame.width - self.editImageView.frame.width/2
                            }
                            self.editImageView.center.y = self.containerView.frame.height/2
                        }, completion: { (isCompleted) in
                            if isCompleted {
                                self.checkSignOutside()
                            }
                        })
                        
                    }else {
                        UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            if(left > 0){
                                self.editImageView.center.x = self.editImageView.frame.width/2
                            }
                            
                            if(right < self.containerView.frame.width){
                                self.editImageView.center.x = self.containerView.frame.width - self.editImageView.frame.width/2
                            }
                            
                            if(top > 0){
                                self.editImageView.center.y = self.editImageView.frame.height/2
                            }
                            
                            if(bottom < self.containerView.frame.height){
                                self.editImageView.center.y = self.containerView.frame.height - self.editImageView.frame.height/2
                            }
                            
                        }, completion: { (isCompleted) in
                            if isCompleted {
                                self.checkSignOutside()
                            }
                        })
                        
                    }
                    
                }
                
            } else{
                if(editImageView.frame.height < containerView.frame.height){
                    
                    UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        let height = self.containerView.frame.height
                        let width = self.containerView.frame.width * (self.editImageView.frame.width/self.editImageView.frame.height)
                        self.editImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                        self.editImageView.center = CGPoint(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2)
                        
                    }, completion: { (isCompleted) in
                        if isCompleted {
                            self.checkSignOutside()
                        }
                    })
                    
                    
                } else {
                    if(editImageView.frame.width <= containerView.frame.width){
                        UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            
                            if(top > 0){
                                self.editImageView.center.y = self.editImageView.frame.height/2
                            }
                            
                            if(bottom < self.containerView.frame.height){
                                self.editImageView.center.y = self.containerView.frame.height - self.editImageView.frame.height/2
                            }
                            self.editImageView.center.x = self.containerView.frame.width/2
                            
                        }, completion: { (isCompleted) in
                            if isCompleted {
                                self.checkSignOutside()
                            }
                        })
                        
                    }else{
                        
                        UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            
                            if(left > 0){
                                self.editImageView.center.x = self.editImageView.frame.width/2
                            }
                            
                            if(right < self.containerView.frame.width){
                                self.editImageView.center.x = self.containerView.frame.width - self.editImageView.frame.width/2
                            }
                            
                            if(top > 0){
                                self.editImageView.center.y = self.editImageView.frame.height/2
                            }
                            
                            if(bottom < self.containerView.frame.height){
                                self.editImageView.center.y = self.containerView.frame.height - self.editImageView.frame.height/2
                            }
                            
                        }, completion: { (isCompleted) in
                            if isCompleted {
                                self.checkSignOutside()
                            }
                        })
                        
                    }
                }
            }
            
            lineFadeOut()
            
        default:
            return
        }
    }
    
    @IBAction func scaleInOut(_ sender: UIButton) {
        if(editImageView.frame.width > editImageView.frame.height){
            if(editImageView.frame.height < containerView.frame.height){
                UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    let height = self.containerView.frame.height
                    let width = height * (self.editImageView.frame.width/self.editImageView.frame.height)
                    self.editImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    self.editImageView.center = CGPoint(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2)
                    
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.checkSignOutside()
                    }
                })
                
            } else {
                
                UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    let width = self.containerView.frame.width
                    let height = width * (self.editImageView.frame.height/self.editImageView.frame.width)
                    self.editImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    self.editImageView.center = CGPoint(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2)
                    
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.checkSignOutside()
                    }
                })
                
            }
        } else if(editImageView.frame.width < editImageView.frame.height){
            if(editImageView.frame.width < containerView.frame.width){
                UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    let width = self.containerView.frame.width
                    let height = width * (self.editImageView.frame.height/self.editImageView.frame.width)
                    
                    self.editImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    self.editImageView.center = CGPoint(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2)
                    
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.checkSignOutside()
                    }
                })
            } else {
                UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    let height = self.containerView.frame.height
                    let width = height * (self.editImageView.frame.width/self.editImageView.frame.height)
                    
                    self.editImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    self.editImageView.center = CGPoint(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2)
                    
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.checkSignOutside()
                    }
                })
            }
        } else {
            UIView.animate(withDuration: 0.36, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.editImageView.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
                self.editImageView.center = CGPoint(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2)
                
            }, completion: { (isCompleted) in
                if isCompleted {
                    self.checkSignOutside()
                }
            })
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let alertController = UIAlertController(title: "Go Back", message: "Go back to Album and Signit will disapear, Are you OK?", preferredStyle: .alert)
        let installAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(installAction)
        
        let laterAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(laterAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: signIsFirst) == nil {
            signTF.layer.borderWidth = 0.0
            
            goAlbumBtn.alpha = 0.4
            goAlbumBtn.isUserInteractionEnabled = false
            subviewContainer.bringSubview(toFront: editContainer)
            editIndicator.alpha = 1.0
            optionIndicator.alpha = 0.0
            translateIndicator.alpha = 0.0
            editBtn.alpha = 1.0
            optionBtn.alpha = 0.4
            translateBtn.alpha = 0.4
            
            state = menuState[1]
            
            //op
            editable = true
            signTF.becomeFirstResponder()
        }else {
            state = menuState[0]
        }
        
       
        let img : UIImage = getImageFromAsset(asset: Asset)
        
        initEditImageView(originImg: img)
        

        initSignTF()
        drawLines()
        signTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.signTF {
            return editable
        }
        signTF.sizeToFit()
        
        return true
    }
    
    @IBAction func textFieldChange(_ sender: UITextField) {
        if sender == self.signTF {
           
            self.signTF.sizeToFit()
            self.checkSignOutside()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(state == menuState[1]){
            if signTF.text == nil || signTF.text == "" {
                ToastView.shared.showTop(duration: 1.3, self.view, text_msg: "Please sign here.")
                return
            }
   
            UserDefaults.standard.set(true, forKey: signIsFirst)
            UserDefaults.standard.set(signTF.text!, forKey: saveSignTextKey)
            
            goAlbumBtn.alpha = 1.0
            goAlbumBtn.isUserInteractionEnabled = true
            
            editIndicator.alpha = 0.0
            optionIndicator.alpha = 0.0
            translateIndicator.alpha = 0.0
            editBtn.alpha = 0.4
            optionBtn.alpha = 0.4
            translateBtn.alpha = 0.4
            view.endEditing(true)
            signTF.resignFirstResponder()
            editable = false
            subviewContainer.bringSubview(toFront: mainSignitContainer)
            state = menuState[0]
            signTF.sizeToFit()
            if containerProtocol != nil {
                containerProtocol.signitLabelChange(sign: signTF.text!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if signTF.text == nil || signTF.text == "" {
            ToastView.shared.showTop(duration: 1.3, self.view, text_msg: "Please sign here.")
            return false
        }
        
        UserDefaults.standard.set(true, forKey: signIsFirst)
        UserDefaults.standard.set(signTF.text!, forKey: saveSignTextKey)
        state = menuState[0]
        signTF.resignFirstResponder()
        editable = false
        editIndicator.alpha = 0.0
        optionIndicator.alpha = 0.0
        translateIndicator.alpha = 0.0
        editBtn.alpha = 0.4
        optionBtn.alpha = 0.4
        translateBtn.alpha = 0.4
        subviewContainer.bringSubview(toFront: mainSignitContainer)
        goAlbumBtn.alpha = 1.0
        goAlbumBtn.isUserInteractionEnabled = true
        signTF.sizeToFit()
        if containerProtocol != nil {
            containerProtocol.signitLabelChange(sign: signTF.text!)
        }
        return true
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRect.height
        
        let containerBottomY = containerView.center.y + (containerView.frame.height/2)
        
        if(containerBottomY > (self.view.frame.height - keyboardHeight)){
            self.view.frame.origin.y = -(containerBottomY - (self.view.frame.height - keyboardHeight))
            
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lineFadeOut()
    }

    override var prefersStatusBarHidden: Bool {
        if isiPhoneXScreen() {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "optionContainerSegue" {
            let view = segue.destination as? OptionTabVC
            view!.optionChangeProtocol = self
            view!.doneProtocol = self
            
        } else if segue.identifier == "transformContainerSegue" {
            let view = segue.destination as? TransformTabVC
            view!.rotateChangeProtocol = self
            view!.doneProtocol = self
        } else if segue.identifier == "signitContainerSegue" {
            let view = segue.destination as? SignitTabVC
            containerProtocol = view
            view!.signitClick = self
            
            
        } else if segue.identifier == "completeContainerSegue" {
            let view = segue.destination as? CompleteTabVC
            view!.completeClickProtocol = self
            view!.doneProtocol = self
        } else if segue.identifier == "toBlowSegue" {
            let view = segue.destination as? BlowVC
            view!.transitioningDelegate = self
            view!.dismissDataTransferProtocol = self
            view!.modalPresentationStyle = .custom
            view!.signedText = signTF.text
        }
    }
    
    //share, save click
    func instaShareClick(_ btnUI: UIButton) {
        let img : UIImage = getImageFromAsset(asset: Asset)
        let cropSizeRect: CGRect = cropImgRect(origin: img)
        let textInsertedImg = textToImage(img)
        if let cropedCGImage = textInsertedImg.cgImage?.cropping(to: cropSizeRect) {
            let cropedUIImage = UIImage(cgImage: cropedCGImage)
            
            shareOnInstagram(cropedUIImage)
            
        }
    }
    
    
    func saveImgClick(_ btnUI: UIButton) {
        
        let img : UIImage = getImageFromAsset(asset: Asset)
        let cropSizeRect: CGRect = cropImgRect(origin: img)
        let textInsertedImg = textToImage(img)
        if let cropedCGImage = textInsertedImg.cgImage?.cropping(to: cropSizeRect) {
            let cropedUIImage = UIImage(cgImage: cropedCGImage)
            
            UIImageWriteToSavedPhotosAlbum(cropedUIImage, self, #selector(imageSaveResult(_:didFinishSavingWithError:contextInfo:)), nil)
            UserDefaults.standard.set(signTF.text!, forKey: saveSignTextKey)
            
        }
        
    }
    
    func signitClick(_ btnUI: UIButton) {
        
        self.performSegue(withIdentifier: "toBlowSegue", sender: self)
        
    }
    
    func dismissed(type: Bool) {
        if type == true {
            
            subviewContainer.bringSubview(toFront: completeContainer)
            signTF.isUserInteractionEnabled = false
            editImageView.isUserInteractionEnabled = false
            containerView.isUserInteractionEnabled = false
            state = menuState[4]
            editable = false
        }
        goAlbumBtn.alpha = 1.0
        goAlbumBtn.isUserInteractionEnabled = true
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        let centerY = (UIScreen.main.bounds.height - doneBtnArea.bounds.height) + doneBtnPoint.center.y
        transition.startingPoint = CGPoint(x: UIScreen.main.bounds.width/2-1.7, y: centerY+2)
        transition.circleColor = UIColor.white
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        let centerY = (UIScreen.main.bounds.height - doneBtnArea.bounds.height) + doneBtnPoint.center.y
        transition.startingPoint = CGPoint(x: UIScreen.main.bounds.width/2-1.7, y: centerY+2)
        transition.circleColor = UIColor.white
        
        return transition
    }
    
    @objc func imageSaveResult(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error)
            ToastView.shared.show(duration: 1.6, self.view, text_msg: "ERROR!")
        } else {
            ToastView.shared.show(duration: 1.6, self.view, text_msg: "SAVED!")
            
            if UserDefaults.standard.object(forKey: signCompleteCountKey) != nil {
                var nowCount = UserDefaults.standard.integer(forKey: signCompleteCountKey)+1
                
                if nowCount == 4 {
                    if #available(iOS 10.3, *) {
                        SKStoreReviewController.requestReview()
                    }
                }
                
                if nowCount > 19 {
                    nowCount = 0
                }
                
                UserDefaults.standard.set(nowCount, forKey: signCompleteCountKey)
               
            } else {
                UserDefaults.standard.set(0, forKey: signCompleteCountKey)
            }
        
        }
    }
    
    func textToImage(_ img : UIImage) -> UIImage{
       
        let textColor = signTF.textColor!
        let textFont = UIFont(name: (signTF.font?.fontName)!, size: (signTF.font?.pointSize)! * img.size.width/editImageView.frame.width)!
        
        
        let outleft = editImageView.center.x - editImageView.frame.width/2
        let outtop = editImageView.center.y - editImageView.frame.height/2
        
        let originPointX = (signTF.center.x - outleft) - signTF.frame.width/2
        let originPointY = (signTF.center.y - outtop) - signTF.frame.height/2
   
        
        let text : NSString = NSString(string: signTF.text!)
        let textFontAttributes = [NSAttributedStringKey.font : textFont, NSAttributedStringKey.foregroundColor : textColor] as [NSAttributedStringKey : Any]
        
        UIGraphicsBeginImageContextWithOptions(text.size(withAttributes: textFontAttributes), false, 1.0)
        
        
        
        text.draw(at: CGPoint.zero, withAttributes: textFontAttributes)
        
        let rotatedTextImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let radian = atan2f(Float(signTF.transform.b), Float(signTF.transform.a))
        let okImg = rotateImg(radians: CGFloat(-radian), img: rotatedTextImg)
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, 1.0)
        
        let rect = CGRect(origin: CGPoint(x: originPointX * img.size.width/editImageView.frame.width, y: originPointY * img.size.width/editImageView.frame.width), size: CGSize(width: signTF.frame.width * img.size.width/editImageView.frame.width, height: signTF.frame.height * img.size.height/editImageView.frame.height))
        
        img.draw(in: CGRect(origin: CGPoint.zero, size: img.size))
        
        okImg.draw(in: rect)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return newImg!
    }
    
    func rotateImg(radians : CGFloat, img : UIImage) -> UIImage{
        
        let cgImage = img.cgImage!
        let LARGEST_SIZE = CGFloat(max(img.size.width, img.size.height))
        let context = CGContext.init(data: nil, width: Int(LARGEST_SIZE), height: Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = img.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - img.size.width) * 0.5, y: (LARGEST_SIZE - img.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        
        return resultImage
    }
    
    func cropImgRect(origin : UIImage) -> CGRect{
      
        let outleft = abs(editImageView.center.x - editImageView.frame.width/2)
        let outright = abs(containerView.frame.width - (editImageView.center.x + editImageView.frame.width/2))
        let outtop = abs(editImageView.center.y - editImageView.frame.height/2)
        let outbottom = abs(containerView.frame.height - (editImageView.center.y + editImageView.frame.height/2))
        
        //Img width > height
        if(origin.size.width > origin.size.height){
            
            //not scaled origin size
            if(editImageView.frame.width <= containerView.frame.width){
                return CGRect(x: 0, y: 0, width: origin.size.width, height: origin.size.height)
            } else {    //scaled
                //scaled but height < frame
                if(editImageView.frame.height < containerView.frame.height){
                    let x = (origin.size.width*outleft)/editImageView.frame.width
                    let width = (((editImageView.frame.width - outright)*origin.size.width)/editImageView.frame.width)-x
                    return CGRect(x: x, y: 0, width: width, height: origin.size.height)
                } else {    //scaled
                    let x = (origin.size.width*outleft)/editImageView.frame.width
                    let width = (((editImageView.frame.width - outright)*origin.size.width)/editImageView.frame.width)-x
                    let y = (origin.size.height*outtop)/editImageView.frame.height
                    let height = (((editImageView.frame.height - outbottom)*origin.size.height)/editImageView.frame.height)-y
                    return CGRect(x: x, y: y, width: width, height: height)
                }
            }
            
        } else {
            if(editImageView.frame.height <= containerView.frame.height){
                return CGRect(x: 0, y: 0, width: origin.size.width, height: origin.size.height)
            } else {
                
                if(editImageView.frame.width < containerView.frame.width){
                    let y = (origin.size.height*outtop)/editImageView.frame.height
                    let height = (((editImageView.frame.height - outbottom)*origin.size.height)/editImageView.frame.height) - y
                    
                    return CGRect(x: 0, y: y, width: origin.size.width, height: height)
                    
                } else {
                    let x = (origin.size.width*outleft)/editImageView.frame.width
                    let width = (((editImageView.frame.width - outright)*origin.size.width)/editImageView.frame.width)-x
                    let y = (origin.size.height*outtop)/editImageView.frame.height
                    let height = (((editImageView.frame.height - outbottom)*origin.size.height)/editImageView.frame.height) - y
                    
                    return CGRect(x: x, y: y, width: width, height: height)
                    
                }
                
            }
        }
        
    }
    
    //transform
    func leftRotateClick(isIn: Bool) {
        if isIn {
            if let timer = rotateTimer {
                if !timer.isValid {
                    rotateTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (t) in
                        
                        self.signTF.transform = self.signTF.transform.rotated(by: CGFloat.pi/180)
                        
                    })
                }
            } else {
                rotateTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (t) in
                   
                    self.signTF.transform = self.signTF.transform.rotated(by: CGFloat.pi/180)
                    
                })
            }
        } else {
            if let timer = rotateTimer {
                if(timer.isValid){
                    timer.invalidate()
                }
            }
        }
    }
    
    func rightRotateClick(isIn: Bool) {
        if isIn {
            if let timer = rotateTimer {
                if !timer.isValid {
                    rotateTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (t) in
                        
                        self.signTF.transform = self.signTF.transform.rotated(by: -CGFloat.pi/180)
                        
                        
                    })
                }
            } else {
                rotateTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (t) in
                    
                    self.signTF.transform = self.signTF.transform.rotated(by: -CGFloat.pi/180)
                   
                    
                })
            }
        } else {
            if let timer = rotateTimer {
                if(timer.isValid){
                    timer.invalidate()
                }
            }
        }
    }
    
    func centerRotateClick() {
        
        count = count + 1
        
        if(count > 3){
            count = 0
        }
        
        UIView.animate(withDuration: 0.16, animations: {
            
            self.signTF.transform = CGAffineTransform(rotationAngle: CGFloat(self.count)*(CGFloat.pi/2))
            
        }, completion: { isComplete in
            
        })
    
    }
    
    //option change
    func changeSize(size: Float) {
        let sizeScale = containerView.bounds.width / 320.0
        
        switch (size){
        case 1 :
            signTF.font = UIFont(name: (signTF.font?.fontName)!, size: 11.0 * sizeScale)
            
        case 2 :
            signTF.font = UIFont(name: (signTF.font?.fontName)!, size: 13.0 * sizeScale)
        case 3 :
            signTF.font = UIFont(name: (signTF.font?.fontName)!, size: 21.0 * sizeScale)
        case 4 :
            signTF.font = UIFont(name: (signTF.font?.fontName)!, size: 28.0 * sizeScale)
            
        case 5 :
            signTF.font = UIFont(name: (signTF.font?.fontName)!, size: 43.0 * sizeScale)
            
        case 6 :
            signTF.font = UIFont(name: (signTF.font?.fontName)!, size: 64.0 * sizeScale)
            
        default :
            break
        }
        signTF.sizeToFit()
        
        self.checkSignOutside()
    }
    
    func changeColor(color: Float) {
        
        signTF.textColor = UIColor(red: (CGFloat(1.0-color)), green: (CGFloat(1.0-color)), blue: (CGFloat(1.0-color)), alpha: 1.0)
    }
    
    func isiPhoneXScreen() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        
        return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
    }
    
    func getImageFromAsset(asset: PHAsset) -> UIImage{
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        
        option.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in image = result!
        })
        
        return image
    }
    
    func initSignTF(){
        
        if let signText = UserDefaults.standard.string(forKey: saveSignTextKey){
            print(signText)
            signTF.text = signText
        } else {
            if UserDefaults.standard.object(forKey: signIsFirst) == nil {
                signTF.text = ""
            }
            
        }
        
        let sizeScale = containerView.bounds.width / 320.0
        signTF.font = UIFont(name: (signTF.font?.fontName)!, size: 13.0 * sizeScale)
        signTF.sizeToFit()
        if UserDefaults.standard.object(forKey: signIsFirst) == nil {
            signTF.center = CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2)
        } else {
            signTF.center = CGPoint(x: containerView.frame.width - signTF.frame.width/2 - (containerView.frame.width * 0.04), y: containerView.frame.height - signTF.frame.height - (containerView.frame.height * 0.02))
        }
        
        
        if containerProtocol != nil {
            containerProtocol.signitLabelChange(sign: signTF.text!)
        }
    }
    
    func initEditImageView(originImg : UIImage){
        
        let img = originImg
        
        let width: CGFloat
        let height: CGFloat
        
        if img.size.width > img.size.height {
            height = containerView.frame.height
            width = height * (img.size.width/img.size.height)
            
        } else {
            width = containerView.frame.width
            height = width * (img.size.height/img.size.width)
        }
        let imgSize = CGSize(width: width, height: height)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: imgSize)
        
        let result = renderer.image { (ctx) in
            UIColor.white.set()
            ctx.fill(rect)
            
            img.draw(in: rect, blendMode: .normal, alpha: 1)
        }
 
        editImageView.image = result
        editImageView.sizeToFit()
        
        editImageView.center = CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2)
        
        
    }
    
    func drawLines() {
        UIGraphicsBeginImageContext(lineImg.frame.size)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setLineWidth(1.0)
        ctx.setStrokeColor(UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1).cgColor)
        
        ctx.move(to: CGPoint(x: lineImg.frame.width/3, y: 0))
        ctx.addLine(to: CGPoint(x: lineImg.frame.width/3, y: lineImg.frame.height))
        ctx.strokePath()
        
        ctx.move(to: CGPoint(x: (lineImg.frame.width/3)*2, y: 0))
        ctx.addLine(to: CGPoint(x: (lineImg.frame.width/3)*2, y: lineImg.frame.height))
        ctx.strokePath()
        
        ctx.move(to: CGPoint(x: 0, y: lineImg.frame.height/3))
        ctx.addLine(to: CGPoint(x: lineImg.frame.width, y: lineImg.frame.height/3))
        ctx.strokePath()
        
        ctx.move(to: CGPoint(x: 0, y: (lineImg.frame.height/3)*2))
        ctx.addLine(to: CGPoint(x: lineImg.frame.width, y: (lineImg.frame.height/3)*2))
        ctx.strokePath()
        
        lineImg.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func lineFadeIn(){
        lineImg.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.lineImg.alpha = 1.0
        }
    }
    
    func lineFadeOut(){
        lineImg.alpha = 1.0
        UIView.animate(withDuration: 0.3, delay: 0.9, options: UIViewAnimationOptions.curveLinear, animations: {
            self.lineImg.alpha = 0.0
        }, completion: nil)
        
    }
}


extension EditViewController: UIDocumentInteractionControllerDelegate {
    func shareOnInstagram(_ photo: UIImage) {
        let instagramUrl = URL(string: "instagram://app")!
        
        if UIApplication.shared.canOpenURL(instagramUrl) {
            let imageData = UIImageJPEGRepresentation(photo, 1.0)!
            
            let writePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("instagram.igo")
            do {
                try imageData.write(to: writePath)
                documentsInteractionsController = UIDocumentInteractionController(url: writePath)
                documentsInteractionsController.delegate = self
                documentsInteractionsController.uti = "com.instagram.exclusivegram"
                documentsInteractionsController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
                
            }catch {
                return
            }
        } else {
            let alertController = UIAlertController(title: "Install Instagram", message: "You need Instagram app installed to use this feature. Do you want to install it now?", preferredStyle: .alert)
            let installAction = UIAlertAction(title: "Install", style: .default, handler: { (action) in
                let redirectURL = URL.init(string: "http://itunes.apple.com/app/id389801252?mt=8")!
                UIApplication.shared.open(redirectURL, options: [:], completionHandler: nil)
            })
            alertController.addAction(installAction)
            
            let laterAction = UIAlertAction(title: "Later", style: .cancel, handler: nil)
            alertController.addAction(laterAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}


protocol ContainerProtocol {
    func signitLabelChange(sign : String)
}
