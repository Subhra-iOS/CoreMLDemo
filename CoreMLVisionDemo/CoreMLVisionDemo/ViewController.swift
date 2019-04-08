//
//  ViewController.swift
//  CoreMLVisionDemo
//
//  Created by Subhra Roy on 07/04/19.
//  Copyright © 2019 Subhra Roy. All rights reserved.
// defaults write com.apple.finder AppleShowAllFiles TRUE

import UIKit
import Foundation
import Vision


class ViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnMedia(_ sender: Any) {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    private func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
    let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.productImageView.image = image
        self.productDesLabel.text = "Classifying..."
        self.createVisionHandlerWith(image)
    }
    
    private func createVisionHandlerWith( _ image : UIImage) -> Void{
        
        let visionObj : CoreMLVisionHandler = CoreMLVisionHandler(self)
        visionObj.updateClassifications(for: image)
        
    }
    
}

extension ViewController : CoreMLVisionProtocol{
    
    func processClassifications(for request: VNRequest, error: Error?){
        DispatchQueue.main.async { [unowned self] in
            guard let results = request.results else {
                self.productDesLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.productDesLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.productDesLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
    
}
