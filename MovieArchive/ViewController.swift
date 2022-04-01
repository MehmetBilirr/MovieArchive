//
//  ViewController.swift
//  MovieArchive
//
//  Created by Mehmet Bilir on 1.04.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var idArray = [UUID]()
    var selectedMovie = ""
    var selectedMovieId : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add button 
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
    
        getData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenMovie = selectedMovie
            destinationVC.chosenMovieId = selectedMovieId
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = nameArray[indexPath.row]
        selectedMovieId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    @objc func addButtonClicked(){
        selectedMovie = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    
    
    @objc func getData(){
        nameArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            
            let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String{
                            self.nameArray.append(name)
                        }
                        if let id = result.value(forKey: "id") as? UUID{
                            self.idArray.append(id)
                        }
                        self.tableView.reloadData()
                        
                    }
                }
        }catch{
            print("error")
        }
        }
    
            


}

