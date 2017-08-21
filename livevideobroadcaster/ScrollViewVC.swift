//
//  ScrollViewVC.swift
//  livevideobroadcaster
//
//  Created by Jaseem on 8/3/17.
//  Copyright © 2017 Fanstories. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import LFLiveKit

class ScrollViewVC : UIViewController, LFLiveSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pageObject = Pages()
    var liveGateway = LiveGateway()
    var streamKey : String = ""
    var userSession = UserDefaults()

    @IBOutlet weak var widthConstraintShareMessage: NSLayoutConstraint!
    @IBOutlet weak var botConstraintRecordButton: NSLayoutConstraint!
    @IBOutlet weak var botConstraintBlogSelect: NSLayoutConstraint!
    @IBOutlet weak var StackBlogSelect: UIStackView!
    @IBOutlet weak var shareContentStack: UIStackView!
    @IBOutlet weak var shareLinkStack: UIStackView!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var selectBlogLabel: UILabel!
    var timerSeconds = 4
    var isCountdownFinished = false
    var countdownTimer = Timer()
    var onAirTimer = Timer()
    
    let stream = LFLiveStreamInfo()
    
    var isStreaming = false
    var isLivePrepared = false
    var isPageSelectExpanded : Bool = true
    var isShareToFBExpanded : Bool = false
    var passedToken : String = "Bearer "
    let const = Constants()
    var token = Token()
    var currentCell : String = ""
    var selectedPageBlogUrl = ""
    var selectedPageVerified = ""
    var selectedPageBlogId = ""
    var retrievedStreamKey = ""
    let startLiveImg = UIImage(named: "liveButton")
    let stopLiveImg = UIImage(named: "stopButton")

    @IBOutlet weak var StackScrollView: UIStackView!
    
    var pageNames = [String]()
    var selectedPageDetails = [String : Any]()
    
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var viewCell1: viewCell!
    
    
//    let collectionView : UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor.darkGray
//        
//        return cv
//    }()
//    let cellId = "blogCell"
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(stateLabel)
        self.view.addSubview(closeButton)
        self.view.addSubview(cameraButton)
        self.view.addSubview(startLiveButton)
        
        userSession = UserDefaults()
        
        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
        
        startLiveButton.addTarget(self, action: #selector(didTappedStartLiveButton(_:)), for: .touchUpInside)
        
        retrievePages()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blogCell", for: indexPath) as! viewCell
        
        let cellImage = UIImage(named: "page_select_background")
        let cellImageHighlighted = UIImage(named: "page_select_background_selected")
        
        cell.textLabel.text = self.pageNames[indexPath.row]
        cell.imageView.image = cellImage
        cell.imageView.highlightedImage = cellImageHighlighted
        
        cell.textLabel.highlightedTextColor = UIColor.white
        cell.imageView.layer.cornerRadius = 15.0
        cell.imageView.clipsToBounds = true
        
        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.contentView.layer.shadowRadius = 7.5
        cell.contentView.layer.shadowOpacity = 1.0
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? viewCell
                self.currentCell = (cell?.textLabel.text!)!
        
                pageObject.getPageDetails(authToken: passedToken, pageName: currentCell, completion: { (detailPage) in
                    if (detailPage != nil) {
                        print("Succeeded in retrieving detail page")
                        self.selectedPageDetails = detailPage!
                    }
        
                    else {
                        print("Detail Page failed")
                    }
                })

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                return CGSize(width: CGFloat((view.bounds.width) / 2.5), height: view.bounds.height * 0.15)
            }
    
    
