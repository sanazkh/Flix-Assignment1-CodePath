//
//  SuperHeroViewController.swift
//  Flix
//
//  Created by Sanaz Khosravi on 9/12/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import MBProgressHUD

class SuperHeroViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet var mySearchBar: UISearchBar!
    
    var movies : [Movie] = []
    var allMovies : [Movie] = []
    
    //var movies : [[String: Any]] = []
    //var allMovies : [[String: Any]] = []
    let refreshControl = UIRefreshControl()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.row]
        cell.movie = movie
       /* if let posterPathString = movie["poster_path"] as? String{
            let baseURLStringLarge = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLStringLarge + posterPathString)!
            cell.myImageView.af_setImage(withURL: posterURL)
        } */
        
        return cell
    }
    

    @IBOutlet var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.dataSource = self
        mySearchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        myCollectionView.insertSubview(refreshControl, at: 0)
        self.title = "Super Hero Movies"
        let layout = myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        let cellPerLine : CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellPerLine - 1)
        let width = (myCollectionView.frame.size.width / cellPerLine) - (interItemSpacingTotal / cellPerLine)
        layout.itemSize = CGSize(width: width, height: width * 3 / 3)
        
        fetchSuperHeroMovies()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func fetchSuperHeroMovies(){
        MovieAPIManager().superheroMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.allMovies = movies
                self.myCollectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
    /*  func fetchSuperHeroMovies(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/363088/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                let movies = dataDictionary["results"] as! [[String : Any]]
                self.movies = movies
                self.allMovies = movies
                
                self.myCollectionView.reloadData()
                self.refreshControl.endRefreshing()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
    } */

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchSuperHeroMovies()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movies = searchText.isEmpty ? movies : allMovies.filter { (item: Movie) -> Bool in
            
            let res = item.title
            return res.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.myCollectionView.reloadData()
        /* movies = searchText.isEmpty ? movies : allMovies.filter { (item: [String : Any]) -> Bool in
            
            let res = item["title"] as! String
            return res.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.myCollectionView.reloadData() */
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
        myCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = myCollectionView.indexPath(for: cell)
        let movie = movies[indexPath!.item]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myCollectionView.reloadData()
    }
}
