//
//  ViewController.swift
//  TinderApp
//
//  Created by Manisha Reddy Narayan on 22/02/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    var displayUserId = ""
    @IBOutlet weak var displayImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer(target:self,action:#selector(wasDragged(gestureRecognizer:)))
        displayImageView.addGestureRecognizer(gesture)
        updateImage()
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let point = geoPoint {
                PFUser.current()?["location"] = point
                PFUser.current()?.saveInBackground()
            }
        }
    }
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let labelPoint = gestureRecognizer.translation(in: view)
        displayImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        let xFromCenter = view.bounds.width / 2 - displayImageView.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        displayImageView.transform = scaledAndRotated
        if gestureRecognizer.state == .ended {
            var acceptance = ""
            if displayImageView.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
                acceptance = "rejected"
            }
            if displayImageView.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
                acceptance = "accepted"
            }
            if acceptance != "" && displayUserId != "" {
                PFUser.current()?.addUniqueObject(displayUserId, forKey: acceptance)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateImage()
                    }
                })
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            displayImageView.transform = scaledAndRotated
            displayImageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }
    func updateImage() {
        if let query = PFUser.query() {
            if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] {
                query.whereKey("isFemale", equalTo: isInterestedInWomen)
            }
            if let isFemale = PFUser.current()?["isFemale"] {
                query.whereKey("isInterestedInWomen", equalTo: isFemale)
            }
            var ignoredUsers : [String] = []
            
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                ignoredUsers += acceptedUsers
            }
            
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] {
                ignoredUsers += rejectedUsers
            }
            
            query.whereKey("objectId", notContainedIn: ignoredUsers)
            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint {
                query.whereKey("location", withinGeoBoxFromSouthwest:                 PFGeoPoint(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1)
                    , toNortheast: PFGeoPoint(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1)
                )
            }
            query.limit = 1
            query.findObjectsInBackground(block: { (objects, error) in
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let imageFile = user["photo"] as? PFFile {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if data != nil {
                                        self.displayImageView.image = UIImage(data: data!)
                                        if let objectId = user.objectId {
                                            self.displayUserId = objectId
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
    @IBAction func logOutButton(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

