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

     var post:Post!
     var request:Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
           }
    
   
    

    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showCaseImg.clipsToBounds = true 

    }
    
    func configureCell(post: Post, imag: UIImage?) {
        self.post = post
        
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
    }
  
}
