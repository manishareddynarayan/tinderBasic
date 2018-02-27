//
//  Query.swift
//  TinderApp
//
//  Created by Manisha Reddy Narayan on 23/02/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse

class Query: PFObject,PFSubclassing{
    
    override init() {
        super.init()
    }
    public class func parseClassName() -> String {
        return "Query"
    }
    
    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: Query.parseClassName())
        //query.order(byDescending: "createdAt")
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] {
            query.whereKey("isFemale", equalTo: isInterestedInWomen)
        }
        if let isFemale = PFUser.current()?["isFemale"] {
            query.whereKey("isInterestedInWomen", equalTo: isFemale)
        }
        query.cachePolicy = .networkOnly
        return query
    }
}
