//
//  ScrollFitable.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/03.
//

import UIKit

// Use this protocol to fitting scroll
protocol ScrollFitable: AnyObject {
    var scrollView: UIScrollView { get }
    var countOfItems: Int { get }
    
    func scroll(to index: Int)
    func scroll(to ratio: Double)
}

extension ScrollFitable {
    func scroll(to index: Int) {
        let offset = getStartOffset(index: index)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func scroll(to ratio: Double) {
        let rect = getTargetRect(ratio: ratio)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    private func getStartOffset(index: Int) -> CGPoint {
        let totalWidth = scrollView.contentSize.width
        let widthPerItem = totalWidth / Double(countOfItems)
        let startOffsetX = widthPerItem * Double(index)
        return .init(
            x: startOffsetX,
            y: scrollView.contentOffset.y
        )
    }
    
    private func getTargetRect(ratio: Double) -> CGRect {
        let totalWidth = scrollView.contentSize.width
        
        let rect = CGRect(
            x: totalWidth * ratio,
            y: scrollView.frame.minY,
            width: scrollView.frame.width,
            height: scrollView.frame.height
        )
        return rect
    }
}
