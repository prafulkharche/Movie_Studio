

import UIKit

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var movieImgData: UIImageView!
    @IBOutlet weak var lblOfMovieDescription: UILabel!
    var movieDesc = ""
    var movieTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = movieTitle
        lblOfMovieDescription.text = movieDesc
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}
