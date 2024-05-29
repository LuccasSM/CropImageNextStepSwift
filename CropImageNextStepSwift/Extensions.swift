//
//  Extensions.swift
//  CropImageNextStepSwift
//
//  Created by Luccas Santana Marinho on 29/05/24.
//

import UIKit

extension UIViewController {
    func configNavbar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        appearance.shadowColor = .clear
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func animateButton(_ button: UIButton) {
        UIView.animate(
            withDuration: 0.1, animations: {
                button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = CGAffineTransform.identity
                }
            }
        )
    }
}

class ViewBorder: UIView {
    func setBorders() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.opacity = 0.8
        return view
    }
}
