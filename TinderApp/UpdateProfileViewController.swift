//
//  UpdateProfileViewController.swift
//  TinderApp
//
//  Created by Manisha Reddy Narayan on 23/02/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse
class UpdateProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var userIntrestGenderSwitch: UISwitch!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            genderSwitch.setOn(isFemale, animated: false)
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            userIntrestGenderSwitch.setOn(isInterestedInWomen, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground(block: { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileImageView.image = image
                    }
                }
            })
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    func createWomen() {
        let imageUrls = ["http://huntur.weebly.com/uploads/3/0/1/4/30148701/4035330_orig.png","http://www.metdaan.com/wp-content/uploads/2017/03/02-10.jpg","https://s-media-cache-ak0.pinimg.com/originals/4f/62/34/4f6234dbec1058f8029dfceb01639f6e.jpg","https://pre00.deviantart.net/22c2/th/pre/i/2016/036/d/c/gothic_girl_by_adderia-d9ql4qm.jpg","https://media2.mensxp.com/media/photogallery/2013/May/1369377803_85759.jpg","https://s-i.huffpost.com/gen/3023192/images/o-DISNEY-PRINCESSES-REALISTIC-FACES-facebook.jpg"]
        
        var counter = 0
        
        for imageUrl in imageUrls {
            counter += 1
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFile(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "abc123"
                    user["isFemale"] = true
                    user["isInterestedInWomen"] = false
                    
                    user.signUpInBackground(block: { (success, error) in
                        if success {
                            print("Women User created!")
                        }
                    })
                }
            }
        }
    }
    @IBAction func updateProfileOnClick(_ sender: Any) {
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = userIntrestGenderSwitch.isOn
        if let image = profileImageView.image {
            if let imageData = UIImagePNGRepresentation(image) {
                PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        var errorMessage = "Update Failed - Try Again"
                        if let newError = error as NSError? {
                            if let detailError = newError.userInfo["error"] as? String {
                                errorMessage = detailError
                            }
                        }
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                    } else {
                        print("Update Successful")
                        self.performSegue(withIdentifier: "displaySegue", sender: nil)
                    }
                })
            }
        }
        
    }
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
