//
//  ViewController.swift
//  Instagram Feed
//
//  Created by user on 1/21/16.
//  Copyright © 2016 Jean_Barbara. All rights reserved.
//

import UIKit
import AFNetworking


class photosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("data: \(responseDictionary)")
                            
                            self.photos = responseDictionary["images"] as? [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
            
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let photos = photos {
            return photos.count
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let photo = photos![indexPath.row]
        
        let photoPath = photo["images"] as! String
        let baseUrl = "https://api.instagram.com/v1/media/popular?access_token=clientId"
        
        let imageUrl = NSURL(string: baseUrl + photoPath)
        
        cell.photoView.setImageWithURL(imageUrl!)
        
        print("row\(indexPath.row)")

        return cell
        
    }


}

