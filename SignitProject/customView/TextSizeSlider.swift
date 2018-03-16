
import UIKit

@IBDesignable
class TextSizeSlider: UISlider {
    
    @IBInspectable var trackHeight : CGFloat = 0.0
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }

}
