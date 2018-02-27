//
//  MatchesViewController.swift
//  TinderApp
//
//  Created by Manisha Reddy Narayan on 26/02/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse
class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var images : [UIImage] = []
    var userIds : [String] = []
    var messages : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "matchesCell")
        tableView.rowHeight = 175.0
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedPeeps)
                
                query.findObjectsInBackground(block: { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFile {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = UIImage(data: imageData) {
                                                if let objectId = theUser.objectId {
                                                    let messagesQuery = PFQuery(className: "Message")
                                                    messagesQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                    messagesQuery.whereKey("sender", equalTo: theUser.objectId as Any)
                                                    messagesQuery.findObjectsInBackground(block: { (objects, error) in
                                                        var messagetext = "No message from this user."
                                                        if let objects = objects {
                                                            for message in objects {
                                                                if let content = message["content"] as? String {
                                                                    messagetext = content
                                                                }
                                                            }
                                                        }
                                                        self.messages.append(messagetext)
                                                        self.userIds.append(objectId)
                                                        self.images.append(image)
                                                        self.tableView.reloadData()
                                                    })
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:"matchesCell",for: indexPath) as? MatchesTableViewCell {
            cell.messageLabel.text = "you did not get any message"
            cell.profileImageView.image = images[indexPath.row]
            cell.recipientId = userIds[indexPath.row]
            cell.messageLabel.text = messages[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
