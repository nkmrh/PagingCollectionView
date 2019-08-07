import UIKit

final class Cell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
}
