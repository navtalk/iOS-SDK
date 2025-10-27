
import UIKit
import WebRTC
import SDWebImage
import Toast

class RealTimeTalkVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    lazy var backButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Back", for: .normal)
        button.frame = CGRectMake(0, safeTop(), 100, 44)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        return button
    }()
    
    
    lazy var backgroudImage = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreen_WIDTH, height: kScreen_HEIGHT))
        imageView.backgroundColor = .clear
        if let currentURL = URL(string: "https://api.navtalk.ai/uploadFiles/\(NavTalkManager.shared.characterName).png"){
            imageView.sd_setImage(with: currentURL, placeholderImage: UIImage(named: "default_background", in: Bundle.module, with: nil))
        }else{
            imageView.image = UIImage(named: "default_background", in: Bundle.module, with: nil)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var myTableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kScreen_HEIGHT-safeBottom()-20-39-20-450, width: kScreen_WIDTH, height: 450))
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "ChatTableViewQuestionCell", bundle: Bundle.module), forCellReuseIdentifier: "ChatTableViewQuestionCellID")
        tableView.register(UINib(nibName: "ChatTableViewAnswerCell", bundle: Bundle.module), forCellReuseIdentifier: "ChatTableViewAnswerCellID")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = tableView.bounds
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.black.withAlphaComponent(0).cgColor,
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint  =  CGPoint(x: 0.5, y: 0.1)
  
        tableView.layer.mask = gradientLayer
        
        return tableView
    }()
    lazy var playTapView = {
        let view = UIView(frame: CGRectMake(kScreen_WIDTH/2-120/2, kScreen_HEIGHT-safeBottom()-20-39, 120, 39))
        view.clipsToBounds = true
        view.layer.cornerRadius = 19.5
        view.backgroundColor = COLORFROMRGB(r: 121, 121, 242, alpha: 1)
        view.isHidden = true
        
        let imageIcon = UIImageView(frame: CGRect(x: 60-7.5-12, y: 19.5-7.5, width: 15, height: 15))
        imageIcon.image = UIImage(named: "play_call_icon", in: Bundle.module, with: nil)
        view.addSubview(imageIcon)
        
        let conetntLabel = UILabel(frame: CGRectMake(60-7.5-12+15+5, 39/2-22/2, 30, 22))
        conetntLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        conetntLabel.textColor = .white
        conetntLabel.text = "Call"
        conetntLabel.textAlignment = .left
        view.addSubview(conetntLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickPlayTapView))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    lazy var connectingShowView = {
        let view = UIView(frame: CGRectMake(kScreen_WIDTH/2-150/2, kScreen_HEIGHT-safeBottom()-20-39, 150, 39))
        view.clipsToBounds = true
        view.layer.cornerRadius = 19.5
        view.backgroundColor = COLORFROMRGB(r: 245, 29, 72, alpha: 1)
        view.alpha = 0.3
        view.isHidden = true
        
        let imageIcon = UIImageView(frame: CGRect(x: 75-7.5-48, y: 19.5-7.5, width: 15, height: 15))
        imageIcon.image = UIImage(named: "talk_connecting_icon", in: Bundle.module, with: nil)
        view.addSubview(imageIcon)
        
        let conetntLabel = UILabel(frame: CGRectMake(75-7.5-48+15+8, 39/2-22/2, 100, 22))
        conetntLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        conetntLabel.textColor = .white
        conetntLabel.text = "Connectting"
        conetntLabel.textAlignment = .left
        view.addSubview(conetntLabel)
        view.isHidden = true
           
        return view
    }()
    lazy var stopTapView = {
        let view = UIView(frame: CGRectMake(kScreen_WIDTH/2-135/2, kScreen_HEIGHT-safeBottom()-20-39, 135, 39))
        view.clipsToBounds = true
        view.layer.cornerRadius = 19.5
        view.backgroundColor = COLORFROMRGB(r: 245, 29, 72, alpha: 1)
        
        let imageIcon = UIImageView(frame: CGRect(x: 67.5-7.5-36, y: 19.5-7.5, width: 15, height: 15))
        imageIcon.image = UIImage(named: "talk_connecting_icon", in: Bundle.module, with: nil)
        view.addSubview(imageIcon)
        
        let conetntLabel = UILabel(frame: CGRectMake(67.5-7.5-36+15+8, 39/2-22/2, 80, 22))
        conetntLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        conetntLabel.textColor = .white
        conetntLabel.text = "Hang Up"
        conetntLabel.textAlignment = .left
        view.addSubview(conetntLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickStopTapView))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    enum NavTalkStatus: Int {
        case notConnected = 0
        case connecting = 1
        case connected = 2
    }
    
    var allMessageModels = [[String: Any]]()
    var talk_status: NavTalkStatus = .notConnected
    var isJudgeNotificationOfStatuse = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        GetAllLocalMessageHistoryData()
    }
    
    func initUI(){
        
        if NavTalkManager.shared.isClearLocalChatMessagesHistoryData{
            NavTalkManager.shared.removeMessagesInLocal()
        }
        
        view.backgroundColor = .black
        
        view.addSubview(backgroudImage)
        
        view.addSubview(stopTapView)
        view.addSubview(connectingShowView)
        view.addSubview(playTapView)
        talk_status = .notConnected
        refreshNavTalkStatusUI()
        
        view.addSubview(myTableView)
        
        view.addSubview(backButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeRTCWebSocketStatus), name: NSNotification.Name(rawValue: "WebRTCManager_socket_status_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeWebSocketStatus), name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeWebRTCStatus), name: NSNotification.Name(rawValue: "WebRTCManager_WebRTC_status_changed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HaveInputText), name: NSNotification.Name(rawValue: "HaveInputText"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HaveOutputText), name: NSNotification.Name(rawValue: "HaveOutputText"), object: nil)
        
        WebRTCManager.shared.superVC = self
        WebSocketManager.shared.superVC = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onGainNetwork),
            name: .didGainNetwork,
            object: nil
        )

    }
    
    //Get All Local Message Data
    func GetAllLocalMessageHistoryData(){
        DispatchQueue.main.async {
            self.allMessageModels = NavTalkManager.shared.getAllMessagesListData()
            self.myTableView.reloadData()
            if self.allMessageModels.count > 0 {
                let lastIndex = IndexPath(row: self.allMessageModels.count - 1, section: 0)
                self.myTableView.scrollToRow(at: lastIndex, at: .top, animated: true)
            }
        }
    }
    
    @objc private func onGainNetwork() {
        if let currentURL = URL(string: "https://api.navtalk.ai/uploadFiles/\(NavTalkManager.shared.characterName).png"){
            backgroudImage.sd_setImage(with: currentURL, placeholderImage: UIImage(named: "default_background", in: Bundle.module, with: nil))
        }else{
            backgroudImage.image = UIImage(named: "default_background", in: Bundle.module, with: nil)
        }
    }
    
    @objc func clickBackButton(){
        if talk_status == .connected{
            //Refresh UI
            talk_status = .notConnected
            refreshNavTalkStatusUI()
            //Stop All Socket And WebRTC And Pause Record Audio
            isJudgeNotificationOfStatuse = false
            stopAllTask()
        }
        dismiss(animated: true)
    }
    
    //MARK: Play/Pause--Button
    @objc func clickPlayTapView(){
        if talk_status == .notConnected{
            //Refresh UI
            talk_status = .connecting
            refreshNavTalkStatusUI()
            //Connect RTC-WebSocket
            isJudgeNotificationOfStatuse = true
            WebRTCManager.shared.connectWebRTCOfNavTalk()
        }
    }
    @objc func clickStopTapView(){
        if talk_status == .connected{
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
            playTapView.isHidden = false
            connectingShowView.isHidden = true
            stopTapView.isHidden = true
            WebRTCManager.shared.remoteVideoView?.removeFromSuperview()
        }else if talk_status == .connecting{
            playTapView.isHidden = true
            connectingShowView.isHidden = false
            stopTapView.isHidden = true
        }else if talk_status == .connected{
            playTapView.isHidden = true
            connectingShowView.isHidden = true
            stopTapView.isHidden = false
        }else{
            playTapView.isHidden = true
            connectingShowView.isHidden = true
            stopTapView.isHidden = true
        }
    }
    func stopAllTask(){
        //pause captrue audio
        print("stop--1")
        RecordAudioManager.shared.pauseCaptureAudio()
        //disconect WebRTC
        print("stop--2")
        WebRTCManager.shared.disconnectWebRTC()
        //disconnect RTC-WebSocket
        print("stop--3")
        WebRTCManager.shared.disconnectRTCWebSocketOfNavTalk()
        //dicconect websocket
        print("stop--4")
        WebSocketManager.shared.disconnectWebSocketOfNavTalk()
    }
    //MARK: 1.RTC-WebSocket Delegate:
    @objc func changeRTCWebSocketStatus(){
        if isJudgeNotificationOfStatuse == false{
            return
        }
        DispatchQueue.main.async {
            if WebRTCManager.shared.webRTC_socket_status == .Connectting{
                self.view.makeToastActivity(.center)
                DispatchQueue.main.asyncAfter(deadline: .now()+30.0, execute: {
                    if WebRTCManager.shared.webRTC_socket_status == .Connectting{
                        self.view.hideToastActivity()
                        self.view.makeToast("Connect is time out.")
                        self.talk_status = .notConnected
                        self.refreshNavTalkStatusUI()
                        self.isJudgeNotificationOfStatuse = false
                        self.stopAllTask()
                    }
                })
            }else if WebRTCManager.shared.webRTC_socket_status == .NotConnected{
                self.view.hideToastActivity()
                self.view.hideAllToasts()
                self.talk_status = .notConnected
                self.refreshNavTalkStatusUI()
                self.isJudgeNotificationOfStatuse = false
                self.stopAllTask()
            }else if WebRTCManager.shared.webRTC_socket_status == .Connected{
                WebSocketManager.shared.connectWebSocketOfNavTalk()
            }
        }
    }
    //MARK: 2.WebSocket Delegate:
    @objc func changeWebSocketStatus(){
        if isJudgeNotificationOfStatuse == false{
            return
        }
        DispatchQueue.main.async {
            if WebSocketManager.shared.socket_status == .Connectting{
                print("WebSocket Status--Connecting")
            }else if WebSocketManager.shared.socket_status == .NotConnected{
                print("WebSocket Status--DisConnected")
                //MBProgressHUD.removeCurrentMBProgressHUD()
                self.view.hideToastActivity()
                self.view.hideAllToasts()
                self.talk_status = .notConnected
                self.refreshNavTalkStatusUI()
                self.isJudgeNotificationOfStatuse = false
                self.stopAllTask()
            }else if WebSocketManager.shared.socket_status == .Connected{
                print("WebSocket Status--Connected")
            }else if WebSocketManager.shared.socket_status == .UpdatedSession{
                print("WebSocket Status--Initatial Success Task")
                if NavTalkManager.shared.isSendOpenAIChatMessagesHistoryData{
                    let history_list_item = NavTalkManager.shared.getAllMessagesListData()
                    if history_list_item.count > 0{
                        WebSocketManager.shared.sendHistoryToCurrentChat(allMessageModels: history_list_item)
                    }
                }
                WebRTCManager.shared.gotoSendStartCommand()
            }
        }
    }
    //MARK: 3.RTC-WebRTC Delegate:
    @objc func changeWebRTCStatus(){
        if isJudgeNotificationOfStatuse == false{
            return
        }
        DispatchQueue.main.async {
            if WebRTCManager.shared.webRTC_status == .Connectting{
                print("RTC-WebRTC Status--Connecting")
            }else if WebRTCManager.shared.webRTC_status == .NotConnected{
                print("RTC-WebRTC Status--DisConnected")
                //MBProgressHUD.removeCurrentMBProgressHUD()
                self.view.hideToastActivity()
                self.view.hideAllToasts()
                self.talk_status = .notConnected
                self.refreshNavTalkStatusUI()
                self.isJudgeNotificationOfStatuse = false
                self.stopAllTask()
            }else if WebRTCManager.shared.webRTC_status == .Connected{
                print("RTC-WebRTC Status--Connected")
                //MBProgressHUD.removeCurrentMBProgressHUD()
                self.view.hideToastActivity()
                self.view.hideAllToasts()
                self.talk_status = .connected
                self.refreshNavTalkStatusUI()
            }else if WebRTCManager.shared.webRTC_status == .HaveRecieveRemoteVideoRender{
                print("RTC-WebRTC Status--Have Fetch Remote Video")
            }
        }
    }
    @objc func HaveInputText(notifiction: Notification){
        if let dict = notifiction.object as? [String: Any] {
            if let transcript = dict["text"] as? String{
                var messageModel = [String: Any]()
                messageModel["type"] = "question"
                messageModel["content"] = transcript
                allMessageModels.append(messageModel)
                NavTalkManager.shared.saveMessageWithDictData(message: messageModel)
                if allMessageModels.count == 2{
                    let firstDict = allMessageModels[0]
                    if let firstDict_type = firstDict["type"] as? String,
                       firstDict_type == "answer"{
                        var new_allMessageModels = [[String: Any]]()
                        new_allMessageModels.append(allMessageModels[1])
                        new_allMessageModels.append(allMessageModels[0])
                        allMessageModels = new_allMessageModels
                    }
                }
                self.myTableView.reloadData()
                if self.allMessageModels.count > 0 {
                    let lastIndex = IndexPath(row: self.allMessageModels.count - 1, section: 0)
                    self.myTableView.scrollToRow(at: lastIndex, at: .top, animated: true)
                }
            }
        }
    }
    @objc func HaveOutputText(notifiction: Notification){
        if let dict = notifiction.object as? [String: Any] {
            if let transcript = dict["text"] as? String {
                var messageModel = [String: Any]()
                messageModel["type"] = "answer"
                messageModel["content"] = transcript
                NavTalkManager.shared.saveMessageWithDictData(message: messageModel)
                allMessageModels.append(messageModel)
                self.myTableView.reloadData()
                if self.allMessageModels.count > 0 {
                    let lastIndex = IndexPath(row: self.allMessageModels.count - 1, section: 0)
                    self.myTableView.scrollToRow(at: lastIndex, at: .top, animated: true)
                }
            }
        }
    }
    //MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessageModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == myTableView {
            if let mask = scrollView.layer.mask as? CAGradientLayer {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                mask.frame = scrollView.bounds
                CATransaction.commit()
            }
        }
    }
    

}
