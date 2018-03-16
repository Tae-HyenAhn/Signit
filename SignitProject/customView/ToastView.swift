import Foundation
import UIKit

open class ToastView: UILabel {
    
    var overlayView = UIView()
    var backView = UIView()
    var lbl = UILabel()
    var lock : Bool! = false
    
    class var shared: ToastView {
        struct Static {
            static let instance: ToastView = ToastView()
        }
        return Static.instance
    }
    
    func setUp(_ view: UIView, text_msg: String, isTop: Bool){
        let white = UIColor ( red: 1/255, green: 0/255, blue:0/255, alpha: 0.0 )
        
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        backView.center = view.center
        backView.backgroundColor = white
        view.addSubview(backView)
        
        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60  , height: 50)
        if isTop == true {
            
            overlayView.center = CGPoint(x: view.bounds.width / 2, y: -self.overlayView.bounds.height/2)
        } else {
            overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height + self.overlayView.bounds.height/2)
        }
        
        overlayView.backgroundColor = UIColor.black
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 6
        overlayView.alpha = 1.0
        
        lbl.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 50)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.white
        lbl.center = overlayView.center
        lbl.text = text_msg
        lbl.textAlignment = .center
        lbl.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(lbl)
        
        view.addSubview(overlayView)
    }
    
    open func show(duration: TimeInterval,_ view: UIView, text_msg: String){
        if lock == false {
            lock = true
            self.setUp(view, text_msg: text_msg, isTop: false)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.overlayView.center.y = view.bounds.height - 40
                
            }) { (true) in
                UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                    self.overlayView.center.y = view.bounds.height + self.overlayView.bounds.height/2
                }, completion: { (true) in
                    DispatchQueue.main.async(execute: {
                        self.overlayView.center.y = view.bounds.height + self.overlayView.bounds.height/2
                        
                        self.lbl.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.backView.removeFromSuperview()
                        self.lock = false
                    })
                })
            }
        }
        
 
    }
    
    open func showTop(duration: TimeInterval,_ view: UIView, text_msg: String){
        if lock == false {
            lock = true
            self.setUp(view, text_msg: text_msg, isTop: true)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.overlayView.center.y = 40
                
            }) { (true) in
                UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                    self.overlayView.center.y = -self.overlayView.bounds.height/2
                }, completion: { (true) in
                    DispatchQueue.main.async(execute: {
                        self.overlayView.center.y = -self.overlayView.bounds.height/2
                        
                        self.lbl.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.backView.removeFromSuperview()
                        self.lock = false
                    })
                })
            }
        }
        
        
    }
    
    open func show(duration: TimeInterval,_ view: UIView, text_msg: String, complete: @escaping () -> Void){
        if lock == false {
            lock = true
            self.setUp(view, text_msg: text_msg, isTop: false)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.overlayView.center.y = view.bounds.height - 40
                
            }) { (true) in
                UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                    self.overlayView.center.y = view.bounds.height + self.overlayView.bounds.height/2
                }, completion: { (true) in
                    DispatchQueue.main.async(execute: {
                        self.overlayView.center.y = view.bounds.height + self.overlayView.bounds.height/2
                        
                        self.lbl.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.backView.removeFromSuperview()
                        self.lock = false
                    })
                    complete()
                })
            }
        }
        
        
    }
    

}
