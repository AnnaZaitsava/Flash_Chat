//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Anna Zaitsava on 14.09.23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages(){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                
            self.messages = []
            
            if let err = error {
                print("Issue with retrieving from firestore, \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                                               self.tableView.reloadData()
                                                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                                        }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
                    db.collection(K.FStore.collectionName).addDocument(data: [
                        K.FStore.senderField: messageSender,
                        K.FStore.bodyField: messageBody,
                        K.FStore.dateField: Date().timeIntervalSince1970
                    ]) { (error) in
                        if let err = error {
                            print("There was an issue saving data to firestore, \(err)")
                        } else {
                            print("Successfully saved data.")
                            
                            DispatchQueue.main.async {
                                 self.messageTextfield.text = ""
                                
                            }
                        }
                    }
                }
            }
        

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
           
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        cell.label.text = messages[indexPath.row].body
        
        
       return cell
    }
    
}


