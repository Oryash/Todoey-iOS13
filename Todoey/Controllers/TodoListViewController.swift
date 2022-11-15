//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    var itemArray = [Item]() //    var itemArray2: [Item] = []

    //    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()

        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            itemArray = items
        //        }

        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Find Eggos"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Kill Demogorgon"
        itemArray.append(newItem3)

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

        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }

        return cell
    }

    //MARK: TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //        print(itemArray[indexPath.row])

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //        вместо всего этого можно использовать одну строку выше.
        //        if itemArray[indexPath.row].done == true {
        //            itemArray[indexPath.row].done = false
        //        } else {
        //            itemArray[indexPath.row].done = true
        //        }

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
            print("Success!")

            //            if let safeText = textField.text {

            let newItem = Item()
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
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }

        tableView.reloadData()
    }


    //почему try?. Почему форс анвраппинг? что есть дата? почему decode именно с такими параметрами?
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding ItemArray, 1 \(error)")
            }
        }
    }
}




