//
//  LiveKitVC.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/3/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import UIKit
import LFLiveKit

class LiveKitVC: UIViewController, LFLiveSessionDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        containerView.addSubview(stateLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(beautyButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(startLiveButton)
        
        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
        beautyButton.addTarget(self, action: #selector(didTappedBeautyButton(_:)), for: .touchUpInside)
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
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeAudio)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted) in
                
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callbacks
    
    // 回调
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(String(describing: debugInfo?.currentBandwidth))")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "Not connected"
            break;
        case LFLiveState.pending:
            stateLabel.text = "Connecting..."
            break;
        case LFLiveState.start:
            stateLabel.text = "Connected!"
            break;
        case LFLiveState.error:
            stateLabel.text = "Connection error"
            break;
        case LFLiveState.stop:
            stateLabel.text = "Not connected"
            break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
    // 开始直播
    func didTappedStartLiveButton(_ button: UIButton) -> Void {
        startLiveButton.isSelected = !startLiveButton.isSelected;
        if (startLiveButton.isSelected) {
            startLiveButton.setTitle("End Live", for: UIControlState())
            let stream = LFLiveStreamInfo()
            stream.url = "rtmp://54.201.16.95/live/"
            //rtmp://live.hkstv.hk.lxdns.com:1935/live/stream153
            session.startLive(stream)
        } else {
            startLiveButton.setTitle("Start Live", for: UIControlState())
            session.stopLive()
        }
    }
    
    // 美颜
    func didTappedBeautyButton(_ button: UIButton) -> Void {
        session.beautyFace = !session.beautyFace;
        beautyButton.isSelected = !session.beautyFace
    }
    
    // 摄像头
    func didTappedCameraButton(_ button: UIButton) -> Void {
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevicePosition.back) ? AVCaptureDevicePosition.front : AVCaptureDevicePosition.back;
    }
    
    // 关闭
    func didTappedCloseButton(_ button: UIButton) -> Void  {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Getters and setters
    
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    // View
    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        containerView.backgroundColor = UIColor.clear
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
        return containerView
    }()
    
    // Status Label
    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        stateLabel.text = "Not connected"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    // Close button
    var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 10 - 44, y: 20, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "close_preview"), for: UIControlState())
        return closeButton
    }()
    
    // Camera
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 2, y: 20, width: 44, height: 44))
        cameraButton.setImage(UIImage(named: "camra_preview"), for: UIControlState())
        return cameraButton
    }()
    
    // Beauty
    var beautyButton: UIButton = {
        let beautyButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 3, y: 20, width: 44, height: 44))
        beautyButton.setImage(UIImage(named: "camra_beauty"), for: UIControlState.selected)
        beautyButton.setImage(UIImage(named: "camra_beauty_close"), for: UIControlState())
        return beautyButton
    }()
    
    // Start Live Button
    var startLiveButton: UIButton = {
        let startLiveButton = UIButton(frame: CGRect(x: 30, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width - 10 - 44, height: 44))
        startLiveButton.layer.cornerRadius = 22
        startLiveButton.setTitleColor(UIColor.black, for:UIControlState())
        startLiveButton.setTitle("Start Live", for: UIControlState())
        startLiveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        startLiveButton.backgroundColor = UIColor(colorLiteralRed: 50, green: 32, blue: 245, alpha: 1)
        return startLiveButton
    }()

}
