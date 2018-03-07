//
//  TableViewController.swift
//  check-list
//
//  Created by Rachel Ng on 1/22/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, AddViewControllerDelegate {
    
    var storedData: [Tasks] = [Tasks]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndReload()
        print(storedData.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addViewController = segue.destination as! AddViewController
        addViewController.delegate = self
        if let theItem = sender as? Tasks {
            addViewController.itemToEdit = sender as? Tasks
        }
    }

    // MARK: Delegate
    func addItem(by contoller: UIViewController, title: String?, descriptions: String?, due_date: Date?, status: Bool?, didEdit: Tasks?) {
        
        navigationController?.popViewController(animated: true)
        
        if let editedItem = didEdit {
            editedItem.title = title
            editedItem.descriptions = descriptions
            editedItem.due_date = due_date
        } else {
            let taskToBeAdded = Tasks(context: managedObjectContext)
            taskToBeAdded.title = title
            taskToBeAdded.descriptions = descriptions
            taskToBeAdded.due_date = due_date
        }
        saveData()
        dismiss(animated: true, completion: saveData)
    }
    
    // MARK: CoreData
    func fetchAndReload() {
        do {
            let fetchData = try managedObjectContext.fetch(Tasks.fetchRequest()) as [Tasks]
            storedData = fetchData
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Successfully Updated")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        fetchAndReload()
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! CustomTableViewCell
        
        let currentItem = storedData[indexPath.row] as Tasks
        cell.titleLabel.text = String(describing: currentItem.title!)
        cell.descriptionLabel.text = String(describing: currentItem.descriptions!)
        
        let displayDate = dateConverter(date: currentItem.due_date!)
        cell.dateLabel.text = String(describing: displayDate)

        return cell
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let toDelete = storedData[indexPath.row]
        managedObjectContext.delete(toDelete)
        saveData()
        fetchAndReload()
    }
    
    // Get the clicked item/row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemToEdit = storedData[indexPath.row]
        performSegue(withIdentifier: "EditItemSegue", sender: itemToEdit)
        
    }
    
    func dateConverter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        
        let updateFormat = date
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        let displayDate = String(dateFormatter.string(from: updateFormat))
        
        return displayDate
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        do {
//            let taskRequest = try managedObjectContext.fetch(Tasks.fetchRequest())
//            taskRequest.forEach {
//                task in print((task as AnyObject).title!, (task as AnyObject).description!, (task as AnyObject).due_date!)
//            }
//        } catch {
//            print("Error: \(error)")
//        }
//    }


   

}
