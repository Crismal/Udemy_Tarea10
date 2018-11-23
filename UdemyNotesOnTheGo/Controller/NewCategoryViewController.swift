//
//  NewCategoryViewController.swift
//  UdemyNotesOnTheGo
//
//  Created by Cristian Misael Almendro Lazarte on 11/20/18.
//  Copyright © 2018 Cristian Misael Almendro Lazarte. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet var colorSliders: [UISlider]!
    @IBOutlet var colorLabels: [UILabel]!
    @IBOutlet weak var hexlabel: UILabel!
    
    let colorKeys = ["R","G","B","A"]
    let imagePicker = UIImagePickerController();
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Como la imageView no puede convocar a IBActions le agregamos un gesture recognizer
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector (imageViewTapped));
        
        imageView.isUserInteractionEnabled = true;
        
        imageView.addGestureRecognizer(tapGestureRecongnizer);
        
        imagePicker.delegate = self;
    }
    
    @IBAction func silderMoved(_ sender: UISlider) {
        
        
        colorLabels[sender.tag].text = "\(colorKeys[sender.tag]): \(lroundf(sender.value*255.0))"
        repaintBackground()
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let category = Category(context: context);
        
        category.title = textField.text;
        category.colorHex = UIColor(hex: hexlabel.text!)?.toHex;
        category.image = imageView.image?.pngData();
         
        do {
            try context.save()
            
        } catch  {
            print("Error al guardar la categoria en Core Data \(error)");
        }
        
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        
        
    }
    
    @objc func imageViewTapped(){
        imagePicker.allowsEditing = false;
        let controller = UIAlertController(title: "Seleccione una imagen", message: "", preferredStyle: UIAlertController.Style.actionSheet);
        
        controller.addAction(UIAlertAction(title: "Camara de fotos", style: UIAlertAction.Style.default, handler: { (alert) in
            self.imagePicker.sourceType = .camera;
            
            self.present(self.imagePicker, animated: true, completion: nil);
        }));
        
        controller.addAction(UIAlertAction(title: "Album de fotos", style: UIAlertAction.Style.default, handler: { (alert) in
            self.imagePicker.sourceType = .savedPhotosAlbum;
            
            self.present(self.imagePicker, animated: true, completion: nil);
        }));
        
        controller.addAction(UIAlertAction(title: "Carrete de fotos", style: UIAlertAction.Style.default, handler: { (alert) in
            self.imagePicker.sourceType = .photoLibrary;
            
            self.present(self.imagePicker, animated: true, completion: nil);
        }));
        
        self.present(controller, animated: true, completion: nil);
    }
    
    func repaintBackground() {
        let backColor = UIColor(red: CGFloat( colorSliders[0].value), green: CGFloat(colorSliders[1].value), blue: CGFloat(colorSliders[2].value), alpha: CGFloat(colorSliders[3].value));
        
        self.hexlabel.text = backColor.toHex;
        
        self.view.backgroundColor = backColor;
    }
    
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        return true;
    }
}

extension NewCategoryViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate{

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let  pickeImage = info[.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit;
            imageView.image = pickeImage;
            
        }
        imagePicker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil);
    }
    
}
