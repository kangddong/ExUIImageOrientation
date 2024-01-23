//
//  ViewController.swift
//  colltest
//
//  Created by dongyeongkang on 2022/07/27.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var fixImageColletionView: UICollectionView!
    
    private let picker = UIImagePickerController()
    
    private var imageList: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        configCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(UIScreen.main.bounds.width) UIScreen.main.bounds.width")
        print("didappear")
        openLibrary()
    }
    
    func initUI() {
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        imageCollectionView.collectionViewLayout = flowLayout
        imageCollectionView.layer.borderWidth = 1
        imageCollectionView.layer.borderColor = UIColor.blue.cgColor
        
        fixImageColletionView.collectionViewLayout = flowLayout
        fixImageColletionView.layer.borderWidth = 1
        fixImageColletionView.layer.borderColor = UIColor.blue.cgColor
    }
    
    
    func configCollectionView() {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.clipsToBounds = false
        imageCollectionView.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
        
        fixImageColletionView.dataSource = self
        fixImageColletionView.delegate = self
        fixImageColletionView.clipsToBounds = false
        fixImageColletionView.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
    }
    
    func converImageToData(image: UIImage?, type: String) {
        guard let image = image else { return }
        
        var convertImage: Data? = nil
        
        switch type {
        case "png":
            convertImage = image.pngData()
        case "jpeg":
            convertImage = image.jpegData(compressionQuality: 1)
        default:
            NSLog("Unknown img Type", "%@")
            return
        }
        
        if let imageData = convertImage {
            if imageData.count > 10485760 {
                let resizeImage = resizeImage(image: image, newWidth: 300)
                
                switch type {
                case "png":
                    convertImage = resizeImage.pngData()
                case "jpeg":
                    convertImage = resizeImage.jpegData(compressionQuality: 1)
                default:
                    NSLog("Unknown img Type", "%@")
                    return
                }
            }
        }
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(convertImage!.count))
        NSLog("convertImage count = \(string)", "%@")
        
        insertImageList(image: image)
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func insertImageList(image: UIImage) {
        if imageList.count == 4 {
            self.imageList.removeLast()
        }
        
        imageCollectionView.reloadData()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        guard let convertedCell =  cell as? ImageCell else { return cell }
        let tupleItem = imageList[indexPath.row]
        
        DispatchQueue.main.async {
            convertedCell.image.image = tupleItem
        }
        
        return convertedCell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    //cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (imageCollectionView.frame.width - 24 - 32) / 3 ///  3등분
        let size = CGSize(width: width, height: width)
        print("cell하나당 width=\(width)")
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 사진을 ImageRotateViewController 부분에서  .fixOrientation() 분기
        var image: UIImage?
        if collectionView == imageCollectionView {
            image = imageList[indexPath.row]
        } else {
            image = imageList[indexPath.row]?.fixOrientation()
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ImageRotateViewController") as? ImageRotateViewController else { return }
        
        DispatchQueue.main.async {
            vc.testImageview.image = image
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}



// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var uploadImage: UIImage? = nil
        
        if let selectedImage = info[.editedImage] as? UIImage {
            uploadImage = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            uploadImage = selectedImage
        }
        
        imageList.append(uploadImage)
        
        imageCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openLibrary() {
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            if authStatus == AVAuthorizationStatus.denied {
                
                let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                    guard let nsUrl = NSURL(string: UIApplication.openSettingsURLString) else { return }
                    let url = nsUrl as URL
                    UIApplication.shared.openURL(url)
                }
                let cancelDefault = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelDefault)
                
                self.present(alert, animated: true, completion: nil)
                
            } else if authStatus == AVAuthorizationStatus.notDetermined {
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        DispatchQueue.main.async {
                            self.picker.sourceType = .camera
                            self.present(self.picker, animated: true, completion: nil)
                        }
                    }
                })
            } else {
                
                picker.sourceType = .camera
                present(picker, animated: true, completion: nil)
            }
        } else {
            NSLog("Camera Can't use", "%@")
        }
    }
}

