//
//  HETableView.swift
//  HorizontalEntry
//
//  Created by Kevin Yu on 9/27/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

// lots of cool ideas and inspiration by this neat fellow:
// http://www.vadimbulavin.com/tableviewcell-display-animation/?utm_campaign=AppCoda%20Weekly&utm_medium=email&utm_source=Revue%20newsletter

// can we better expand this as an extension?

import UIKit

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

extension UITableView {
    open func slideInAnimation(duration durationFactor: TimeInterval,
                               delay delayFactor: TimeInterval,
                               for cell: UITableViewCell,
                               at indexPath: IndexPath) {
        let animation = HETableView.makeSlideIn(duration: durationFactor,
                                                delayFactor: delayFactor)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: self)
    }
}

private final class HETableView {
    
    public class func performAnimation(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //let animation = makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 1.0, delayFactor: 0.05)
        let animation = HETableView.makeSlideIn(duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    static func makeMoveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}

final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        animation(cell, indexPath, tableView)
        
        //  hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
    
}
