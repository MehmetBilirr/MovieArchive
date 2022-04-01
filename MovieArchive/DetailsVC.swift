//
//  DetailsVC.swift
//  MovieArchive
//
//  Created by Mehmet Bilir on 1.04.2022.
//

import UIKit
import CoreData

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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context)
        newMovie.setValue(movieName.text, forKey: "name")
        if let newYear = Int(year.text!){
            newMovie.setValue(newYear, forKey: "year")
            
        }
        if let imdb = Double(imdbRating.text!){
            newMovie.setValue(imdb, forKey: "imdb")
            
        }
        newMovie.setValue(director.text, forKey: "director")
        newMovie.setValue(UUID(), forKey: "id")
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newMovie.setValue(data, forKey: "image")
        self.navigationController?.popViewController(animated: true)
        do{
            try context.save()
            print("success")
        }catch{
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
    }
    
   

}
