//
//  LFKit.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/16/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import Foundation
import UIKit
import LFLiveKit

class LFKit : UIViewController, LFLiveSessionDelegate {
    
    var passedStreamKey : String = "rtmp://54.201.16.95:1935/live/"
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        containerView.addSubview(stateLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(startLiveButton)
        
        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)

        startLiveButton.addTarget(self, action: #selector(didTappedStartLiveButton(_:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: AccessAuth
    
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo);
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeAudio)
        switch status  {
            
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted) in
            })
            break;
        case AVAuthorizationStatus.authorized:
            break;
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callbacks
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "Ready"
            break;
        case LFLiveState.pending:
            stateLabel.text = "Pending"
            break;
        case LFLiveState.start:
            stateLabel.text = "Start"
            break;
        case LFLiveState.error:
            stateLabel.text = "Error"
            break;
        case LFLiveState.stop:
            stateLabel.text = "Stop"
            break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
    func didTappedStartLiveButton(_ button: UIButton) -> Void {
        startLiveButton.isSelected = !startLiveButton.isSelected;
        if (startLiveButton.isSelected) {
            let stopLiveImg = UIImage(named: "stopButton")
            startLiveButton.setImage(stopLiveImg, for: UIControlState())
            let stream = LFLiveStreamInfo()
            stream.url = String(self.passedStreamKey)
//            stream.url = "rtmp://54.201.16.95:1935/live_test/test"
            print(type(of: stream.url))
            print(stream.url)
            session.startLive(stream)
        } else {
            let startLiveImg = UIImage(named: "button")
            startLiveButton.setImage(startLiveImg, for: UIControlState())
            session.stopLive()
        }
    }
    
    func didTappedCameraButton(_ button: UIButton) -> Void {
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevicePosition.back) ? AVCaptureDevicePosition.front : AVCaptureDevicePosition.back;
    }

    func didTappedCloseButton(_ button: UIButton) -> Void  {
        
    }
    
    //MARK: - Getters and Setters
    
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        containerView.backgroundColor = UIColor.clear
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
        return containerView
    }()
    
    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        stateLabel.text = "Not Connected"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 10 - 44, y: 20, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "close_preview"), for: UIControlState())
        return closeButton
    }()
    
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 2, y: 20, width: 44, height: 44))
        cameraButton.setImage(UIImage(named: "camra_preview"), for: UIControlState())
        return cameraButton
    }()
    
    var startLiveButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let startLiveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        startLiveButton.center = CGPoint(x: w / 2, y : h * 0.8)
        startLiveButton.layer.cornerRadius = 22
        
        let startLiveImg = UIImage(named: "button")
        startLiveButton.setImage(startLiveImg, for: UIControlState())
        startLiveButton.setTitleColor(UIColor.black, for:UIControlState())
        startLiveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        return startLiveButton
    }()
    
    
}

