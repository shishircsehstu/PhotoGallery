//
//  ZoomViewController.swift
//  FetchDataFromAPI
//

import UIKit
import Zoomy
import ProgressHUD
import Kingfisher
import Photos

class ZoomViewController: UIViewController {
    var imageUrl: URL?
    var saveImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        zoomImage()
    }
    
    
    //MARK: - Retain Cycle check
    deinit {
        
        print("Memory released for Zoom VC")
    }
    
    
    //MARK: - View Actions
    
    func zoomImage(){
        
        if let url = imageUrl{
            
            ProgressHUD.show("Loading..")
            
            KingfisherManager.shared.retrieveImage(with: url) { result in
                let image = try? result.get().image
                if let image = image {
                    self.saveImage = image
                    self.imageView.image = image
                    self.addZoombehavior(for: self.imageView)
                    ProgressHUD.dismiss()
                }
            }
            
            /*
             
             NetworkManager.share.downloadImage(imgURL: url) { (img) in
             DispatchQueue.main.async {
             
             self.saveImage = img
             self.imageView.image = img
             self.addZoombehavior(for: self.imageView)
             
             ProgressHUD.dismiss()
             }
             }
             
             */
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        ProgressHUD.dismiss()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveImageAction(_ sender: Any){
        checkPhotoLibraryPermission()
        // savePhoto()
    }
    
    @IBAction func shareImageAction(_ sender: Any){
        shareImage()
    }
    
    func savePhoto(){
        
        if let saveImg = saveImage{
            
            UIImageWriteToSavedPhotosAlbum(saveImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
        }
        else {
            
            print("Saved..")
            ProgressHUD.showSucceed("Saved")
        }
    }
    
    func shareImage() {
        
        var objectsToShare = [AnyObject]()
        if let img = saveImage{
            
            objectsToShare.append(img)
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
            
        }
        
    }
}
//MARK: - Permission check

extension ZoomViewController{
    
    func checkPhotoLibraryPermission() {
        
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    self.savePhoto()
                    break
                case .limited:
                    
                    self.savePhoto()
                    print("limited access granted")
                    break
                case .denied, .restricted:
                    self.givePermissionForVideoLibrary()
                    break
                default:
                    print("Unknown")
                    
                }
            }
        } else {
            
            // Fallback on earlier versions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                
                case .authorized:
                    self.savePhoto()
                    break
                case .limited:
                    self.savePhoto()
                    break
                case .denied, .notDetermined, .restricted:
                    self.givePermissionForVideoLibrary()
                    break
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    func givePermissionForVideoLibrary(){
        
        OperationQueue.main.addOperation() {
            
            let alert = UIAlertController(title: "Permission Required", message: "This app requires access to your photos library. Please allow it on settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
}
