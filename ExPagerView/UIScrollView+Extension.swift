//
//  UIScrollView+Extension.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/03.
//

import UIKit

final class ForwardingDelegate: NSObject, UIScrollViewDelegate {
    weak var originalDelegate: UIScrollViewDelegate?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        originalDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        originalDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        originalDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
}

extension UIScrollView {
    private struct AssociatedKeys {
        static var forwardingDelegateKey = "forwardingDelegateKey"
        static var isUserScrollingKey = "isUserScrollingKey"
    }
    
    private var forwardingDelegate: ForwardingDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.forwardingDelegateKey) as? ForwardingDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.forwardingDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var isScrollingByUser: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isUserScrollingKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isUserScrollingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var scrollingByUser: Bool {
        isScrollingByUser
    }
    
    func setTrackingScroll() {
        // 기존 delegate 저장
        let originalDelegate = delegate
        
        // Forwarding delegate 생성
        let forwardingDelegate = ForwardingDelegate()
        forwardingDelegate.originalDelegate = originalDelegate
        
        // UIScrollView의 delegate에 기존 delegate와 forwarding delegate 모두 설정
        delegate = forwardingDelegate
        
        // forwardingDelegate에 대한 참조 저장
        self.forwardingDelegate = forwardingDelegate
    }
}
