//
//  StepFiveVC.swift
//  PeerParking
//
//  Created by Apple on 30/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class StepFiveVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tab_index = 2
        // Do any additional setup after loading the view.
    }
    

    @IBAction func open_cam_btn(_ sender: UIButton) {
        print("cam")
       
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.mediaTypes = ["public.image"]
//        present(imagePickerController, animated: true, completion: nil)
//        showAlert()
        
        self.getImage(fromSourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        //        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        print("MEDIA-URL=\(UIImagePickerController.InfoKey.mediaMetadata)")

//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellParkingVC") as? SellParkingVC
//       // let vc = storyboard!.instantiateViewController(withIdentifier: "SellParkingVC") as? SellParkingVC
//
//        vc?.counter = 5
//        self.showDetailViewController(vc!, sender: nil)

       // dismissPicker(picker: picker, img:img!)
        picker.self.dismiss(animated: true){
            self.img.image = img
        }
//        picker.dismiss(animated: true){
//            self.img.image = img
//        }
        
       // image = img!.pngData()
    }
    
    private func dismissPicker(picker : UIImagePickerController, img:UIImage){
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
         self.img.image = img
        
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        UIApplication.shared.isStatusBarHidden = false
    }
    
    //Show alert
    func showAlert() {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
//            addChild(imagePickerController)
//            view.addSubview(imagePickerController.view)
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

}
