//
//  DetailViewController.swift
//  LocalContact
//
//  Created by Azis Prasetyotomo on 27/11/21.
//

import UIKit
import CoreData

protocol DetailViewControllerProtocol {
    func dataHasBeenUpdated()
}

class DetailViewController: UIViewController {

    var delegate: DetailViewControllerProtocol?
    var contact: Contact?
    let coreDataManager = CoreDataManager()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var properSaveButton: UIButton!
    @IBOutlet weak var commonSaveButton: UIButton!
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = title
        
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        numberTextField.text = "\(contact.phone)"
        picImageView.image = UIImage(data: contact.picture!)
        
    }
    
    
    @IBAction func picButtonAction(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func commonlySaveButtonAction(_ sender: Any) {
        
        properSaveButton.isEnabled = false
        commonSaveButton.isEnabled = false

        if let contact = contact {
            contact.name = nameTextField.text
            contact.phone = Int32(numberTextField.text!)!
            contact.picture = picImageView.image?.pngData()
        } else {
            let idToSave: Int = UserDefaults.standard.integer(forKey: "increamentKey") + 1
            UserDefaults.standard.setValue(idToSave, forKey: "increamentKey")

            // Create Entity Description
            let entityDescription = NSEntityDescription.entity(forEntityName: "Contact", in: coreDataManager.singleManagedObjectContext)

            if let entityDescription = entityDescription {
                let newContact = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.singleManagedObjectContext) as! Contact
                newContact.userID = Int64(idToSave)
                newContact.name = nameTextField.text
                newContact.phone = Int32(numberTextField.text!)!
                newContact.picture = picImageView.image?.pngData()
            }
            
        }

        
        let startTime = CFAbsoluteTimeGetCurrent()
        saveDataCommonlyOnInternetTutorial()
        let finishTime = CFAbsoluteTimeGetCurrent()
        let elapseTime = (finishTime - startTime) * 1000
        print("Total waktu dibutuhkan adalah = \(elapseTime) ms")
        
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func properSaveButtonAction(_ sender: Any) {
        
        properSaveButton.isEnabled = false
        commonSaveButton.isEnabled = false
        
        if let contact = contact {
            contact.name = nameTextField.text
            contact.phone = Int32(numberTextField.text!)!
            contact.picture = picImageView.image?.pngData()
        } else {
            let idToSave: Int = UserDefaults.standard.integer(forKey: "increamentKey") + 1
            UserDefaults.standard.setValue(idToSave, forKey: "increamentKey")

            // Create Entity Description
            let entityDescription = NSEntityDescription.entity(forEntityName: "Contact", in: coreDataManager.mainManagedObjectContext)

            if let entityDescription = entityDescription {
                let newContact = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.mainManagedObjectContext) as! Contact
                newContact.userID = Int64(idToSave)
                newContact.name = nameTextField.text
                newContact.phone = Int32(numberTextField.text!)!
                newContact.picture = picImageView.image?.pngData()
            }
            
        }

        
        let startTime = CFAbsoluteTimeGetCurrent()
        saveDataProperly()
        let finishTime = CFAbsoluteTimeGetCurrent()
        let elapseTime = (finishTime - startTime) * 1000
        print("Total waktu dibutuhkan adalah = \(elapseTime) ms")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func saveDataProperly() {
        
        coreDataManager.mainManagedObjectContext.performAndWait {
            do {
                try self.coreDataManager.mainManagedObjectContext.save()
                
            } catch {
                print("Unable to save managed object context. \(error)")
            }
        }

        coreDataManager.backgroundManagedObjectContext.perform { [weak self] in
            do {
                guard let self = self else { return }
                try self.coreDataManager.backgroundManagedObjectContext.save()
                self.delegate?.dataHasBeenUpdated()
            } catch {
                print("Unable to save managed object context. \(error)")
            }
            
        }
    }
    
    func saveDataCommonlyOnInternetTutorial() {
        
        do {
            try self.coreDataManager.singleManagedObjectContext.save()
            self.delegate?.dataHasBeenUpdated()
        } catch {
            print("Unable to save managed object context. \(error)")
        }
    }

    
}

extension DetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.picImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
