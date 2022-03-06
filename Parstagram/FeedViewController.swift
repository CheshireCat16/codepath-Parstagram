//
//  FeedViewController.swift
//  Parstagram
//
//  Created by John Cheshire on 3/6/22.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var posts = [PFObject]()
    let myRefreshControl = UIRefreshControl()
    var numPhotos = 20
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.commentLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
        
        
    }
    
    @objc func refreshPhotos() {
        let query = PFQuery(className: "Posts")
        
        query.includeKey("author")
        
        self.numPhotos = 20
        query.limit = self.numPhotos
        
        query.findObjectsInBackground { posts, error in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("Error getting posts")
            }
        }
        
        self.myRefreshControl.endRefreshing()
    }
    
    func loadMorePhotos() {
        let query = PFQuery(className: "Posts")
        self.numPhotos = self.numPhotos + 20
        
        query.includeKey("author")
        
        query.limit = self.numPhotos
        
        query.findObjectsInBackground { posts, error in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("Error getting posts")
            }
        }
        
        self.myRefreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refreshPhotos()
        
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        myRefreshControl.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == posts.count) {
            self.loadMorePhotos()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
