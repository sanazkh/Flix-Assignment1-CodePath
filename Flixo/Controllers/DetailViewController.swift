//
//  DetailViewController.swift
//  Flix
//
//  Created by Sanaz Khosravi on 9/7/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    
    
    @IBOutlet var secondImageView: UIImageView!
 
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var originalTitle: UILabel!

    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var dImageView: UIImageView!
    
    var movie: [String : Any] = [:]
    var movieVideo : [[String: Any]] = []
    var movieID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        originalTitle.text = movie["title"] as? String
        descLabel.text = movie["overview"] as? String
        releaseLabel.text = movie["release_date"] as? String
        movieID = (movie["id"] as? Int)!
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseUrl + posterPath)
            dImageView.setImageWith(imageUrl!)
    }
     
        if let backDropPath = movie["backdrop_path"] as? String {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let bdimageUrl = URL(string: baseUrl + backDropPath)
            secondImageView.setImageWith(bdimageUrl!)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        // add it to the image view;
        dImageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        dImageView.isUserInteractionEnabled = true
        fetchMovieVideos()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            self.performSegue(withIdentifier: "modalSegue", sender: gesture.view)
        }
    }
    
    func fetchMovieVideos(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=85c378ca43ad66ca8fa593bb2aaacca0")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                let movieVideos = dataDictionary["results"] as! [[String : Any]]
                print(movieVideos)
                self.movieVideo = movieVideos
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "modalSegue") {
            let vc = segue.destination as! TrailerPlayViewController
            let firstVideo = movieVideo[0]
            vc.youtubeKey = firstVideo["key"] as! String
        }
    }
}
