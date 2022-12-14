//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() //    var itemArray2: [Item] = []

    // тут мы как бы обратились к appDelegate, но нам надо было обратиться не к классу в целом, а к конкретному объекту, поэтому и пришлось прописать вот так длинно
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            itemArray = items
        //        }

//        узнать месторасположение файлов проекта
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadData()

    }

    //MARK: TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //это реюзабл селл, таким образом, если список большой, когда сел пропадает с экрана при скроллинге, мы как бы переиспользуем этот селл для создания новых селл, и таким образом чекмарк сохраняется В то же время, если не использоват именно реюзабл селл, то чекмарк при скроллинге просто будет пропадать.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title

        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }

    //MARK: TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()

        //убирает выделение строки с анимацией затухания.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoye Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user presses the Add Item button on our Alert
            //            if let safeText = textField.text {

            // что такое context? за что он отвечает вообще?
            let newItem = Item(context: self.context)

            newItem.title = textField.text!

            self.itemArray.append(newItem)

            self.saveItems()


            // self.defaults.set(self.itemArray, forKey: "ToDoListArray")

        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: MODEL MANIPULATION METHOD

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }

        tableView.reloadData()
    }


    func loadData() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}




