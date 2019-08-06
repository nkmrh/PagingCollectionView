import UIKit

final class FlowLayout: UICollectionViewFlowLayout {

    private var layoutAttributesForPaging: [UICollectionViewLayoutAttributes]?

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        let expansionMargin = sectionInset.left + sectionInset.right
        let expandedVisibleRect = CGRect(x: collectionView.contentOffset.x - expansionMargin,
                                         y: 0,
                                         width: collectionView.bounds.width + (expansionMargin * 2),
                                         height: collectionView.bounds.height)
        guard let targetAttributes = layoutAttributesForElements(in: expandedVisibleRect)?
            .sorted(by: { $0.frame.minX < $1.frame.minX }) else { return proposedContentOffset }

        let nextAttributes: UICollectionViewLayoutAttributes?
        if velocity.x == 0 {
            // スワイプせずに指を離した場合は、画面中央から一番近い要素を取得する
            nextAttributes = layoutAttributesForNearbyCenterX(in: targetAttributes, collectionView: collectionView)
        } else if velocity.x > 0 {
            // 左スワイプの場合は、最後の要素を取得する
            nextAttributes = targetAttributes.last
        } else {
            // 右スワイプの場合は、先頭の要素を取得する
            nextAttributes = targetAttributes.first
        }
        guard let attributes = nextAttributes else { return proposedContentOffset }

        if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
            // ヘッダーの場合は先頭の座標を返す
            return CGPoint(x: 0, y: collectionView.contentOffset.y)
        } else {
            // 画面左端からセルのマージンを引いた座標を返し、画面中央に表示されるようにする
            let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5
            return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: collectionView.contentOffset.y)
        }
    }

    // 画面中央に一番近いセルの attributes を取得する
    private func layoutAttributesForNearbyCenterX(in attributes: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> UICollectionViewLayoutAttributes? {
        let screenCenterX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
        let result = attributes.reduce((attributes: nil as UICollectionViewLayoutAttributes?, distance: CGFloat.infinity)) { result, attributes in
            let distance = attributes.frame.midX - screenCenterX
            return abs(distance) < abs(result.distance) ? (attributes, distance) : result
        }
        return result.attributes
    }
}
