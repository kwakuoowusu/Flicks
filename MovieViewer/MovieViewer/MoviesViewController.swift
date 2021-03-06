//
//  MoviesViewController.swift
//  MoviewViewer
//
//  Created by Kwaku Owusu on 1/14/16.
//  Copyright © 2016 Kwaku Owusu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData: [NSDictionary]!
    var endpoint: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.tintColor = UIColor.whiteColor()

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        filteredData = movies
        self.errorLabel.hidden = true
        self.errorImage.hidden = true
        
        //load network data
        
        loadData()
        
        //creation of refresh control to allow pull down refresh

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        filteredData = movies

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")

        
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
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            if let data = dataOrNil {

                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
        
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    //reload to fill out tables
                    self.filteredData = self.movies
                    
                    self.errorLabel.hidden = true
                    self.errorImage.hidden = true
                    
                    self.tableView.reloadData()
                        
                    }
                } else {
                
                //hide search bar and display errors
                self.searchBar.hidden = true
                self.errorLabel.hidden = false
                self.errorImage.hidden = false
                }

        });

        task.resume()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return same number of rows as movies given by movies database
        //if movies does not exist return 0
        
        if let filteredData = filteredData{
            return filteredData.count
        } else {
            return 0;
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        

        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell
        
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            
            cell.posterView.alpha = 0.0
            
            //make posters fade in as they are cycled through
            UIView.animateWithDuration(0.7){
                cell.posterView.setImageWithURL(posterUrl!)
                cell.posterView.alpha = 1.0

            }
            
            
        } else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            cell.posterView.image = nil
        }
        
        
        cell.titleLable.text = title

        cell.overviewLable.text = overview
        
        //cell.selectionStyle = .None
        /*Debugging to see JSON DATA
        print("row \(indexPath.row)")
        */
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.grayColor()
        cell.selectedBackgroundView = backgroundView
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

        //let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell

        
        
        
        //tableView.reloadData()
    }
    
    func refreshControlAction(refreshcontrol:UIRefreshControl){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        
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
                            self.filteredData = self.movies
                            //reload to fill out tables
                            self.tableView.reloadData()
                            refreshcontrol.endRefreshing()
                            self.searchBar.hidden = false
                            self.errorLabel.hidden = true
                            
                            self.errorImage.hidden = true
                    }else{
                        self.searchBar.hidden = true
                        self.errorLabel.hidden = false
                        self.errorImage.hidden  = false
                    }
                }
                
                
            
        });
        task.resume()
    }

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredData = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = movies!.filter({(dataItem: NSDictionary) -> Bool in
                
                let item = dataItem["title"] as! String
                
                if item.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = movies
        tableView.reloadData()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let movie = filteredData![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
        
        
    }
    



}
