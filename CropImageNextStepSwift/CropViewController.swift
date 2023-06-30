//
//  CropViewController.swift
//  CropImageNextStepSwift
//
//  Created by Luccas Santana Marinho on 29/06/23.
//

import UIKit

class ResultViewController: UIViewController {
    let imageView = UIImageView()
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }
    
    func setupImageView() {
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 4 - 42.5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 + 85)
        
        view.addSubview(imageView)
        
        setupNavigationsSettings()
    }
    
    func setupNavigationsSettings() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Voltar", style: .done, target: self, action: #selector(didTapReturn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Prosseguir", style: .done, target: self, action: #selector(didTapProgress))

        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
                    NSAttributedString.Key.foregroundColor: UIColor.white],
                for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
                    NSAttributedString.Key.foregroundColor: UIColor.white],
                for: .normal)
    }
    
    @objc func didTapReturn() {
        navigationController?.popViewController(animated: true)
    }

    @objc func didTapProgress() {
        print("Próxima tela")
    }
}
