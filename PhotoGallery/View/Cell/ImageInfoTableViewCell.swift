//
//  ImageInfoTableViewCell.swift
//  FetchDataFromAPI
//
// Created by Md Saddam Hossain on 04/06/22.
//

import UIKit

class ImageInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var imgInfoTextView: UITextView!
    
    var singleImgInfo: allImagesUrl?{
        didSet{
            
            setImgProperties()
            
        }
    }
    
    
    @IBOutlet weak var itmImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    func setImgProperties(){
        
//        if let text = singleImgInfo?.user.bio{
//            imgInfoTextView.text = text
//        }else{
//            imgInfoTextView.text = "No info"
//        }
        
        let strUrl = singleImgInfo?.download_url
        if let strUrl = strUrl{
            let url = URL(string: strUrl)
            
            NetworkManager.share.downloadImage(imgURL: url!) { (img) in
                
                if let img = img{
                    self.itmImage.image = img
                }else{
                    self.itmImage.image = UIImage(named: "bird")
                }
                
            }
        }else{
            self.itmImage.image = UIImage(named: "bird")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
