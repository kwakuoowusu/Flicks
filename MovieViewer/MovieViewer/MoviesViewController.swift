//
//  MoviesViewController.swift
//  MoviewViewer
//
//  Created by Kwaku Owusu on 1/14/16.
//  Copyright © 2016 Kwaku Owusu. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 20
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //cells inside a table this allows the app not to load all cells at once, when a cell dissapears a new one is loaded
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath)
        
        //debugging just to show cells
        cell.textLabel!.text = "row \(indexPath.row)"
        print("row \(indexPath.row)")
        return cell
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
