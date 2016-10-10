//
//  ViewController.swift
//  ScreenRecording
//
//  Created by Ken Tominaga on 10/10/16.
//  Copyright © 2016 Ken Tominaga. All rights reserved.
//

import UIKit
import ReplayKit

final class ViewController: UIViewController {

    @IBOutlet private weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            let num = Int(self.label.text!)! + 1
            self.label.text = "\(num)"
        }
    }

    @IBAction func startRecording() {

        let sharedRecorder = RPScreenRecorder.shared()
        sharedRecorder.delegate = self

        print(sharedRecorder.isAvailable)

        sharedRecorder.startRecording { error in
            print(error.debugDescription)
        }
    }

    @IBAction func stopRecording() {

        let sharedRecorder = RPScreenRecorder.shared()
        print(sharedRecorder.isRecording)

        sharedRecorder.stopRecording { [unowned self] previewViewController, error in

            guard let previewViewController = previewViewController else {
                return
            }

            previewViewController.previewControllerDelegate = self

            DispatchQueue.main.async { [unowned self] in
                self.present(previewViewController, animated: true, completion: nil)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: RPScreenRecorderDelegate {

    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print(screenRecorder.isAvailable)
    }

    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        print(error.localizedDescription)
    }
}

extension ViewController: RPPreviewViewControllerDelegate {

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }

    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        if activityTypes.contains("com.apple.UIKit.activity.SaveToCameraRoll") {
            print("Save to CameraRoll")
            // do something
        }
    }
}

