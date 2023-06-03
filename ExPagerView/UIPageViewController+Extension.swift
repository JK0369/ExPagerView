//
//  UIPageViewController+Extension.swift
//  ExPagerView
//
//  Created by 김종권 on 2023/06/02.
//

import UIKit

extension UIPageViewController {
    var scrollView: UIScrollView? {
        view.subviews.first as? UIScrollView
    }
}