//    func setupCV() {
//        self.view.addSubview(collectionView)
//        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView.frame = CGRect(x: 0, y: view.bounds.height * 0.8, width: view.bounds.width, height: view.bounds.height * 0.2)
//        collectionView.clipsToBounds = true
//    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return pageNames.count
//    }

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return pageNames.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blogCell", for: indexPath) as! ImageCollectionViewCell
//        
//        let cellImage = UIImage(named: "page_select_background")!
//        let highlightedCellImage = UIImage(named: "page_select_background_selected")!
//        
//        cell.textLabel.text = pageNames[indexPath.row]
//        cell.imageViewCell.image = cellImage
//        cell.imageViewCell.highlightedImage = highlightedCellImage
//        cell.textLabel.highlightedTextColor = UIColor.white
//        cell.imageViewCell.layer.cornerRadius = 15.0
//        cell.imageViewCell.clipsToBounds = true
//        
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blogCell", for: indexPath) as! ImageCollectionViewCell
//        
//        let cellImage = UIImage(named: "page_select_background")!
//        let highlightedCellImage = UIImage(named: "page_select_background_selected")!
//        
//        print("PAGE NAME PRINT")
//        print(pageNames)
//        cell.textLabel.text = pageNames[indexPath.row]
//        cell.imageViewCell.image = cellImage
//        cell.imageViewCell.highlightedImage = highlightedCellImage
//        cell.textLabel.highlightedTextColor = UIColor.white
//        cell.imageViewCell.layer.cornerRadius = 15.0
//        cell.imageViewCell.clipsToBounds = true
//        
//        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cell.contentView.layer.shadowRadius = 7.5
//        cell.contentView.layer.shadowOpacity = 1.0
//        cell.contentView.clipsToBounds = true
//        
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
//        self.currentCell = (cell?.textLabel.text!)!
//        
//        pageObject.getPageDetails(authToken: passedToken, pageName: currentCell, completion: { (detailPage) in
//            if (detailPage != nil) {
//                print("Succeeded in retrieving detail page")
//                self.selectedPageDetails = detailPage!
//            }
//                
//            else {
//                print("Detail Page failed")
//            }
//        })
//    }
    
    
    @IBAction func closeButton(_ sender: UIButton) {
        userSession.removeObject(forKey: "userToken")
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "segueLogin", sender: self)
    }
    
    
    func expandBlogSelect() {
        UIView.animate(withDuration: 0.25, animations: {
            self.botConstraintBlogSelect.constant = 0
//            self.botConstraintRecordButton.constant = self.isPageSelectExpanded ? 30 : 194
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.isPageSelectExpanded = self.isPageSelectExpanded ? false : true
        })
    }
    
    func collapseBlogSelect() {
        UIView.animate(withDuration: 0.25, animations: {
            self.botConstraintBlogSelect.constant = -200
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.isPageSelectExpanded = self.isPageSelectExpanded ? false : true
        })
    }
    
    @IBAction func shareButton(_ sender: Any) {
        shareLink(shareCompletion: { (response) in
            if (response == true) {
                print("Successfully shared!")
            }
            
            else {
                print("Could not share now!")
            }
        })
    }
    
    @IBAction func shareToFBButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            //self.widthConstraintShareMessage.constant = self.isShareToFBExpanded ? 280 : 0
            //self.shareContentStack.isHidden = self.isShareToFBExpanded ? false : true
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.isShareToFBExpanded = self.isShareToFBExpanded ? false : true
        })
    }

    func shareLink(shareCompletion : @escaping (_ success : Bool) -> ()) {
        var headers = const.mHeaders
        headers["Authorization"] = passedToken
        let messageParams = [
            "page_id" : "194300524348319",
            "link" : "http://hoc.fanadnetwork.com/live",
            "message" : "This is a test"]
        
        let reqUrl = const.PROD_ROOT_URL + const.BASE_URI + const.SHARE_LINK_URI

        Alamofire.request(URL(string: reqUrl)!, method: .get, parameters: messageParams, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                print("RESPONSE PRINT")
                print(response)
                    if let responseArray = response.result.value as? NSArray {
                        print(responseArray)
                        for ind in 0...responseArray.count-1 {
                            let arrayObject = responseArray[ind] as! [String : AnyObject]
                            print(arrayObject)
                        }
                        shareCompletion(true)
                    }
                
                    else {
                        shareCompletion(false)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrievePages() {
        self.pageNames = pageObject.getPageNames(authToken: passedToken, completion: { (arrayResponse) in
            if ((arrayResponse?.count)! > 0) {
                print("Succeeded in retrieving")
                self.selectBlogLabel.text = "Select a blog and press record to go live"
                self.pageNames = arrayResponse! as! [String]
                self.cv.reloadData()
            }
            
            if (arrayResponse == nil) {
                print("Failed to retrieve")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueLogin") {
            let loginVC = segue.destination as! ViewController
        }
    }
    
// *********** //
    
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
    
    func checkConnection() -> Bool {
        let checkConnection = isInternetAvailable()
        
        if (checkConnection == true) {
            return true
        }
            
        else {
            return false
        }
    }
    
    func didTappedStartLiveButton(_ button: UIButton) -> Void {
        startLiveButton.isSelected = !startLiveButton.isSelected;
        if (!checkConnection()) {
            let alert = alertUser(title: "Check connection", message: "Please check your internet connection and try again")
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            if (startLiveButton.isSelected) {
                if (!selectedPageDetails.isEmpty) {
                    startLiveButton.setImage(stopLiveImg, for: UIControlState())
                    goLive2(completion: { (success) in
                        if (success == true) {
                            self.collapseBlogSelect()
                            self.stream.url = String(self.streamKey)
                            self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ScrollViewVC.updateTimerLabel)), userInfo: nil, repeats: true)
                            self.countdownTimer.fire()
                        }
                            
                        else {
                            print("Failed to go live")
                            return
                        }
                    })
                }
                
                else {
                    let alert = alertUser(title: "Select blog", message: "Please select a blog and press record to go live")
                    self.present(alert, animated: true, completion: nil)
                }
            }
                
            else {
                resetTimer()
                startLiveButton.setImage(startLiveImg, for: UIControlState())
                self.expandBlogSelect()
                session.stopLive()
                self.isStreaming = false
            }
        }
    }
    
    func resetTimer() {
        countdownTimer.invalidate()
        isCountdownFinished = false
        timerLabel.text = ""
        self.timerSeconds = 4
    }
    
//    func goLive(completion : @escaping (_ success : Bool) -> ()) {
//        if (selectedPageDetails.count > 0) {
//            self.selectedPageBlogUrl = (self.selectedPageDetails["blog_url"] as? String)!
//            if self.selectedPageBlogUrl is NSNull {
//                return
//            }
//            self.selectedPageVerified = selectedPageDetails["verified"] as! String
//            self.selectedPageBlogId = selectedPageDetails["page_id"] as! String
//            
//            if ((self.selectedPageVerified == "1") && (self.selectedPageBlogUrl != nil) && (type(of: self.selectedPageBlogUrl) != NSNull.self) && (!self.selectedPageBlogUrl.isEmpty)) {
//                print("PAGE VERIFIED")
//                liveGateway.getStreamKey(authToken: passedToken, selectedPageId: selectedPageBlogId, completion: { (retrievedStream) in
//                    if (retrievedStream != nil) {
//                        self.retrievedStreamKey = ""
//                        self.retrievedStreamKey = retrievedStream!
//                        let streamBaseUrl : String = "rtmp://54.201.16.95:1935/live/"
//                        print("Successfully retrieved stream key!")
//                        print(self.retrievedStreamKey)
//                        self.streamKey = ""
//                        self.streamKey = streamBaseUrl + self.retrievedStreamKey
//                        completion(true)
//                    }
//                        
//                    else {
//                        print("Failed to retrieve stream key")
//                        completion(false)
//                    }
//                })
//            }
//                
//            else {
//                print("This page is not verified")
//            }
//        }
//    }
    
    func goLive2(completion : @escaping (_ success : Bool) -> ()) {
        if (self.selectedPageDetails.isEmpty) {
            if ((self.pageNames.isEmpty == true) || (!isInternetAvailable())) {
                resetButtons()
                let alert = alertUser(title: "No blogs loaded", message: "No blogs loaded, please check your connection")
                self.present(alert, animated: true, completion: nil)
            }
            resetButtons()
        }
        
        else {
            if (selectedPageDetails.count > 0) {
                self.selectedPageBlogUrl = (self.selectedPageDetails["blog_url"] as? String)!
                if self.selectedPageBlogUrl is NSNull {
                    return
                }
                
                self.selectedPageVerified = selectedPageDetails["verified"] as! String
                self.selectedPageBlogId = selectedPageDetails["page_id"] as! String
            }
            
            if ((self.selectedPageVerified == "1") && (self.selectedPageBlogUrl != nil) && (type(of: self.selectedPageBlogUrl) != NSNull.self) && (!self.selectedPageBlogUrl.isEmpty)) {
                shareLinkStack.isHidden = false
                collapseBlogSelect()
                
                liveGateway.getStreamKey(authToken: passedToken, selectedPageId: selectedPageBlogId, completion: { (retrievedStream) in
                    if (retrievedStream != nil) {
                        self.retrievedStreamKey = ""
                        self.retrievedStreamKey = retrievedStream!
                        let streamBaseUrl : String = "rtmp://54.201.16.95:1935/live/"
                        print("Successfully retrieved stream key!")
                        print(self.retrievedStreamKey)
                        self.streamKey = ""
                        self.streamKey = streamBaseUrl + self.retrievedStreamKey
                        completion(true)
                    }
                        
                    else {
                        let alert = alertUser(title: "Network error", message: "Could not get key. Please check connectino or contact support.")
                        self.present(alert, animated: true, completion: nil)
                        self.resetButtons()
                        self.expandBlogSelect()
                        completion(false)
                    }
                })
            }
            
            else {
                resetButtons()
                let alert = alertUser(title: "Loading error", message: "The selected blog is not verified")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateTimerLabel() {
        
        if (self.timerSeconds == 0) {
            self.timerLabel.text = ""
            countdownTimer.invalidate()
            
            if (!countdownTimer.isValid) {
                if (!isInternetAvailable()) {
                    resetTimer()
                    resetButtons()
                    expandBlogSelect()
                    let alert = alertUser(title: "Network error", message: "No connection exists")
                    self.present(alert, animated: true, completion: nil)
                    selectedPageDetails.removeAll()
                }
                
                else {
                    isCountdownFinished = true
                    startStreaming()
                }
            }
        }
        
        else {
            self.timerSeconds -= 1
            self.timerLabel.text = "\(timerSeconds)"
        }
    }
    
    func resetButtons() {
        let stopLiveImg = UIImage(named: "liveButton")
        startLiveButton.setImage(stopLiveImg, for: UIControlState())
    }
    
    func startStreaming() {
        self.session.startLive(self.stream)
        self.isStreaming = true
    }
    
    func initUI() {
        if (self.isStreaming == false) {
            
        }
    }
    
    func didTappedCameraButton(_ button: UIButton) -> Void {
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevicePosition.back) ? AVCaptureDevicePosition.front : AVCaptureDevicePosition.back;
    }
    
    //MARK: - Getters and Setters
    
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
//    var containerView: UIView = {
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
//        containerView.backgroundColor = UIColor.clear
//        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
//        return containerView
//    }()
    
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
        cameraButton.setImage(UIImage(named: "flipCamera"), for: UIControlState())
        return cameraButton
    }()
    
    var startLiveButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let startLiveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        startLiveButton.center = CGPoint(x: w / 2, y : h * 0.7)
        startLiveButton.layer.cornerRadius = 22
        
        let startLiveImg = UIImage(named: "liveButton")
        startLiveButton.setImage(startLiveImg, for: UIControlState())
        startLiveButton.setTitleColor(UIColor.black, for:UIControlState())
        startLiveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        return startLiveButton
    }()
    
}

