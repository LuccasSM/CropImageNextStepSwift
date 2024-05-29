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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Biometria facial"
        configNavbar()
        setCamera()
        setItens()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tapCount = 0
    }
    
    lazy var faceFrame: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "faceFrame")
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var viewBorderTop: UIView = {
        let border = ViewBorder().setBorders()
        return border
    }()
    
    lazy var viewBorderLeft: UIView = {
        let border = ViewBorder().setBorders()
        return border
    }()
    
    lazy var viewBorderRight: UIView = {
        let border = ViewBorder().setBorders()
        return border
    }()
    
    lazy var viewBorderBottom: UIView = {
        let border = ViewBorder().setBorders()
        return border
    }()
    
    lazy var viewBorderFooter: UIView = {
        let border = ViewBorder().setBorders()
        border.backgroundColor = .black
        border.layer.opacity = 1
        return border
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cameraButton"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.layer.zPosition = 2
        button.addTarget(self, action: #selector(capturePhoto), for: .touchDown)
        return button
    }()
    
    func setItens() {
        view.addSubview(faceFrame)
        view.addSubview(viewBorderTop)
        view.addSubview(viewBorderLeft)
        view.addSubview(viewBorderRight)
        view.addSubview(viewBorderBottom)
        view.addSubview(viewBorderFooter)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            faceFrame.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -100),
            faceFrame.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6),
            faceFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceFrame.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            viewBorderTop.widthAnchor.constraint(equalTo: view.widthAnchor),
            viewBorderTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewBorderTop.bottomAnchor.constraint(equalTo: faceFrame.topAnchor),
            
            viewBorderLeft.topAnchor.constraint(equalTo: viewBorderTop.safeAreaLayoutGuide.bottomAnchor),
            viewBorderLeft.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewBorderLeft.rightAnchor.constraint(equalTo: faceFrame.leftAnchor),
            viewBorderLeft.bottomAnchor.constraint(equalTo: viewBorderBottom.topAnchor),
            
            viewBorderRight.topAnchor.constraint(equalTo: viewBorderTop.safeAreaLayoutGuide.bottomAnchor),
            viewBorderRight.leftAnchor.constraint(equalTo: faceFrame.rightAnchor),
            viewBorderRight.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewBorderRight.bottomAnchor.constraint(equalTo: viewBorderBottom.topAnchor),
            
            viewBorderBottom.widthAnchor.constraint(equalTo: view.widthAnchor),
            viewBorderBottom.topAnchor.constraint(equalTo: faceFrame.bottomAnchor),
            viewBorderBottom.bottomAnchor.constraint(equalTo: viewBorderFooter.topAnchor),
            
            viewBorderFooter.widthAnchor.constraint(equalTo: view.widthAnchor),
            viewBorderFooter.topAnchor.constraint(equalTo: button.safeAreaLayoutGuide.topAnchor, constant: -12),
            viewBorderFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            button.widthAnchor.constraint(equalToConstant: 65),
            button.heightAnchor.constraint(equalToConstant: 65),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func setCamera() {
        captureSession = AVCaptureSession()
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.addInput(input)
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
            
            photoOutput = AVCapturePhotoOutput()
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
    
    @objc private func capturePhoto(_ btn: UIButton) {
        self.animateButton(btn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
            self.tapCount += 1
            if self.tapCount == 1 {
                let photoSettings = AVCapturePhotoSettings()
                photoSettings.isAutoStillImageStabilizationEnabled = true
                self.photoOutput?.capturePhoto(with: photoSettings, delegate: self)
            }
        })
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        detectFaces(in: image) { [weak self] hasFace in
            if hasFace {
                DispatchQueue.main.async {
                    let resultViewController = ResultViewController()
                    resultViewController.image = image
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
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
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
        
        do {
            try handler.perform([request])
        } catch {
            print("Face detection error: \(error)")
            completion(false)
        }
    }
}
