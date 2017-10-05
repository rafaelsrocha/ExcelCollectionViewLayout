//
//  ExcelCollectionViewLayout.swift
//  ExcelCollectionViewLayout
//
//  Created by Rafael Rocha on 10/2/17.
//

import UIKit

@objc public protocol ExcelCollectionViewLayoutDelegate {
    /**
     Calculate items' size at a particular column here.
     
     - parameters:
         - collectionViewLayout: The current ExcelCollectionViewLayout placed in UICollectionView.
         - columnIndex: The index of column which its items' size will be calculated.
     
     - returns:
     A CGSize representation for items at a particular column index.
    */
    @objc func collectionViewLayout(_ collectionViewLayout: ExcelCollectionViewLayout, sizeForItemAtColumn columnIndex: Int) -> CGSize
}

public class ExcelCollectionViewLayout: UICollectionViewLayout {
    
    public weak var delegate: ExcelCollectionViewLayoutDelegate?
    private var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    private var itemsSize = [CGSize]()
    private var contentSize: CGSize = .zero
    private var numberOfColumns: Int {
        guard collectionView != nil else { fatalError("collectionView must not be nil. See the README for more details.") }
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    override public func prepare() {
        guard let collectionView = collectionView else { fatalError("collectionView must not be nil. See the README for more details.") }
        guard collectionView.numberOfSections != 0 else { return }
        
        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if section != 0 && item != 0 {
                    continue
                }
                
                let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))!
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                
                if item == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
            }
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            
            attributes.append(contentsOf: filteredArray)
        }
        
        return attributes
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // MARK: - Helpers
    
    private func generateItemAttributes(collectionView: UICollectionView) {
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024
                } else if section == 0 || index == 0 {
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
    private func calculateItemSizes() {
        guard delegate != nil else {
            fatalError("delegate must be set in order to calculate items' size. See the README for more details.")
        }
        
        itemsSize = []
        
        for index in 0..<numberOfColumns {
            itemsSize.append(delegate!.collectionViewLayout(self, sizeForItemAtColumn: index))
        }
    }
}
