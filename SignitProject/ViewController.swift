

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, PermissionCompleteProtocol{

    var pageVC : UIPageViewController!
    
    var currentIndex : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPermissionAllOk() {
            self.performSegue(withIdentifier: "toPickAndEdit", sender: nil)
            return
        }
        
        pageVC = self.storyboard?.instantiateViewController(withIdentifier: "pageVC") as! UIPageViewController
        
        pageVC.dataSource = self
        
        let startVC = self.vcAtIndex(index: 0) as DescVC
        
        let viewControllers = NSArray(object: startVC)
        
        pageVC.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        pageVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.addChildViewController(pageVC)
        self.view.addSubview(pageVC.view)
        
        
    }
    
    func isPermissionAllOk () -> Bool {
       
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            return true
        }
        
        return false
    }
    
    func permissionAllOK() {
        self.performSegue(withIdentifier: "toPickAndEdit", sender: nil)
    }
    
    func vcAtIndex ( index : Int ) -> DescVC {
        var vc : DescVC!
        if index == 0 {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "desc1") as! DescVC
        } else if index == 1 {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "desc2") as! DescVC
        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "desc3") as! DescVC
            /*
            if AVAudioSession.sharedInstance().recordPermission() == AVAudioSessionRecordPermission.granted {
                vc.micAllowed = true
            }*/
            
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
               vc.photoAllowed = true
            }
        }
        vc.permissionProtocol = self
        vc.index = index
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! DescVC
        var index = vc.index as Int
        
        if ( index == 0 || index == NSNotFound){
            return nil
        }
        
        index = index - 1
        
        return self.vcAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! DescVC
        var index = vc.index as Int
        
        if ( index == NSNotFound){
            return nil
        }
        
        index = index + 1
        
        if ( index == 3){
            return nil
        }
        
        return self.vcAtIndex(index: index)
        
    }
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

