//
//  ViewController.swift
//  SaveImageInCoreData2
//
//  Created by daicudu on 1/5/19.
//  Copyright © 2019 daicudu. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "hoa")
        }
    }
    
    var entity: [Entity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = try? (AppDelegate.context.fetch(Entity.fetchRequest())) as [Entity], !entity.isEmpty {
            imageView.image = entity.last?.image as? UIImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        guard let selectedImage =
            info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        guard imageView.image != nil else {
            return
        }
        let context = Entity(context: AppDelegate.context)
        
        context.image = imageView.image
        AppDelegate.saveContext()
    }
    
    
    
    
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

