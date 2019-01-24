//
//  DetailsViewController.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 19/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class DetailsViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    @IBOutlet weak var CastCollection: UICollectionView!
    var CastDetails = [Cast]()
    var MoviewDetails :Movie!
    var ArrayOfGeners = [Gener]()
    var islogin = false
//    @IBOutlet weak var Favorite: UIButton!
    var  IMDb_id : String = " "
    var movei_ID = 0
    @IBOutlet weak var Geners: UILabel!
    @IBOutlet weak var VotoAvrage: UILabel!
    
    @IBOutlet weak var Overview: UILabel?
    @IBOutlet weak var MoviewImage: UIImageView?
    @IBOutlet weak var MovieTitle: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.bool(forKey: "Log-in")
        UserDefaults.standard.set(false, forKey: "Log-in")
        GenerRequest()
        DetailsRequest()
        CastRequest()
     }
    
    func DetailsRequest(){
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/\(MoviewDetails.id)?api_key=54d967b50f9705aa762c1ebbd833a254&language=en-US")!) { (data, response, error) in
            do {
                let list = try JSONDecoder().decode(Details.self, from: data!)
                DispatchQueue.main.async(execute: {
                    self.Overview?.text = list.overview
                    self.MovieTitle?.text = list.title
                    self.VotoAvrage?.text = "\(list.vote_average)"
                    self.IMDb_id = list.imdb_id
                    self.movei_ID = list.id
                })
            } catch {
                print(error)
            } }.resume()
    }
    
    func GenerRequest(){
        URLSession.shared.dataTask(with: URL(string:"https://api.themoviedb.org/3/genre/movie/list?api_key=54d967b50f9705aa762c1ebbd833a254&language=en-US")!) { (data, response, error) in
            do {
                let list = try JSONDecoder().decode(MyGener.self, from: data!)
                self.ArrayOfGeners.append(contentsOf: list.genres)
                DispatchQueue.main.async {
                    var NewGener_id = " "
                    var Count = 0
                    while Count < self.ArrayOfGeners.count {
                        if self.MoviewDetails.genre_ids.contains(self.ArrayOfGeners[Count].id){
                            NewGener_id.append(contentsOf: "\(self.ArrayOfGeners[Count].name)   ")
                        }
                        Count = Count + 1
                    }
                    self.Geners.text = NewGener_id
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    @IBAction func SimilerButtonAction(_ sender: Any) {
        let SimilerViewController = self.storyboard?.instantiateViewController(withIdentifier: "SimilarTableViewController") as! SimilarTableViewController
            SimilerViewController.MovieDetails = self.MoviewDetails
            self.navigationController?.pushViewController(SimilerViewController, animated: true)
    }
    
    func CastRequest(){
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/\(MoviewDetails.id)/credits?api_key=54d967b50f9705aa762c1ebbd833a254")!) { (data, response, error) in
            do {
                let list = try JSONDecoder().decode(MyCast.self, from: data!)
                self.CastDetails.append(contentsOf: list.cast)
                DispatchQueue.main.async {
                self.CastCollection.reloadData()
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CastDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CastCollectionViewCell
        cell.CastActorName?.text = CastDetails[(indexPath as NSIndexPath).row].name

        if let NewPosterPath = CastDetails[(indexPath as NSIndexPath).row].profile_path {
            ImageRequestForCell(cellForRowAt: indexPath, cell: cell , URL: NewPosterPath)
        } else {
            cell.CastActorImage?.image  = UIImage(named: "EmptyPerson")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ActorDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ActorDetailsViewController") as! ActorDetailsViewController
        ActorDetailsViewController.ActorDetails = self.CastDetails[indexPath.row]
        if let NewPosterPath = CastDetails[(indexPath as NSIndexPath).row].profile_path {
            ImageRequestForVC(cellForRowAt: indexPath, VC: ActorDetailsViewController, URL: NewPosterPath)
        } else {
            ActorDetailsViewController.ActorImage?.image  = UIImage(named: "EmptyPerson")
        }
        self.navigationController?.pushViewController(ActorDetailsViewController, animated: true)
    }
    
    
    func ImageRequestForCell(cellForRowAt indexPath: IndexPath ,cell : CastCollectionViewCell , URL : String) {
          let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URL) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                                  cell.CastActorImage?.image = image
            }
        }
    }
    
    func ImageRequestForVC(cellForRowAt indexPath: IndexPath ,VC : ActorDetailsViewController , URL : String) {
        let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URL) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                VC.ActorImage?.image = image
            }
        }
    }
    
    
    @IBAction func ShareResultToIMBD(_ sender: Any) {
        let MyWebSite = NSURL(string:"https://www.imdb.com/title/\(IMDb_id)")
        let shareURL = [MyWebSite]
         let activityViewController = UIActivityViewController.init(activityItems: shareURL, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    

}
