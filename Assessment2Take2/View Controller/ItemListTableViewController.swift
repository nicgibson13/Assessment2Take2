//
//  ItemListTableViewController.swift
//  Assessment2Take2
//
//  Created by Nic Gibson on 6/21/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import UIKit
import CoreData

class ItemListTableViewController: UITableViewController, ItemListTableViewCellDelegate {
    func cellButtonTapped(_ sender: ItemListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ItemController.sharedInstance.toggleIsCollectedFor(item: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let popUp = UIAlertController(title: "Add item to shopping list", message: nil, preferredStyle: .alert)
        popUp.addTextField { (textField) in textField.placeholder = "What is the item?" }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemText = popUp.textFields?.first?.text else {return}
            ItemController.sharedInstance.createItemWith(name: itemText)
            self.tableView.reloadData()
        }
        
        popUp.addAction(dismissAction)
        popUp.addAction(addItemAction)
        present(popUp, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemListTableViewCell,
            let item = ItemController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else {return UITableViewCell()}
        cell.update(withItem: item)
        cell.delegate = self
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let itemToDelete = ItemController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            ItemController.sharedInstance.deleteItem(item: itemToDelete)
        }
    }
}
extension ItemListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
