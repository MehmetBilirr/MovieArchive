//
//  DetailsVC.swift
//  MovieArchive
//
//  Created by Mehmet Bilir on 1.04.2022.
//

import UIKit

class DetailsVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieName: UITextField!
    @IBOutlet weak var imdbRating: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var director: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        // Image recognizer
        imageView.isUserInteractionEnabled = true
        let gestureImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureImageRecognizer)
        
    }
    
    @objc func hideKeyboard(){
        
        view.endEditing(true)
        
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
   

}
