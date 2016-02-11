//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Kwaku Owusu on 2/11/16.
//  Copyright © 2016 Kwaku Owusu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie:NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as! String
        titleLabel.text = title
        
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        
        if let posterPath = movie["poster_path"] as? String {
            
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            
            self.posterImageView.setImageWithURL(posterUrl!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
