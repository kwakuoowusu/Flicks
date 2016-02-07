//
//  MoviesViewController.swift
//  MoviewViewer
//
//  Created by Kwaku Owusu on 1/14/16.
//  Copyright © 2016 Kwaku Owusu. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.errorLabel.hidden = true
        self.errorImage.hidden = true
        //creation of refresh control to allow pull down refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        EZLoadingActivity.show("Loading...", disableUI:true)

        let request = NSURLRequest(
            URL: url!,cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                                    timeoutInterval: 10)

            let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )

        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
        
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    //reload to fill out tables
                        EZLoadingActivity.hide(success: true, animated: false)
                        self.errorLabel.hidden = true
                        self.errorImage.hidden = true
                        self.tableView.reloadData()

                    }
                } else {
                
                EZLoadingActivity.hide(success: false, animated: false)
                self.errorLabel.hidden = false
                self.errorImage.hidden = false
                }

        });

        task.resume()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return same number of rows as movies given by movies database
        //if movies does not exist return 0
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        

        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            
            cell.posterView.alpha = 0.0
            
            //make posters fade in as they are loaded
            UIView.animateWithDuration(0.7){
                cell.posterView.setImageWithURL(posterUrl!)
                cell.posterView.alpha = 1.0

            }
            
            
        } else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            
        }
        
        
        cell.titleLable.text = title

        cell.overviewLable.text = overview
        /*Debugging to see JSON DATA
        print("row \(indexPath.row)")
        */
        return cell
    }
    
        func refreshControlAction(refreshcontrol:UIRefreshControl){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        let request = NSURLRequest(
            URL: url!,cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        //network request
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            //reload to fill out tables
                            self.tableView.reloadData()
                            refreshcontrol.endRefreshing()
                            self.errorLabel.hidden = true
                            self.errorImage.hidden = true
                    }else{
                        print("error")
                    }
                }
                
                
            
        });
        task.resume()
    }


}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


