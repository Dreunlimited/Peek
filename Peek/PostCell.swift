//
//  PostCell.swift
//  Peek
//
//  Created by D'Andre Ealy on 1/31/16.
//  Copyright © 2016 D'Andre Ealy. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var likeImage: UIImageView!

     var post:Post!
     var request:Request?
    var likeRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: "likedTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
    }
    
   
    

    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showCaseImg.clipsToBounds = true 

    }
    
    func configureCell(post: Post, imag: UIImage?) {
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        self.likes.text = "\(post.likes)"
        self.desc.text = post.postDescription
        
        if post.imageURL != nil {
            if imag != nil {
            self.showCaseImg.image = imag
            }else {
                
               request = Alamofire.request(.GET, post.imageURL!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                
                if err == nil {
                    if let img = UIImage(data: (data)!) {
                        self.showCaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageURL!)
                    }
                }
                
               })
            }
        }else {
            self.showCaseImg.hidden = true
        }
        
        DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        likeRef.observeSingleEventOfType(.Value, withBlock:  { snapshot in
            
            //NSNull in Firebase means the data is not there
            //if there is no data in firebase it returns NSNUll 
            
            if let doesNotExist = snapshot.value as? NSNull {
                //We have not liked this post
                
                self.likeImage.image = UIImage(named: "heart-empty")
                
            }else {
                self.likeImage.image = UIImage(named: "heart-full")

            }
        })
    }
    
    func likedTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock:  { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                 self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
               
                
            }else {
                 self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
                
            }
        })

    }
  
}
