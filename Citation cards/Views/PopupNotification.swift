//
//  PopupNotification.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 10.11.2023.
//

import UIKit

protocol PopupNotificationProtocol {
    func setConnectedController(_ controller: UIViewController)
    func displayNotification(withCaption: String) -> Void
}

class PopupNotification: UIView, PopupNotificationProtocol {
    private var connectToView: UIViewController?
    private var label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private var yFromBottom: CGFloat = 132
    private var animationDuration: TimeInterval = 0.1
    private var delayDuration: TimeInterval = 2.8

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0 , height: 0))
        self.backgroundColor = .gray
        self.layer.cornerRadius = 20

        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setConnectedController(_ controller: UIViewController) {
        // on connect set the sizes and bounds
        self.connectToView = controller
        self.frame = CGRect(x: 0, y: connectToView!.view.bounds.height - yFromBottom, width: connectToView!.view.bounds.width, height: 40)
        self.frame = (self.frame.insetBy(dx: 20, dy: 0))
        label.frame = self.bounds
        label.bounds = label.bounds.insetBy(dx: 4, dy: 4)
    }
    
    public func displayNotification(withCaption caption: String) {
        label.text = caption
        
        UIView.transition(with: self, duration: animationDuration, options: .curveEaseInOut, animations: {
            self.connectToView!.tabBarController?.view.addSubview(self)
            self.center.y += 1
        }, completion: { _ in
            UIView.animate(withDuration: self.animationDuration, delay: self.delayDuration, options: .curveEaseInOut) {
                self.center.y -= 1
            } completion: { finished in
                self.removeFromSuperview()
            }
        })
    }
}
