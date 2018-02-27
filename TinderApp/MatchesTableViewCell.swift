//
//  MatchesTableViewCell.swift
//  TinderApp
//
//  Created by Manisha Reddy Narayan on 26/02/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {
    var recipientId = ""
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func sendOnClick(_ sender: Any) {
        let message = PFObject(className: "Message")
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientId
        message["content"] = messageTextField.text
        message.saveInBackground()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
