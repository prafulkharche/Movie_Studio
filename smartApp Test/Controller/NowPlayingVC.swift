//
// 
//

import UIKit
import Alamofire

class NowPlayingVC: UIViewController {
    
    
    @IBOutlet weak var NowPlayingMovieSearchBar: UISearchBar!
    @IBOutlet weak var nowPlayingCV:
    UICollectionView!
    var viewModelUser = NowPlayingMoviesViewModel()
    
    var searchedMovieTitle = [String]()
    var searching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        viewModelUser.vc = self
        viewModelUser.getAllUsreDataAF()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func registerNib(){
        let nib = UINib.init(nibName: "NowPlayingCVC", bundle: nil)
        nowPlayingCV.register(nib,forCellWithReuseIdentifier: "NowPlayingCell")
    }
    
    
}
extension NowPlayingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedMovieTitle.count
        } else {
            return viewModelUser.arrMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:((self.view.frame.size.width/2)-5),height: 300)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCell", for: indexPath) as! NowPlayingCVC
        let data = viewModelUser.arrMovies[indexPath.item]
        if searching {
            cell.lblOfMovieTitle.text = searchedMovieTitle[indexPath.row]
        } else {
            cell.lblOfMovieTitle.text = data.title
            cell.lblOfMovieDescription.text = data.overview
            if let posterPath = data.poster_path{
                let posterImageURL = "\(commonURL.posterBaseURL)\(posterPath)"
                AF.request(posterImageURL, method: .get).response{ response in
                    switch response.result {
                    case .success(let responseData):
                        cell.movieImgData.image = UIImage(data: responseData!, scale:1)
                        
                    case .failure(let error):
                        print("error--->",error)
                    }
                }
            }
        }
        cell.deleteBtnClick.tag = indexPath.item
        cell.deleteBtnClick.addTarget(self, action:#selector(deleteBtnPressed), for:.touchUpInside)
        return cell
    }
    @objc func deleteBtnPressed(sender:UIButton){
        let btnItem = sender.tag
        let myIndexPath = IndexPath(item: btnItem, section: 0)
        nowPlayingCV.deleteItems(at:[myIndexPath])
        let alert = UIAlertController(title:"Confirmation", message: "Do You want to delete?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.viewModelUser.arrMovies.remove(at: btnItem)
            self.nowPlayingCV.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModelUser.arrMovies[indexPath.item]
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMovieViewController")
            as! DetailMovieViewController
        if let desc = data.overview, !desc.isEmpty{
            detailVC.movieDesc = desc
        }
        if let title = data.title, !title.isEmpty{
            detailVC.movieTitle = title
        }
        if let backdropPath = data.backdrop_path{
            let posterImageURL = "\(commonURL.backDropBaseURL)\(backdropPath)"
            AF.request(posterImageURL, method: .get).response{ response in
                switch response.result {
                case .success(let responseData):
                    detailVC.movieImgData.image = UIImage(data: responseData!, scale:1)
                case .failure(let error):
                    print("error--->",error)
                }
            }
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension NowPlayingVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMovieTitle = viewModelUser.movieTitles.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        nowPlayingCV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        nowPlayingCV.reloadData()
    }
    
}
