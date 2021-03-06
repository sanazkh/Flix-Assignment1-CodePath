//
//  ViewController.swift
//  Flixo
//
//  Created by Sanaz Khosravi on 9/6/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//
import UIKit
import AlamofireImage
import AFNetworking
import MBProgressHUD

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var mySearchBar: UISearchBar!
    //var movies : [[String: Any]] = []
    
    //var allMovies : [[String: Any]] = []
    var movies : [Movie] = []
    var allMovies : [Movie] = []
    let backgroundView = UIView()
    let refreshControl = UIRefreshControl()
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        myTableView.insertSubview(refreshControl, at: 0)
        self.title = "Now Playing Movies"
        mySearchBar.delegate = self
        myTableView.insertSubview(refreshControl, at: 0)
        myTableView.dataSource = self
        myTableView.delegate = self
        // self sizing row
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 150
        
        //fetchNowPlayingMoview()
        fetchMovies()
        
    }
    
    func fetchMovies(){
        MovieAPIManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.allMovies = movies
                self.myTableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
       // fetchNowPlayingMoview()
        fetchMovies()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return filterMovies.count
        return movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.movie = movie
        
        
        /* let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.myTitleLabel.text = title
        cell.myTitleLabel.sizeToFit()
        
        cell.myTitleLabel.adjustsFontSizeToFitWidth = true
        cell.myDescLabel.text = overview
        
        cell.myDescLabel.sizeToFit()
        cell.myDescLabel.adjustsFontSizeToFitWidth = true
        let placeholderImage = UIImage(named: "default-placeholder.png")!
        /*  if let posterPathString = movie["poster_path"] as? String {
         let baseURlString = "https://image.tmdb.org/t/p/w500"
         let posterURL = URL(string: baseURlString + posterPathString)!
         // Setting image placeholder
         cell.myImageView.af_setImage(withURL: posterURL, placeholderImage: placeholderImage, imageTransition: .flipFromBottom(2))
         }else{
         cell.myImageView.image = placeholderImage
         } */
        
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLStringSmall = "https://image.tmdb.org/t/p/w45"
            let baseURLStringLarge = "https://image.tmdb.org/t/p/w500"
            
            let smallImageUrl = URL(string: baseURLStringSmall + posterPathString)!
            let largeImageUrl = URL(string: baseURLStringLarge + posterPathString)!
            
            let smallImageRequest = URLRequest(url: smallImageUrl)
            let largeImageRequest = URLRequest(url: largeImageUrl)
            
            cell.myImageView.setImageWith(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache
                    cell.myImageView.alpha = 0.0
                    cell.myImageView.image = smallImage;
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        cell.myImageView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        cell.myImageView.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                cell.myImageView.image = largeImage;
                        },
                            failure: { (request, response, error) -> Void in
                                cell.myImageView.image = placeholderImage
                        })
                    })
                    
            },
                failure: { (request, response, error) -> Void in
                    cell.myImageView.image = placeholderImage
            })
        }else{
            cell.myImageView.image = placeholderImage
        }
        backgroundView.backgroundColor = UIColor.gray
        cell.selectedBackgroundView = backgroundView */
        return cell
    }
    
    
    
   /* func fetchNowPlayingMoview(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=85c378ca43ad66ca8fa593bb2aaacca0")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
               // let movies = dataDictionary["results"] as! [[String : Any]]
               // self.movies = movies
               // self.allMovies = movies
                
                self.myTableView.reloadData()
                self.refreshControl.endRefreshing()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
    } */
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movies = searchText.isEmpty ? movies : allMovies.filter { (item: Movie) -> Bool in
            
            let res = item.title
            return res.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.myTableView.reloadData()
       
        
      /*  movies = searchText.isEmpty ? movies : allMovies.filter { (item: [String : Any]) -> Bool in
            
            let res = item["title"] as! String
            return res.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.myTableView.reloadData() */
    }
    
    
    // Show cancel button on searchbar when being used
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    // Clear search bar when cancel is hit
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        movies = allMovies
        myTableView.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = myTableView.indexPath(for: cell)
        let movie = movies[indexPath!.row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
}



