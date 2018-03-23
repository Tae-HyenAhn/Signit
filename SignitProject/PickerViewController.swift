
import UIKit
import Photos
import PhotosUI
import MobileCoreServices

class PickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var allPhotos: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageGrid: UICollectionView!
    
    @IBOutlet weak var topArea: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shadowTopArea()
        fetchAllPhotos()
        
    }
    
    @IBAction func optionBtnClick(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK - CollectionView Function
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCell
        
        let asset = allPhotos.object(at: indexPath.item)
        
        Cell.representedAssetIdentifier = asset.localIdentifier
        Cell.layer.cornerRadius = 4
        
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: {
            image, _ in if Cell.representedAssetIdentifier == asset.localIdentifier {
                Cell.cellImage.image = image
            }
        })
        
        return Cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = allPhotos.object(at: indexPath.item)
        self.performSegue(withIdentifier: "toEdit", sender: asset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = imageGrid.frame.width * (135/320)
        let height : CGFloat = width * (129/135)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineHeight : CGFloat = imageGrid.frame.width * 0.05
        return lineHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spacing : CGFloat = imageGrid.frame.width * 0.05
        return spacing
    }
    
    func fetchAllPhotos() {
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        
        if self.allPhotos.count > 0 {
            self.view.bringSubview(toFront: imageStackView)
            self.imageGrid?.reloadData()
        } else {
            let initImage: UIImage = UIImage(named: "initImage")!
            UIImageWriteToSavedPhotosAlbum(initImage, self, #selector(initImageSaveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
            
        }
        
    }
    
    @objc func initImageSaveCompleted(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        fetchAllPhotos()
    
    }
    
    
    func shadowTopArea() {
        topArea.layer.masksToBounds = false
        topArea.layer.shadowColor = UIColor.black.cgColor
        topArea.layer.shadowOpacity = 0.4
        topArea.layer.shadowOffset = CGSize(width: 0, height: 0.7)
        topArea.layer.shadowRadius = 0.4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let editViewController = segue.destination as! EditViewController
            editViewController.Asset = sender as! PHAsset
        } else if segue.identifier == "toOption" {
            
            
        }
    }
    
}

class MainCell : UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    var representedAssetIdentifier: String!
}
