

import UIKit

class NowPlayingCVC: UICollectionViewCell {
    
    @IBOutlet weak var lblOfMovieTitle: UILabel!
    
    @IBOutlet weak var movieImgData: UIImageView!
    
    @IBOutlet weak var lblOfMovieDescription: UILabel!
    
    @IBOutlet weak var deleteBtnClick: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
