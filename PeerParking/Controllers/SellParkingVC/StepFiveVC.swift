//
//  StepFiveVC.swift
//  PeerParking
//
//  Created by Apple on 30/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class StepFiveVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var text_view: UITextView!
    @IBOutlet weak var img_height_constr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        text_view.delegate = self
        text_view.text = "Add some usefull information"
        text_view.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
        let placeHolderImage = UIImage(named: "placeholder-img")
        
        img_height_constr.constant = 0
        
        guard let imageData = placeHolderImage?.jpegData(compressionQuality: 1.0) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(imageData, forKey: "image")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.isEmpty){
            textView.text = "Add some usefull information"
            textView.textColor = UIColor.lightGray
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue("", forKey: "note")
        }
        else{
            
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue((textView.text)!, forKey: "note")
        }
        
        print("heee=\(textView.text)")
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tab_index = 2
        print("::--=viewWillAppear|Five")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("::--=viewWillDisappear|Five")
    }

    @IBAction func open_cam_btn(_ sender: UIButton) {
        print("cam")
       
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.mediaTypes = ["public.image"]
//        present(imagePickerController, animated: true, completion: nil)
//        showAlert()
//        showAlert()
        self.getImage(fromSourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        //        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        print("MEDIA-URL=\(UIImagePickerController.InfoKey.mediaMetadata)")

       // dismissPicker(picker: picker, img:img!)
        picker.self.dismiss(animated: true){
            self.img_height_constr.constant = 141
            self.img.image = img
        }
        
        //let imgData =  img!.jpegData(compressionQuality: 1.0)
        
        guard let imageData = img?.jpegData(compressionQuality: 1.0) else {
            print("Could not get JPEG representation of UIImage")
            return
        }

        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(imageData, forKey: "image")
        
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
            imagePickerController.modalPresentationStyle = .fullScreen
//            addChild(imagePickerController)
//            view.addSubview(imagePickerController.view)
            self.navigationController? .present(imagePickerController, animated: true, completion: nil)
        }
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
//
//        print("::--=cancel")
//        self.dismiss(animated: true, completion: nil)
//
//    }

}
