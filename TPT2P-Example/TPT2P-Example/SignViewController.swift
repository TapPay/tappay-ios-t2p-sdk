//
//  SignViewController.swift
//  TPT2P-Example
//
//  Created by Luke Cho on 2023/8/2.
//

import Foundation
import UIKit
import PencilKit
import TPSDKT2P

protocol SignViewControllerDelegate {
    func didFinishSigning(controller: SignViewController)
}

class SignViewController: UIViewController {
    
    @IBOutlet weak var signatureView: UIView!
    var delegate: SignViewControllerDelegate?
    var receiptIdentifier: String?
    
    private let canvasView : PKCanvasView = {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        return canvas
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signatureView.addSubview(canvasView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.canvasView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(self.signatureView.frame), height: CGRectGetHeight(self.signatureView.frame))
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func reset(_ sender: Any) {
        canvasView.drawing = PKDrawing()
    }
    
    @IBAction func submit(_ sender: Any) {
        if let receiptIdentifier {
            Task {
                do {
                    try await TPT2PService.shared().createElectronicSignature(receiptIdentifier: receiptIdentifier, signCanvas: canvasView)
                    delegate?.didFinishSigning(controller: self)
                    DispatchQueue.main.async {
                        self.dismiss(animated: false)
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
}
