//
//  ImageUrlViewModel.swift
//  PhotoGallery
//
//  Created by Md Saddam Hossain on 4/6/22.


import Foundation
struct ImageUrlViewModel{
    
    let imgUrl: String?
    
    init(url: DownloadImagesUrl){
        imgUrl = url.download_url
    }
    
}
