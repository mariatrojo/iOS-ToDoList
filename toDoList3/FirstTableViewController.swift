//
//  ViewController.swift
//  toDoList3
//
//  Created by Maria Teresa Rojo on 1/25/18.
//  Copyright © 2018 Maria Rojo. All rights reserved.
//

import UIKit
import CoreData

class FirstTableViewController: UITableViewController, SecondViewControllerDelegate {

    var items = [TaskItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func saveItem(_ controller: SecondViewController, with title:String, _ notes: String, and date: Date) {
        let item = NSEntityDescription.insertNewObject(forEntityName: "TaskItem", into: context) as! TaskItem
        item.title = title
        item.notes = notes
        item.date = date
        item.mark = false
        
        items.append(item)
        
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.titleLabel.text = items[indexPath.row].title
        cell.notesLabel.text = items[indexPath.row].notes
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let myDate = items[indexPath.row].date
        cell.dateLabel.text = formatter.string(from: myDate!)
        
        if items[indexPath.row].mark == true {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskItem")
        do {
            let result = try context.fetch(request)
            items = result as! [TaskItem]
        } catch {
            print("\(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].mark = true
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! SecondViewController
        secondViewController.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }


}

