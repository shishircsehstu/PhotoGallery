//
//  NetworkManager.swift
//  FetchDataFromAPI
//

import Foundation
import UIKit
import AVFoundation
import Photos

class NetworkManager{
    
    static var cache = NSCache<AnyObject, UIImage>()
    static var share = NetworkManager()
    private init(){}
    
    var urlsArray = [DownloadImagesUrl]()
    
    func getImageInfoFromAPI(completion: @escaping ( [DownloadImagesUrl], Bool?) -> ()){
        
        let urlStr = "https://picsum.photos/v2/list?page=2&limit=100"
        
       // print("API Url::",urlStr )
        
        let session = URLSession.shared
        guard let url = URL(string: urlStr) else {
            return
        }
        session.dataTask(with: url) { (data, response, err) in
            guard let data = data else{return}
            
            do{
                let urls  = try JSONDecoder().decode([DownloadImagesUrl].self, from: data)
                
                for itm in urls{
                    self.urlsArray.append(itm)
                }
                completion(self.urlsArray, true)
                
            }
            catch let jeerr
            {
                print(jeerr.localizedDescription)
            }
        }.resume()
        
    }
    
    
    func downloadImage(imgURL: URL, completion: @escaping (UIImage?)->()){
        
        if let cachedImage = NetworkManager.cache.object(forKey: imgURL as AnyObject) {
            print("You get image from cache")
            completion(cachedImage)
            
        }else{
            URLSession.shared.dataTask(with: imgURL) { (data, respnse, error) in
                if let error = error {
                    print("Error: \(error)")
                    
                }else if let data = data {
                    
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        
                        if let img = image{
                            NetworkManager.cache.setObject(img, forKey: imgURL as AnyObject)
                            print("You get image from \(imgURL)")
                            completion(img)
                        }else{
                            completion(nil)
                        }
                    }
                }
            }.resume()
        }
    }
    deinit {
        
        print("Deinit NetworkManager")
    }
}

