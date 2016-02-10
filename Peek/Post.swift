//
//  Post.swift
//  Peek
//
//  Created by D'Andre Ealy on 2/1/16.
//  Copyright © 2016 D'Andre Ealy. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription:String!
    private var _imageURL: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String! {
        return _postDescription
    }
    
    var imageURL: String? {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    //Need for when we create a new post from the app side
    
    init(description:String!, imageURL:String?, username:String){
        self._postDescription = description
        self._imageURL = imageURL
        self._username = username
    }
    
    //Data that comes from Firebase. This is modeled after the data in the database 
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        
        if let imageURL = dictionary["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
    }
    
}