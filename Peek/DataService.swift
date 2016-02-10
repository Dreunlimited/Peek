//
//  DataService.swift
//  Peek
//
//  Created by D'Andre Ealy on 1/30/16.
//  Copyright © 2016 D'Andre Ealy. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://peekgram.firebaseio.com"

enum path: String {
    case posts
    case users
}


class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/\(path.posts)")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/\(path.users)")
    
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
       
    func createUser(uid:String, user: Dictionary<String,String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}