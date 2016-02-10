//
//  FeedVC.swift
//  Peek
//
//  Created by D'Andre Ealy on 1/31/16.
//  Copyright © 2016 D'Andre Ealy. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var posts = [Post]()
    var imagePicked = false
    static var imageCache = NSCache()
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var postTextField: MaterialTextField!
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 391

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //Used to grab all the post from the database
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            self.posts = []
            
            // Grabing all the post data
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            
            self.tableView.reloadData()
        })
      
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
                
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageURL {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, imag: img)
            return cell
        }else {
            return PostCell()
            
        }
        
        
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageURL == nil {
            return 200
        } else {
           return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageHolder.image = image
        imagePicked = true
        imageHolder.contentMode = .ScaleAspectFit
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func pickImage(sender: UITapGestureRecognizer) {
        
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .PhotoLibrary
//        presentViewController(imagePicker, animated: true, completion: nil)
        alert()
    }
    
    @IBAction func postButton(sender: UIButton!) {
        if let txt = postTextField.text where txt != "" {
            if let img = imageHolder.image where imagePicked == true {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imageData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "image/jpeg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    
                    
                    }, encodingCompletion: {  encodingResult in
                        
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON { response in
                                if let info = response.result.value as? Dictionary<String, AnyObject> {
                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
                                        if let imgLink = links["image_link"] as? String {
                                            print("LINK:\(imgLink)")
                                            self.postToFireBase(imgLink)
                                        }
                                    }
                                }
                            }
                        case .Failure(let encodingError):
                            print(encodingError)
                        }
                })
                
            }else {
                postToFireBase(nil)
            }
        }
    }
    
    func postToFireBase(imgURL:String?) {
        
        var post: Dictionary<String, AnyObject> = ["description":postTextField.text!, "likes": 0]
        
        if imgURL != nil {
            post["imageURL"] = imgURL!
        }
        let fireBasePost = DataService.ds.REF_POSTS.childByAutoId()
        fireBasePost.setValue(post)
        postTextField.text = ""
        imageHolder.image = UIImage(named: "camera")
        imagePicked = false 
        tableView.reloadData()
    }
    
    func alert () {
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            //Code for launching the camera goes here
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}
