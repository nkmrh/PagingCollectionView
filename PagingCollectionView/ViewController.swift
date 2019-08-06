import UIKit

final class ViewController: UICollectionViewController {

    private var cellSize: CGSize {
        let width = collectionView.bounds.width * 0.8
        let height = width * Cell.aspectRatio
        return CGSize(width: width, height: height)
    }

    private var headerSize: CGSize {
        let width = collectionView.bounds.width * 0.6
        return CGSize(width: width, height: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.decelerationRate = .fast

        let flowLayout = collectionViewLayout as! FlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = cellSize
        flowLayout.minimumInteritemSpacing = collectionView.bounds.height
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = "\(indexPath.row)"
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let collectionView = scrollView as! UICollectionView
        (collectionView.collectionViewLayout as! FlowLayout).prepareForPaging()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return headerSize
    }
}
