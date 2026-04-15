
import UIKit
import WebRTC
import SDWebImage

class RealTimeTalkVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    lazy var backgroudImage = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreen_WIDTH, height: kScreen_HEIGHT))
        imageView.backgroundColor = .clear
        if NavTalkManager.shared.navtalk_chatpage_backgroundImage != nil{
            imageView.image = NavTalkManager.shared.navtalk_chatpage_backgroundImage
        }else{
            imageView.image = UIImage(named: "default_background",in: Bundle.module,with: nil)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var backButton = {
        let button = UIButton(type: .custom)
        if NavTalkManager.shared.navtalk_backButton_frame != nil{
            button.frame = NavTalkManager.shared.navtalk_backButton_frame!
        }else{
            button.frame = CGRectMake(20, safeTop()+(44/2-24/2), 24, 24)
        }
        if NavTalkManager.shared.navtalk_backButton_image != nil{
            button.setImage(NavTalkManager.shared.navtalk_backButton_image, for: .normal)
        }else{
            button.setImage(UIImage(named: "navtalk_back",in: Bundle.module,with: nil), for: .normal)
        }
        button.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var myTableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 300, width: kScreen_WIDTH-100, height: kScreen_HEIGHT-300-safeBottom()-20-60-30))
        if NavTalkManager.shared.navtalk_messageList_frame != nil{
            tableView.frame = NavTalkManager.shared.navtalk_messageList_frame!
        }
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "ChatTableViewQuestionCell", bundle: Bundle.module), forCellReuseIdentifier: "ChatTableViewQuestionCellID")
        tableView.register(UINib(nibName: "ChatTableViewAnswerCell", bundle: Bundle.module), forCellReuseIdentifier: "ChatTableViewAnswerCellID")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        //Translucent view
        // From bottom to top
        // alpha 1.0 to 0.1
        if NavTalkManager.shared.navtalk_messageList_enableGradient == true{
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = tableView.bounds
            gradientLayer.colors = [
                UIColor.black.cgColor,
                UIColor.black.withAlphaComponent(0.05).cgColor,
            ]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint  =  CGPoint(x: 0.5, y: 0.0)
            tableView.layer.mask = gradientLayer
        }
        return tableView
    }()
    //microphoneStatus
    lazy var microphoneStatusView = {
        let view = UIView(frame: CGRectMake(kScreen_WIDTH/2/2-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60))
        if NavTalkManager.shared.navtalk_micphoneButton_frame != nil{
            view.frame = NavTalkManager.shared.navtalk_micphoneButton_frame!
        }else{
            if NavTalkManager.shared.navtalk_cameraButton_isShow == false{
                view.frame = CGRectMake(kScreen_WIDTH/2-80/2-50, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
            }
        }
        view.backgroundColor = .clear
        view.addSubview(microphoneStatusIcon)
        let button_width = NavTalkManager.shared.navtalk_micphoneButton_frame?.width ?? 80
        let label = UILabel(frame: CGRect(x: 0, y: 40+5, width: button_width, height: 15))
        label.text = NavTalkManager.shared.navtalk_micphoneButton_title
        label.textColor = NavTalkManager.shared.navtalk_micphoneButton_titleColor
        label.font = NavTalkManager.shared.navtalk_micphoneButton_titleFont
        label.textAlignment = .center
        view.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickOpenOrCloesMirophoneButton))
        view.addGestureRecognizer(tap)
        return view
    }()
    lazy var microphoneStatusIcon = {
        let button_width = NavTalkManager.shared.navtalk_micphoneButton_frame?.width ?? 80
        let imageV = UIImageView(frame: CGRectMake(button_width/2-38/2, 0, 38, 38))
        imageV.layer.cornerRadius = 38/2
        imageV.contentMode = .scaleAspectFit
        if NavTalkManager.shared.navtalk_micphoneButton_image_on != nil{
            imageV.image = NavTalkManager.shared.navtalk_micphoneButton_image_on
        }else{
            imageV.image = UIImage(named: "micphone_on",in: Bundle.module,with: nil)
        }
        return imageV
    }()
    //callStatus
    lazy var callStatusView = {
        let view = UIView(frame: CGRectMake(kScreen_WIDTH/2/2*2-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60))
        if NavTalkManager.shared.navtalk_navtalkButton_frame != nil{
            view.frame = NavTalkManager.shared.navtalk_navtalkButton_frame!
        }else{
            view.frame = CGRectMake(kScreen_WIDTH/2/2*2-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
        }
        view.backgroundColor = .clear
        view.addSubview(self.callStatusIcon)
        view.addSubview(self.callLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickOpenOrCloesCallStatusButton))
        view.addGestureRecognizer(tap)
        return view
    }()
    lazy var callStatusIcon = {
        let button_width = NavTalkManager.shared.navtalk_navtalkButton_frame?.width ?? 80
        let imageV = UIImageView(frame: CGRect(x: button_width/2-38/2, y: 0, width: 38, height: 38))
        imageV.layer.cornerRadius = 38/2
        imageV.contentMode = .scaleAspectFit
        if NavTalkManager.shared.navtalk_navtalkButton_image_off != nil{
            imageV.image =  NavTalkManager.shared.navtalk_navtalkButton_image_off
        }else{
            imageV.image = UIImage(named: "navtalk_off",in: Bundle.module,with: nil)
        }
        return imageV
    }()
    lazy var callLabel = {
        let button_width = NavTalkManager.shared.navtalk_navtalkButton_frame?.width ?? 80
        let label = UILabel(frame: CGRect(x: 0, y: 40+5, width: button_width, height: 15))
        label.text = NavTalkManager.shared.navtalk_navtalkButton_off_title
        label.textColor = NavTalkManager.shared.navtalk_navtalkButton_off_titleColor
        label.font = NavTalkManager.shared.navtalk_navtalkButton_off_titleFont
        label.textAlignment = .center
        return label
    }()
    //cameraStatus
    lazy var cameraStatusView = {
        let view = UIView(frame: CGRectMake(kScreen_WIDTH/2/2*3-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60))
        if NavTalkManager.shared.navtalk_cameraButton_frame != nil{
            view.frame = NavTalkManager.shared.navtalk_cameraButton_frame!
        }else{
            if NavTalkManager.shared.navtalk_micphoneButton_isShow == false{
                view.frame = CGRectMake(kScreen_WIDTH/2-80/2+50, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
            }
        }
        view.backgroundColor = .clear
        view.addSubview(self.cameraStatusIcon)

        let button_width = NavTalkManager.shared.navtalk_cameraButton_frame?.width ?? 80
        let label = UILabel(frame: CGRect(x: 0, y: 40+5, width: button_width, height: 15))
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = NavTalkManager.shared.navtalk_cameraButton_title
        label.textColor = NavTalkManager.shared.navtalk_cameraButton_titleColor
        label.font = NavTalkManager.shared.navtalk_cameraButton_titleFont
        label.textAlignment = .center
        view.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickOpenOrCloseCamerabutton))
        view.addGestureRecognizer(tap)
        return view
    }()
    lazy var cameraStatusIcon = {
        let button_width = NavTalkManager.shared.navtalk_cameraButton_frame?.width ?? 80
        let imageV = UIImageView(frame: CGRect(x: button_width/2-38/2, y: 0, width: 38, height: 38))
        imageV.layer.cornerRadius = 38/2
        imageV.contentMode = .scaleAspectFit
        if NavTalkManager.shared.navtalk_cameraButton_image_off != nil{
            imageV.image = NavTalkManager.shared.navtalk_cameraButton_image_off
        }else{
            imageV.image = UIImage(named: "camera_off",in: Bundle.module,with: nil)
        }
        return imageV
    }()
    lazy var showcameraVideoView = {
        let view = UIView(frame: CGRectMake(kScreen_WIDTH-10-90, safeTop()+20, 90, 150))
        if NavTalkManager.shared.navtalk_cameraPreview_frame != nil{
            view.frame = NavTalkManager.shared.navtalk_cameraPreview_frame!
        }
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.addSubview(self.switchCaeraButton)
        return view
    }()
    lazy var switchCaeraButton = {
        let button = UIButton(type: .custom)
        let showcameraVideoView_width = NavTalkManager.shared.navtalk_cameraPreview_frame?.width ?? 90
        if NavTalkManager.shared.navtalk_switchCameraButton_frame != nil{
            button.frame = NavTalkManager.shared.navtalk_switchCameraButton_frame!
        }else{
            button.frame = CGRectMake(showcameraVideoView_width/2-20/2, 10, 20, 20)
        }
        if NavTalkManager.shared.navtalk_switchCameraButton_image != nil{
            button.setImage(NavTalkManager.shared.navtalk_switchCameraButton_image, for: .normal)
        }else{
            button.setImage(UIImage(named: "switch_camera",in: Bundle.module,with: nil), for: .normal)
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(clickSwitchCameraPositionButton), for: .touchUpInside)
        return button
    }()
   
    enum NavTalkStatus: Int {
        case notConnected = 0
        case connecting = 1
        case connected = 2
    }
    
    var allMessageModels = [[String: Any]]()
    var talk_status: NavTalkStatus = .notConnected
    var isJudgeNotificationOfStatuse = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        fetchAvatarDetailInformation()
    }
    
    func initUI(){
        
        view.backgroundColor = .black
        
        view.addSubview(backgroudImage)
        
        if NavTalkManager.shared.navtalk_messageList_isShow == true{
            view.addSubview(myTableView)
        }
        if NavTalkManager.shared.isOrNotSaveHistoryChatMessages == false{
            UserDefaults.standard.removeObject(forKey: "SavedHistoryChatMessagesInLocal")
        }else{
            if let localSavedModels_string = UserDefaults.standard.string(forKey: "SavedHistoryChatMessagesInLocal"),
               let localSavedModels_array = jsonStringToArray(localSavedModels_string){
                if localSavedModels_array.count > 0{
                    allMessageModels = [[String: Any]]()
                    allMessageModels.append(contentsOf: localSavedModels_array)
                    myTableView.reloadData()
                    let lastIndex = IndexPath(row: self.allMessageModels.count - 1, section: 0)
                    self.myTableView.scrollToRow(at: lastIndex, at: .top, animated: true)
                }
            }
        }
        
        if NavTalkManager.shared.navtalk_micphoneButton_isShow == true{
            view.addSubview(microphoneStatusView)
        }
        view.addSubview(callStatusView)
        if NavTalkManager.shared.navtalk_cameraButton_isShow == true{
            view.addSubview(cameraStatusView)
        }
        if NavTalkManager.shared.navtalk_cameraPreview_isShow == true{
            view.addSubview(showcameraVideoView)
        }
        view.addSubview(backButton)
        
        microphoneStatusView.isHidden = true
        cameraStatusView.isHidden = true
        showcameraVideoView.isHidden = true
        
        talk_status = .notConnected
        refreshNavTalkStatusUI()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeWebSocketStatus), name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeWebRTCStatus), name: NSNotification.Name(rawValue: "WebRTCManager_WebRTC_status_changed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HaveInputText), name: NSNotification.Name(rawValue: "HaveInputText"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HaveOutputText), name: NSNotification.Name(rawValue: "HaveOutputText"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCameraButtonStatus), name: NSNotification.Name(rawValue: "CameraStateIsChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMicrophonStatusUI), name: NSNotification.Name(rawValue: "changeAudioRecordStatus"), object: nil)
        
        
        WebRTCManager.shared.superVC = self
        WebSocketManager.shared.superVC = self
        CameraCaptureManager.shared.superVC = self
        
        NetworkMonitor.shared.start()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onGainNetwork),
            name: Notification.Name("didGainNetwork"),
            object: nil
        )
    }
    @objc private func onGainNetwork() {
        print("URL status is changed.")
        fetchAvatarDetailInformation()
    }
    func fetchAvatarDetailInformation(){
        var urlString = ""
        if (NavTalkManager.shared.characterId.count > 0){
            urlString = "\(NavTalkManager.shared.fetchAvatarInfoById)\(NavTalkManager.shared.characterId)"
        }else{
            urlString = "\(NavTalkManager.shared.fetchAvatarInfoByName)\(NavTalkManager.shared.characterName)"
        }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(NavTalkManager.shared.license, forHTTPHeaderField: "license")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fetch Avatar Detail Information--Fail", error)
                return
            }
            guard let data = data else {
                print("Fetch Avatar Detail Information--No Data")
                return
            }
            do {
                if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Fetch Avatar Detail Information-Success")
                    print("\(result)")
                    if let avatar_data = result["data"] as? [String: Any],
                       let avatar_image_url_string = avatar_data["url"] as? String,
                       let avatar_image_url = URL(string: avatar_image_url_string),
                       let avatar_providerName = avatar_data["providerName"] as? String{
                        //providerName
                        NavTalkManager.shared.avatar_image_url = avatar_image_url_string
                        NavTalkManager.shared.avatar_provider_type = avatar_providerName
                        DispatchQueue.main.async {
                            self.backgroudImage.sd_setImage(with: avatar_image_url, placeholderImage: UIImage(named: "default_background",in: Bundle.module,with: nil))
                            if avatar_providerName != "openai"{
                                self.cameraStatusView.alpha = 0.4
                                self.cameraStatusView.isUserInteractionEnabled = false
                            }else{
                                self.cameraStatusView.alpha = 1
                                self.cameraStatusView.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }catch{
                print("Fetch Avatar Detail Information--Parse Result Error:", error)
            }
        }
        task.resume()
    }
    @objc private func clickBackButton(){
        if talk_status == .connected{
            //Refresh UI
            talk_status = .notConnected
            refreshNavTalkStatusUI()
            //Stop All Socket And WebRTC And Pause Record Audio
            isJudgeNotificationOfStatuse = false
            //Stop Recording Image
            CameraCaptureManager.shared.previewLayer = nil
            // Stop All Tasks
            stopAllTask()
        }else{
            if WebRTCManager.shared.webRTC_status == .Connected{
                WebRTCManager.shared.disconnectWebRTC()
            }
            if WebSocketManager.shared.socket_status == .Connected{
                WebSocketManager.shared.disconnectWebSocketOfNavTalk()
            }
        }
        dismiss(animated: true)
    }

    //MARK: 1.WebSocket:
    @objc func changeWebSocketStatus(){
        if isJudgeNotificationOfStatuse == false{
            return
        }
        DispatchQueue.main.async {
            if WebSocketManager.shared.socket_status == .Connectting{
                //print("WebSocket status is changed，current is--Connectting")
            }else if WebSocketManager.shared.socket_status == .NotConnected{
                //print("WebSocket status is changed，current is--NotConnected")
                //self.view.makeToastActivity(.center)
                self.view.hideToast()
                self.talk_status = .notConnected
                self.refreshNavTalkStatusUI()
                self.isJudgeNotificationOfStatuse = false
                self.stopAllTask()
            }else if WebSocketManager.shared.socket_status == .Connected{
                //print("WebSocket status is changed，current is--Connected")
            }
        }
    }
    //MARK: 2.WebRTC:
    var WebRTCConnect_Timer: Timer?
    @objc func changeWebRTCStatus(){
        if isJudgeNotificationOfStatuse == false{
            return
        }
        DispatchQueue.main.async {
            if WebRTCManager.shared.webRTC_status == .Connectting{
                //print("WebRTC status is changed，current is--Connectting")
                DispatchQueue.main.async {
                    if self.WebRTCConnect_Timer != nil{
                        self.WebRTCConnect_Timer?.invalidate()
                        self.WebRTCConnect_Timer = nil
                    }
                    self.WebRTCConnect_Timer = Timer(timeInterval: 15.0, repeats: false, block: { timer in
                        print("Connect NavTalk is time out!")
                        if WebRTCManager.shared.webRTC_status == .Connectting{
                            WebSocketManager.shared.disconnectWebSocketOfNavTalk()
                        }
                    })
                    RunLoop.current.add(self.WebRTCConnect_Timer!, forMode: .common)
                }
            }else if WebRTCManager.shared.webRTC_status == .NotConnected{
                //print("WebRTC status is changed，current is--NotConnected")
                //self.view.makeToastActivity(.center)
                self.view.hideToast()
                self.talk_status = .notConnected
                self.refreshNavTalkStatusUI()
                self.isJudgeNotificationOfStatuse = false
                self.stopAllTask()
                if self.WebRTCConnect_Timer != nil{
                    self.WebRTCConnect_Timer?.invalidate()
                    self.WebRTCConnect_Timer = nil
                }
            }else if WebRTCManager.shared.webRTC_status == .Connected{
                //print("WebRTC status is changed，current is--Connected")
                //self.view.makeToastActivity(.center)
                self.view.hideToast()
                self.talk_status = .connected
                self.refreshNavTalkStatusUI()
                if self.WebRTCConnect_Timer != nil{
                    self.WebRTCConnect_Timer?.invalidate()
                    self.WebRTCConnect_Timer = nil
                }
            }else if WebRTCManager.shared.webRTC_status == .HaveRecieveRemoteVideoRender{
                //print("WebRTC status is changed，current is--HaveRecieveRemoteVideoRender")
            }
        }
    }
    @objc func HaveInputText(notifiction: Notification){
        if let dict = notifiction.object as? [String: Any] {
            //print("User Ask：\(dict)")
            if let transcript = dict["text"] as? String{
                var messageModel = [String: Any]()
                messageModel["type"] = "question"
                messageModel["content"] = transcript
                allMessageModels.append(messageModel)
                saveChatMessageToLocal()
                /*
                if allMessageModels.count == 2{
                    let firstDict = allMessageModels[0]
                    if let firstDict_type = firstDict["type"] as? String,
                       firstDict_type == "answer"{
                        //Change Fist And Second
                        var new_allMessageModels = [[String: Any]]()
                        new_allMessageModels.append(allMessageModels[1])
                        new_allMessageModels.append(allMessageModels[0])
                        allMessageModels = new_allMessageModels
                    }
                }
                 */
                self.myTableView.reloadData()
                if self.allMessageModels.count > 0 {
                    let lastIndex = IndexPath(row: self.allMessageModels.count - 1, section: 0)
                    self.myTableView.scrollToRow(at: lastIndex, at: .top, animated: true)
                }
            }
        }
    }
    @objc func HaveOutputText(notifiction: Notification){
        if let dict = notifiction.object as? [String: Any]{
            //print("AI Answer：\(dict)")
            if let transcript = dict["text"] as? String{
                var messageModel = [String: Any]()
                messageModel["type"] = "answer"
                messageModel["content"] = transcript
                allMessageModels.append(messageModel)
                saveChatMessageToLocal()
                self.myTableView.reloadData()
                if self.allMessageModels.count > 0 {
                    let lastIndex = IndexPath(row: self.allMessageModels.count - 1, section: 0)
                    self.myTableView.scrollToRow(at: lastIndex, at: .top, animated: true)
                }
            }
        }
    }
    func saveChatMessageToLocal(){
        if NavTalkManager.shared.isOrNotSaveHistoryChatMessages{
            let localMessagesArray_string = arrayToJSONString(allMessageModels)
            UserDefaults.standard.set(localMessagesArray_string, forKey: "SavedHistoryChatMessagesInLocal")
            UserDefaults.standard.synchronize()
        }
    }
    //MARK: 3.UITableViewDelegate, UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessageModels.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current_massage = allMessageModels[indexPath.row]
        let current_message_type = current_massage["type"] as? String ?? ""
        if current_message_type == "question"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewQuestionCellID", for: indexPath) as! ChatTableViewQuestionCell
            cell.cellDict = current_massage
            cell.initUI()
            return cell
        }else if current_message_type == "answer"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewAnswerCellID", for: indexPath) as! ChatTableViewAnswerCell
            cell.cellDict = current_massage
            cell.initUI()
            return cell
        }else{
            let cell = UITableViewCell()
            return cell
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == myTableView {
            if let mask = scrollView.layer.mask as? CAGradientLayer {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                mask.frame = scrollView.bounds
                CATransaction.commit()
            }
        }
    }
    //MARK: 4.Cloase Or Open Microphone
    @objc func clickOpenOrCloesMirophoneButton(){
        if RecordAudioManager.shared.recordSatus == "no"{
            RecordAudioManager.shared.startSendAudioMessageToAI()
        }else{
            RecordAudioManager.shared.pauseSendAudioMessageToAI()
        }
    }
    @objc func refreshMicrophonStatusUI(){
        if RecordAudioManager.shared.recordSatus == "no"{
            if NavTalkManager.shared.navtalk_micphoneButton_image_off != nil{
                microphoneStatusIcon.image = NavTalkManager.shared.navtalk_micphoneButton_image_off
            }else{
                microphoneStatusIcon.image = UIImage(named: "micphone_off",in: Bundle.module,with: nil)
            }
        }else{
            if NavTalkManager.shared.navtalk_micphoneButton_image_on != nil{
                microphoneStatusIcon.image = NavTalkManager.shared.navtalk_micphoneButton_image_on
            }else{
                microphoneStatusIcon.image = UIImage(named: "micphone_on",in: Bundle.module,with: nil)
            }
        }
    }
    
    //MARK: 5.Cloase Or Open Call
    @objc func clickOpenOrCloesCallStatusButton(){
        if talk_status == .notConnected{
            //Refresh UI
            talk_status = .connecting
            refreshNavTalkStatusUI()
            //Connect WebSocket
            isJudgeNotificationOfStatuse = true
            WebSocketManager.shared.connectWebSocketOfNavTalk()
        }else if talk_status == .connected{
            //Refresh UI
            talk_status = .notConnected
            refreshNavTalkStatusUI()
            //Stop All Socket And WebRTC And Pause Record Audio
            isJudgeNotificationOfStatuse = false
            stopAllTask()
        }
    }
    func refreshNavTalkStatusUI(){
        if talk_status == .notConnected{
            callStatusView.isUserInteractionEnabled = true
            callStatusView.alpha = 1
            
            if NavTalkManager.shared.navtalk_navtalkButton_image_off != nil{
                callStatusIcon.image =  NavTalkManager.shared.navtalk_navtalkButton_image_off
            }else{
                callStatusIcon.image = UIImage(named: "navtalk_off",in: Bundle.module,with: nil)
            }
            callLabel.text = NavTalkManager.shared.navtalk_navtalkButton_off_title
            callLabel.textColor = NavTalkManager.shared.navtalk_navtalkButton_off_titleColor
            callLabel.font = NavTalkManager.shared.navtalk_navtalkButton_off_titleFont
            
            if NavTalkManager.shared.navtalk_navtalkButton_frame != nil{
                callStatusView.frame = NavTalkManager.shared.navtalk_navtalkButton_frame!
            }else{
                callStatusView.frame = CGRectMake(kScreen_WIDTH/2/2*2-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
            }
            microphoneStatusView.isHidden = true
            cameraStatusView.isHidden = true
            
            WebRTCManager.shared.remoteVideoView?.removeFromSuperview()
        }else if talk_status == .connecting{
            callStatusView.isUserInteractionEnabled = false
            callStatusView.alpha = 0.7
            
            if NavTalkManager.shared.navtalk_navtalkButton_image_connecting != nil{
                callStatusIcon.image =  NavTalkManager.shared.navtalk_navtalkButton_image_connecting
            }else{
                callStatusIcon.image = UIImage(named: "navtalk_connecting",in: Bundle.module,with: nil)
            }
            callLabel.text = NavTalkManager.shared.navtalk_navtalkButton_connecting_title
            callLabel.textColor = NavTalkManager.shared.navtalk_navtalkButton_connecting_titleColor
            callLabel.font = NavTalkManager.shared.navtalk_navtalkButton_connecting_titleFont
            if NavTalkManager.shared.navtalk_navtalkButton_frame != nil{
                callStatusView.frame = NavTalkManager.shared.navtalk_navtalkButton_frame!
            }else{
                callStatusView.frame = CGRectMake(kScreen_WIDTH/2/2*2-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
            }
            
            microphoneStatusView.isHidden = true
            cameraStatusView.isHidden = true
        }else if talk_status == .connected{
            callStatusView.isUserInteractionEnabled = true
            callStatusView.alpha = 1
            
            if NavTalkManager.shared.navtalk_navtalkButton_image_on != nil{
                callStatusIcon.image =  NavTalkManager.shared.navtalk_navtalkButton_image_on
            }else{
                callStatusIcon.image = UIImage(named: "navtalk_on",in: Bundle.module,with: nil)
            }
            callLabel.text = NavTalkManager.shared.navtalk_navtalkButton_on_title
            callLabel.textColor = NavTalkManager.shared.navtalk_navtalkButton_on_titleColor
            callLabel.font = NavTalkManager.shared.navtalk_navtalkButton_on_titleFont
            if NavTalkManager.shared.navtalk_navtalkButton_frame != nil{
                callStatusView.frame = NavTalkManager.shared.navtalk_navtalkButton_frame!
            }else{
                if NavTalkManager.shared.navtalk_micphoneButton_isShow == false && NavTalkManager.shared.navtalk_cameraButton_isShow == false{
                    callStatusView.frame = CGRectMake(kScreen_WIDTH/2/2*2-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
                }else if NavTalkManager.shared.navtalk_micphoneButton_isShow == true && NavTalkManager.shared.navtalk_cameraButton_isShow == true{
                    callStatusView.frame = CGRectMake(kScreen_WIDTH/2/2*2-80/2, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
                }else if NavTalkManager.shared.navtalk_micphoneButton_isShow == true{
                    callStatusView.frame = CGRectMake(kScreen_WIDTH/2-80/2+50, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
                }else{
                    callStatusView.frame = CGRectMake(kScreen_WIDTH/2-80/2-50, kScreen_HEIGHT-safeBottom()-20-60, 80, 60)
                }
            }

            microphoneStatusView.isHidden = false
            cameraStatusView.isHidden = false
        }else{
            
        }
    }
    func stopAllTask(){
        //pause captrue audio
        //print("stop--1")
        RecordAudioManager.shared.pauseCaptureAudio()
        //disconect WebRTC
        //print("stop--2")
        WebRTCManager.shared.disconnectWebRTC()
        //dicconect websocket
        //print("stop--3")
        WebSocketManager.shared.disconnectWebSocketOfNavTalk()
        //Update Session DetailInformation
        fetchAvatarDetailInformation()
    }
    
    //MARK: 4.Cloase Or Open Camera
    @objc func clickOpenOrCloseCamerabutton(){
        if WebSocketManager.shared.socket_status != .Connected{
            self.view.makeToast("", duration: 2.0, position: .center, title: "Please connect to the WebSocket first!", image: nil, completion: nil)
            return
        }
        if WebRTCManager.shared.webRTC_status != .Connected{
            self.view.makeToast("", duration: 2.0, position: .center, title: "Please connect to the WebRTC first!", image: nil, completion: nil)
            return
        }
        if CameraCaptureManager.shared.current_camera_state == .opened{
            CameraCaptureManager.shared.stopRunningSession()
        }else{
            CameraCaptureManager.shared.showPreviewLayerView = showcameraVideoView
            CameraCaptureManager.shared.openCamera()
        }
    }
    @objc func refreshCameraButtonStatus(){
        DispatchQueue.main.async {
            if CameraCaptureManager.shared.current_camera_state == .opened{
                if NavTalkManager.shared.navtalk_cameraButton_image_on != nil{
                    self.cameraStatusIcon.image = NavTalkManager.shared.navtalk_cameraButton_image_on
                }else{
                    self.cameraStatusIcon.image = UIImage(named: "camera_on",in: Bundle.module,with: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    self.showcameraVideoView.isHidden = false
                })
            }else{
                if NavTalkManager.shared.navtalk_cameraButton_image_off != nil{
                    self.cameraStatusIcon.image = NavTalkManager.shared.navtalk_cameraButton_image_off
                }else{
                    self.cameraStatusIcon.image = UIImage(named: "camera_off",in: Bundle.module,with: nil)
                }
                self.showcameraVideoView.isHidden = true
            }
        }
    }
    @objc func clickSwitchCameraPositionButton(){
        CameraCaptureManager.shared.switchCameraPosition()
    }
}
