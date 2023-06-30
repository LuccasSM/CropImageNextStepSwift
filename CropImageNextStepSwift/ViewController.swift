//
//  ViewController.swift
//  CropImageNextStepSwift
//
//  Created by Luccas Santana Marinho on 29/06/23.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!
    var tapCount = 0
    
    // MARK: Setup lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupCamera()
        setupItens()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tapCount = 0
    }
    
    // MARK: Setup views in screen
    
    lazy private var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 32
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return button
    }()
    
    // MARK: Setup itens
    
    func setupItens() {
        view.addSubview(button)
        
        button.widthAnchor.constraint(equalToConstant: 64).isActive = true
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.addInput(input)
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 4 - 42.5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 + 85)
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
            
            photoOutput = AVCapturePhotoOutput()
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
    
    @objc func capturePhoto() {
        tapCount += 1
        
        if tapCount == 1 {
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.isAutoStillImageStabilizationEnabled = true
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
        
        detectFaces(in: image) { [weak self] hasFace in
            if hasFace {
                DispatchQueue.main.async {
                    let resultViewController = ResultViewController(image: image)
                    self?.navigationController?.pushViewController(resultViewController, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Erro", message: "Por favor, posicione corretamente seu rosto no molde.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                        self?.tapCount = 0
                    })
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    func detectFaces(in image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let ciImage = CIImage(image: image) else { return }
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                print("Face detection error: \(error)")
                completion(false)
                return
            }
            
            guard let results = request.results as? [VNFaceObservation] else {
                completion(false)
                return
            }
            
            completion(!results.isEmpty)
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Face detection error: \(error)")
            completion(false)
        }
    }
}

