//
//  Extensions.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 07.01.2021.
//

import UIKit

public protocol CellInstantiable {
    static var reuseId: String { get }
}

public extension CellInstantiable {
    
    static var reuseId: String {
        return String(describing: Self.self)
    }
    
}

public extension UIView {
    
    /**
     Add shadow to view
     
     - Parameters:
        - withColor: shadow color
        - opacity: shadow opacity
        - radius: shadow radius
        - xOffset: shadow horizontal offset
        - yOffset: shadow vertical offset
        - roundingCorners: shadows corners to round
        
    */
    func addShadow(withColor color: UIColor, opacity: Float = 0.3, radius: CGFloat = 10, xOffset: CGFloat = 0, yOffset: CGFloat = 0, roundingCorners: UIRectCorner = [.allCorners]) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        DispatchQueue.main.async {
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius)).cgPath
        }
    }
}

//    MARK: UIViewController

extension UIViewController {
    
    /**
     Presents an "Ok" alert
     
     - Parameters:
        - title: Alert title.
        - message: Alert message.
        - completionHandler: Completion handler. *Optional*.
    */
    public func presentAlert(withTitle title: String?, message: String?, completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completionHandler?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
