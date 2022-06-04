//
//  HomeViewController.swift
//  PhotoGallery
//
//  Created by Saddam Hossain on 2/6/22.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var cellSpace = Double(2)
    
    var imageInfoArray = [allImagesUrl](){
        didSet{
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
    }
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        navigationController?.navigationBar.isHidden = true
        imageCollectionView.dataSource = self
        imageCollectionView.delegate  = self
        fetchAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageCollectionView.reloadData()
    }
    
    
    //MARK: - Retain Cycle check
    deinit {
        
        print("Memory released for Data VC")
    }
}

extension HomeViewController{
    
    func fetchAPI(){
        
        NetworkManager.share.getImageInfoFromAPI { [weak self] (allInfos, finished) in
            
            self!.imageInfoArray = allInfos
        }
        
    }
}

//MARK: - CollectionViewDataSource Method

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let strUrl =  imageInfoArray[indexPath.row].download_url
        
        if let strUrl = strUrl{
            
            let url = URL(string: strUrl)!
            //  cell.itemImageOutlet.kf.indicatorType = .activity
            //cell.itemImageOutlet.kf.setImage(with: url)
            
            
            
            let processor = DownsamplingImageProcessor(size: cell.itemImageOutlet.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
            
            cell.itemImageOutlet.kf.indicatorType = .activity
            cell.itemImageOutlet.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
            
            /*
             NetworkManager.share.downloadImage(imgURL: url) {[weak self] (img) in
             
             DispatchQueue.main.async {
             cell.itemImageOutlet.image = img
             }
             }
             */
        }
        
        return cell
    }
    
}
extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let zoomVc = UIStoryboard(name: "Zoom", bundle: nil).instantiateViewController(withIdentifier: "ZoomViewController") as? ZoomViewController else {return}
        zoomVc.imageUrl =   URL(string: imageInfoArray[indexPath.row].download_url!)
        navigationController?.pushViewController(zoomVc, animated: true)
        
    }
}

//MARK: - CollectionView Flow Layout

extension HomeViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width  = Int(imageCollectionView.frame.size.width/3)-Int(cellSpace)
        
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellSpace)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellSpace)
    }
}