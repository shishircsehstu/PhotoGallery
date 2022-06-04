//
//  ImageCollectionViewCell.swift

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageOutlet: UIImageView!
    
    var singleImgInfo: allImagesUrl?{
        didSet{
            
            setImgProperties()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImgProperties(){
        
        let strUrl = singleImgInfo?.download_url
        if let strUrl = strUrl{
            let url = URL(string: strUrl)
            NetworkManager.share.downloadImage(imgURL: url!) { (img) in
                
                if let img = img{
                    self.itemImageOutlet.image = img
                    self.tag = 1
                }else{
                    self.itemImageOutlet.image = UIImage(named: "bird")
                    
                }
            }
        }else{
            self.itemImageOutlet.image = UIImage(named: "bird")
            
        }
    }
}
