//
//  NotesTableViewController.swift
//  UdemyNotesOnTheGo
//
//  Created by Cristian Misael Almendro Lazarte on 11/17/18.
//  Copyright © 2018 Cristian Misael Almendro Lazarte. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var notesArray = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.notesArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = self.notesArray[indexPath.row];
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Metodos de Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none;
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true);
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Añadir nuevos items a la tabla
    
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let controller = UIAlertController(title: "Añadir nueva nota", message: "", preferredStyle: UIAlertController.Style.alert);
        
        let addAction = UIAlertAction(title: "Añadir item", style: UIAlertAction.Style.default) { (action) in
            //TODO: Recuperar lo que haya escrito el usuario cuando pulsa el boton añadir
            
            self.notesArray.append(textField.text!);
            self.tableView.reloadData();
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil);
        
        controller.addAction(addAction);
        controller.addAction(cancelAction);
        
        controller.addTextField { (alertTextField) in
            alertTextField.placeholder = "Escribe aqui tu nota";
            
            textField = alertTextField;
        }
        
        present(controller, animated: true, completion: nil);
    }
}
