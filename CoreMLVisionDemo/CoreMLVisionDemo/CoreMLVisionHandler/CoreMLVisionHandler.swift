//
//  CoreMLVisionHandler.swift
//  CoreMLVisionDemo
//
//  Created by Subhra Roy on 08/04/19.
//  Copyright © 2019 Subhra Roy. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

protocol CoreMLVisionProtocol : NSObjectProtocol {
    func processClassifications(for request: VNRequest, error: Error?)
}

class CoreMLVisionHandler: NSObject {

    private weak var visionDelegate : CoreMLVisionProtocol?
    
    convenience  init( _ delegate : CoreMLVisionProtocol?) {
        self.init()
        self.visionDelegate = delegate
    }
    
    private override init() {
        super.init()
    }
    
    
    // MARK: - Image Classification
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model : VNCoreMLModel = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.visionDelegate?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        
        let orientation : CGImagePropertyOrientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    deinit {
        print("CoreMLVisionHandler dealloc")
    }
    
}
