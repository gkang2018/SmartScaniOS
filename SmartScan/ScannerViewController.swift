//
//  ScannerViewController.swift
//  SmartScan
//
//  Created by Joshua Diamond on 2/8/20.
//  Copyright © 2020 Gagandeep Kang. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var testedIngredients: String = ""
    var product: String = ""
    var brand: String = ""
    var ingredients: [String] = []
    var light: String =  ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

    }

    func found(code: String) {
        let createRequest = APIRequest.init(data: code)
        createRequest.makeGetRequest()
        let data = createRequest.foodDataModel
        if data.isEmpty {
                let alert = UIAlertController(title: "Food Data Not Found", message: "Data for the corresponding barcode could not be found", preferredStyle: .alert)


                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel
                    , handler: {action in
                        self.viewDidLoad()
                })

                alert.addAction(cancelAction)

            present(alert, animated: true,
                    completion: nil)

        }
        else {
                self.brand = data.foodBrand
                self.ingredients = data.ingredients
                self.testedIngredients = data.testedIngredients
                self.light = data.light
                self.product = data.product
                
                performSegue(withIdentifier: "moveToData", sender: self)
         }
        
    
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToData" {
            let vc = segue.destination as! DataViewController
            vc.brand = self.brand
            vc.ingredients = self.ingredients
            vc.testedIngredients = self.testedIngredients
            vc.light = self.light
            vc.product = self.product
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
    //MARK: - Networking
    
    
}
