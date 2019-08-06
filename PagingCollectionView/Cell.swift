import UIKit

final class Cell: UICollectionViewCell {
    @IBOutlet var label: UILabel!

    static let aspectRatio: CGFloat = 4 / 3

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }
}
