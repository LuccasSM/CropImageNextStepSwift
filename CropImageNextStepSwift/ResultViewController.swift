//
//  ResultViewController.swift
//  CropImageNextStepSwift
//
//  Created by Luccas Santana Marinho on 29/06/23.
//

import UIKit

class ResultViewController: UIViewController {
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavbar()
        setImageView()
        setNavigationsSettings()
    }
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = self.image
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight,
            .flexibleBottomMargin,
            .flexibleRightMargin,
            .flexibleLeftMargin,
            .flexibleTopMargin
        ]
        return image
    }()
    
    func setImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    func setNavigationsSettings() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Voltar",
            style: .done,
            target: self,
            action: #selector(didTapReturn)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Prosseguir",
            style: .done,
            target: self,
            action: #selector(didTapProgress)
        )
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white],for: .normal)
    }
    
    @objc func didTapReturn() {
        navigationController?.popViewController(animated: true)
    }

    @objc func didTapProgress() {
        let alert = UIAlertController(title: "Sucesso", message: "Seguir com a imagem capturada para a próxima tela.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}
