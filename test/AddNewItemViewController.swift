//
//  AddNewItemViewController.swift
//  test
//
//  Created by Johan K. Jensen on 05/09/2015.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import AVFoundation

class AddNewItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let captureSession = AVCaptureSession()
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.delegate = self
//        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if (device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Cell Text"
        cell.detailTextLabel?.text = "Value"
        return cell
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.cameraView.layer.frame
        captureSession.startRunning()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
