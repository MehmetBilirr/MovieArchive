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
    var chosenMovie = ""
    var chosenMovieId : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        // Image recognizer
        imageView.isUserInteractionEnabled = true
        let gestureImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureImageRecognizer)
        
        
        if chosenMovie != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
            fetchRequest.returnsObjectsAsFaults = false
            let idString = chosenMovieId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        
                        if let name = result.value(forKey: "name") as? String {
                            self.movieName.text = name
                        }
                        if let yeartext = result.value(forKey: "year") as? Int{
                            self.year.text = String(yeartext)
                        }
                        if let directorname = result.value(forKey: "director") as? String{
                            self.director.text = directorname
                        }
                        if let imdb = result.value(forKey: "imdb") as? Double {
                            self.imdbRating.text = String(imdb)
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            self.imageView.image = image
                        }
                    }
                }
            }catch{
                print("error")
            }
            
        }
        
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
