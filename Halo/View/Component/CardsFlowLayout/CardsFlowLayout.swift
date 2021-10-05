//
//  CardsFlowLayout.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import UIKit

@objc protocol CardsLayoutDelegate {

       /**
        Height for image view in cell.
        
        @param collectionView - collectionView
        @param indexPath - index path for cell
        
        Returns height of image view.
        */
       func collectionView(collectionView: UICollectionView,
                           heightForImageAtIndexPath indexPath: IndexPath,
                           withWidth: CGFloat) -> CGFloat

       /**
        Height for annotation view (label) in cell.
        
        @param collectionView - collectionView
        @param indexPath - index path for cell
        
        Returns height of annotation view.
        */
       func collectionView(collectionView: UICollectionView,
                           heightForAnnotationAtIndexPath indexPath: IndexPath,
                           withWidth: CGFloat) -> CGFloat
}

class CardsFlowLayout: UICollectionViewLayout {

    /**
     Delegate.
     */
    public weak var delegate: CardsLayoutDelegate!
    /**
     Number of columns.
     */
    public var numberOfColumns: Int = 2
    /**
     Cell padding.
     */
    public var cellPadding: CGFloat = 6

    private var cache = [PinterestLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        let bounds = collectionView.bounds
        let insets = collectionView.contentInset
        return bounds.width - insets.left - insets.right
    }

    override public var collectionViewContentSize: CGSize {
        return CGSize(
            width: contentWidth,
            height: contentHeight
        )
    }

    override public class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }

    override public var collectionView: UICollectionView {
        return super.collectionView!
    }

    private var numberOfSections: Int {
        return collectionView.numberOfSections
    }

    private func numberOfItems(inSection section: Int) -> Int {
        return collectionView.numberOfItems(inSection: section)
    }

    /**
     Invalidates layout.
     */
    override public func invalidateLayout() {
        cache.removeAll()
        contentHeight = 0

        super.invalidateLayout()
    }

    override public func prepare() {
        if cache.isEmpty {
            let collumnWidth = contentWidth / CGFloat(numberOfColumns)
            let cellWidth = collumnWidth - (cellPadding * 2)

            var xOffsets = [CGFloat]()

            for collumn in 0..<numberOfColumns {
                xOffsets.append(CGFloat(collumn) * collumnWidth)
            }

            for section in 0..<numberOfSections {
                let numberOfItems = self.numberOfItems(inSection: section)

                var yOffsets = [CGFloat](
                    repeating: contentHeight,
                    count: numberOfColumns
                )

                for item in 0..<numberOfItems {
                    let indexPath = IndexPath(item: item, section: section)

                    let column = yOffsets.firstIndex(of: yOffsets.min() ?? 0) ?? 0

                    let imageHeight = delegate.collectionView(
                        collectionView: collectionView,
                        heightForImageAtIndexPath: indexPath,
                        withWidth: cellWidth
                    )
                    let annotationHeight = delegate.collectionView(
                        collectionView: collectionView,
                        heightForAnnotationAtIndexPath: indexPath,
                        withWidth: cellWidth
                    )
                    let cellHeight = cellPadding + imageHeight + annotationHeight + cellPadding

                    let frame = CGRect(
                        x: xOffsets[column],
                        y: yOffsets[column],
                        width: collumnWidth,
                        height: cellHeight
                    )

                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    let attributes = PinterestLayoutAttributes(
                        forCellWith: indexPath
                    )
                    attributes.frame = insetFrame
                    attributes.imageHeight = imageHeight
                    cache.append(attributes)

                    contentHeight = max(contentHeight, frame.maxY)
                    yOffsets[column] = yOffsets[column] + cellHeight
                }
            }
        }
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }
}

public class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    /**
     Image height to be set to contstraint in collection view cell.
     */
    public var imageHeight: CGFloat = 0

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? PinterestLayoutAttributes
        copy?.imageHeight = imageHeight
        return copy ?? ""
    }

    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}
