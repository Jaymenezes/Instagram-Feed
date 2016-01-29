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
        
        let refreshControl = UIRefreshControl()
        
          refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0) 
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 320
        
        
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
                            NSLog("response: \(responseDictionary)")
                            
                            self.photos = responseDictionary["data"] as? [NSDictionary]
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
    
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        print("Refresh Test")
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
       
        let photoPath = photo.valueForKeyPath("images.standard_resolution.url") as! String

        let imageUrl = NSURL(string: photoPath)
        
        cell.photoView.setImageWithURL(imageUrl!)
        
        
        func delay(delay:Double, closure:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), closure)
        }
        
       
        

        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("test")


        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        
        
//        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let photo = photos![indexPath!.row]
        let vc = segue.destinationViewController as! PhotosDetailsViewController
        vc.photo = photo

        
        
        
        
       
        
        
        
        
    }



}

