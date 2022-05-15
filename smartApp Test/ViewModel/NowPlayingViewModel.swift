
import Foundation
import Alamofire

class NowPlayingMoviesViewModel{
    weak var vc: NowPlayingVC?
    var arrMovies = [Results]()
    var movieTitles = [String]()
    
    
    func getAllUsreDataAF(){
        AF.request(commonURL.nowPlayingBaseURL,method: .get).response { response in
            if let data = response.data {
                do{
                    let userResponse = try JSONDecoder().decode(NowPlayingMovies.self, from: data)
                    self.arrMovies = userResponse.results ?? []
                    self.movieTitles = self.arrMovies.map({$0.title ?? ""})
                    DispatchQueue.main.async{
                        self.vc?.nowPlayingCV.reloadData()
                    }
                }catch let err{
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    
    
    
}
