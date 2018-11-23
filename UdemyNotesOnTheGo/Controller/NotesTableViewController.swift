//
//  NotesTableViewController.swift
//  UdemyNotesOnTheGo
//
//  Created by Cristian Misael Almendro Lazarte on 11/17/18.
//  Copyright © 2018 Cristian Misael Almendro Lazarte. All rights reserved.
//

import UIKit
import CoreData;

class NotesTableViewController: UITableViewController {
    
    var notesArray = [Note]();
    var selectedCategory : Category?{
        didSet{
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    //let defaults = UserDefaults.standard;
    
    let dataFilePath = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first?.appendingPathComponent("Notes.plist");
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedCategory?.title;
        
        self.loadNotes();
        
        /* if let previousNotes = defaults.array(forKey: "NotesArray") as? [Note]{
         self.notesArray = previousNotes;
         }*/
        
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
        let note = self.notesArray[indexPath.row];
        
        cell.textLabel?.text = note.title;
        
        if note.checked {
            cell.accessoryType = .checkmark;
        }
        else{
            cell.accessoryType = .none;
        }
        
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
        let note = self.notesArray[indexPath.row];
        note.checked = !note.checked;
        self.persistNotes();
        tableView.cellForRow(at: indexPath)?.accessoryType = note.checked ? UITableViewCell.AccessoryType.checkmark:  UITableViewCell.AccessoryType.none;
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
            
            let note = Note(context: self.context);
            
            note.title = textField.text!;
            note.parentCategory = self.selectedCategory;
            self.notesArray.append(note);
            self.persistNotes();
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
    
    //MARK:- Data persistence and manipulation
    
    func persistNotes() {
        //self.defaults.set(self.notesArray, forKey: "NotesArray");
        
        //        let encoder = PropertyListEncoder();
        //
        //        do {
        //            let data = try encoder.encode(self.notesArray);
        //            try data.write(to: self.dataFilePath!);
        //        } catch{
        //            print("Error al codificar \(error)");
        //        }
        //        self.tableView.reloadData();
        
        do {
            try self.context.save();
            self.tableView.reloadData();
        } catch  {
            print("Error al intentar guardar el contexto \(error)");
        }
    }
    
    func loadNotes(from request: NSFetchRequest<Note> = Note.fetchRequest(), predicate : NSPredicate? = nil) {
        
        //        if let data = try? Data(contentsOf: dataFilePath!){
        //
        //            let decoder = PropertyListDecoder();
        //
        //            do{
        //                notesArray = try decoder.decode([Note].self, from: data);
        //            } catch{
        //                print("Error al decodificar \(error)");
        //            }
        //        }
        
         let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory!.title!);
        
        if let previusPredicate = predicate{
            // aqui tenemos un predicado de busqueda previo
            
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [previusPredicate, categoryPredicate]);
            request.predicate = compoundPredicate;
        } else {
            request.predicate = categoryPredicate;
        }
        
        do{
            self.notesArray = try context.fetch(request);
            
        }catch {
            print("Error al recuperar datos de Core Data: \(error)");
        }
        
        self.tableView.reloadData();
    }
    
}


//MARK:- Metodos de la search bar

extension NotesTableViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!;
        
        let request : NSFetchRequest<Note> = Note.fetchRequest();
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText);
        
        
        let sortDescription = NSSortDescriptor(key: "title", ascending: true);
        request.sortDescriptors = [sortDescription];
        
        self.loadNotes(from: request);
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadNotes();
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }
}
