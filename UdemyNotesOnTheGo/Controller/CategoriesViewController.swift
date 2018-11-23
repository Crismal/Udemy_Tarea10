//
//  ViewController.swift
//  UdemyNotesOnTheGo
//
//  Created by Cristian Misael Almendro Lazarte on 11/17/18.
//  Copyright © 2018 Cristian Misael Almendro Lazarte. All rights reserved.
//

import UIKit
import CoreData;


class CategoriesViewController: UICollectionViewController {
    
    var categoriesArray = [Category]();
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let sortDescription = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescription]
        do{
            try categoriesArray = context.fetch(request)
        } catch {
            print("Error al recuperar las categorías \(error)")
        }
        collectionView.reloadData()
    }
    
    //MARK:- Metodos de Collection View Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesArray.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell;
        
        let category = categoriesArray[indexPath.row];
        
        cell.categoryLabel.text = category.title;
        cell.categoryImageView.image = UIImage(data: category.image!);
        cell.categoryImageView.contentMode = .scaleAspectFit;
        cell.categoryImageView.layer.borderColor = UIColor(hex: category.colorHex!)?.cgColor;
        cell.categoryImageView.layer.borderWidth = 4;
        cell.categoryImageView.layer.cornerRadius = 10;
        cell.categoryImageView.backgroundColor = UIColor(hex: category.colorHex!);
        
        
        return cell;
    }
    
    var selectedCategory = -1;
    
    //MARK: - Metodos de la collection view delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = indexPath.row;
        self.performSegue(withIdentifier: "ShowNoteList", sender: self);
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNoteList" {
            
            let destinationVC = segue.destination as! NotesTableViewController;
             
            destinationVC.selectedCategory = categoriesArray[selectedCategory];
        }
    }
}

