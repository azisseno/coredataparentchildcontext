//
//  ViewController.swift
//  LocalContact
//
//  Created by Azis Prasetyotomo on 27/11/21.
//

import CoreData
import UIKit

class ViewController: UITableViewController {
    
    let coreDataManager: CoreDataManager = CoreDataManager()
    var contacts: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchContacts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    func fetchContacts() {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "userID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let records = try coreDataManager.mainManagedObjectContext.fetch(fetchRequest)
            self.contacts = records
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        performSegue(withIdentifier: "showContactDetail", sender: contact)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc: DetailViewController = segue.destination as! DetailViewController
        vc.delegate = self
        
        if segue.identifier == "showAddContact" {
            vc.title = "Add Contact Detail"
        }
        
        if segue.identifier == "showContactDetail" {
            vc.title = "Contact Detail"
            vc.contact = sender as? Contact
        }
    }
}

extension ViewController: DetailViewControllerProtocol {
    func dataHasBeenUpdated() {
        fetchContacts()
    }
}
