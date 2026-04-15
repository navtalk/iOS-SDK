import Foundation
import Toast
import UIKit

public class NavTalkManager: NSObject, @unchecked Sendable{
    
    //1.Initatial
    public static let shared = NavTalkManager()
    private override init(){
        super.init()
    }
    
    //2.Configure Requied Param
    //2.1.license --Requied
    //Your Api Kye Here -- Requied
    public var license = ""
    //2.2.characterName/characterId  - Required
    //Your Avatar Name Here -- Requied
    //Option 1: Connect using character name
    public var characterName = ""
    //Your Avatar Id Here -- Requied
    //Option 2: Connect using avatarId (recommended, higher priority)
    public var characterId = ""
    
    //3.Configure Custom Parameters
    //3.1.isOrNotSaveHistoryChatMessages -- Option
    //Is or not save history chat message
    public var isOrNotSaveHistoryChatMessages = false
    //3.2.navtalkBaseURL -- Option
    //webSockect's connected url
    public var navtalkBaseURL = "wss://transfer.navtalk.ai/wss/v2/realtime-chat"
    //3.3.AvatarInfoBaseURL:
    //(1).fetchAvatarInfoByName -- Option
    public var fetchAvatarInfoByName = "https://api.navtalk.ai/api/open/v1/avatar/getByName?name="
    //(2).fetchAvatarInfoById -- Option
    public var fetchAvatarInfoById = "https://api.navtalk.ai/api/open/v1/avatar/detail?avatarId="
   
    //4.Custom UI parameters
    //4.1.Background image displayed before the digital human is loaded:
    public var navtalk_chatpage_backgroundImage: UIImage?
    //4.2.Back button related:
    @MainActor
    public var navtalk_backButton_frame: CGRect?
    public var navtalk_backButton_image: UIImage?
    //4.3.Microphone button related:
    @MainActor
    public var navtalk_micphoneButton_frame: CGRect?
    public var navtalk_micphoneButton_image_off: UIImage?
    public var navtalk_micphoneButton_image_on: UIImage?
    public var navtalk_micphoneButton_title = "Microphone"
    public var navtalk_micphoneButton_titleColor = UIColor.white
    public var navtalk_micphoneButton_titleFont = UIFont.systemFont(ofSize: 12)
    public var navtalk_micphoneButton_isShow = true
    //4.4.Call button related:
    @MainActor
    public var navtalk_navtalkButton_frame: CGRect?
    public var navtalk_navtalkButton_image_off: UIImage?
    public var navtalk_navtalkButton_image_on: UIImage?
    public var navtalk_navtalkButton_image_connecting: UIImage?
    public var navtalk_navtalkButton_off_title = "Call"
    public var navtalk_navtalkButton_off_titleColor = UIColor.white
    public var navtalk_navtalkButton_off_titleFont = UIFont.systemFont(ofSize: 12)
    public var navtalk_navtalkButton_connecting_title = "Connecting…"
    public var navtalk_navtalkButton_connecting_titleColor = UIColor.white
    public var navtalk_navtalkButton_connecting_titleFont = UIFont.systemFont(ofSize: 12)
    public var navtalk_navtalkButton_on_title  = "Hang Up"
    public var navtalk_navtalkButton_on_titleColor = UIColor.white
    public var navtalk_navtalkButton_on_titleFont = UIFont.systemFont(ofSize: 12)
    //4.5.Camera button related:
    @MainActor
    public var navtalk_cameraButton_frame: CGRect?
    public var navtalk_cameraButton_image_off: UIImage?
    public var navtalk_cameraButton_image_on: UIImage?
    public var navtalk_cameraButton_title = "Camera"
    public var navtalk_cameraButton_titleColor = UIColor.white
    public var navtalk_cameraButton_titleFont = UIFont.systemFont(ofSize: 12)
    public var navtalk_cameraButton_isShow = true
    //4.6.Camera preview related:
    @MainActor
    public var navtalk_cameraPreview_frame: CGRect?
    public var navtalk_cameraPreview_isShow = true
    public var navtalk_switchCameraButton_frame: CGRect?
    public var navtalk_switchCameraButton_isShow = true
    public var navtalk_switchCameraButton_image: UIImage?
    //4.7.Message list related:
    @MainActor
    //(1).List
    public var navtalk_messageList_frame: CGRect?
    public var navtalk_messageList_enableGradient = true
    public var navtalk_messageList_isShow = true
    //(2).Item-AI
    public var navtalk_messageItem_ai_backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 38/255, alpha: 1)
    public var navtalk_messageItem_ai_titleColor = UIColor.white
    public var navtalk_messageItem_ai_titleFont = UIFont.systemFont(ofSize: 14)
    public var navtalk_messageItem_ai_cornerRadius = 8.0
    //(3).Item-User
    public var navtalk_messageItem_user_backgroundColor = UIColor(red: 108/255, green: 105/255, blue: 170/255, alpha: 1)
    public var navtalk_messageItem_user_titleColor = UIColor.white
    public var navtalk_messageItem_user_titleFont = UIFont.systemFont(ofSize: 14)
    public var navtalk_messageItem_user_cornerRadius = 8.0
    
    //Other Param
    //Avatar Image URL
    var avatar_image_url = ""
    //Avatar Provide Type Name
    var avatar_provider_type = ""
    
    
    //5.Add Function Call
    public var all_function_array = [[String: Any]]()
    public func addFunctionCall(functionCallName: String, functionCallDescription: String, functionCallProperties:[[String: Any]]){
        let function_dict: [String : Any] = ["functionCall_Name": functionCallName, "functionCall_Description": functionCallDescription, "functionCall_Properties": functionCallProperties]
        all_function_array.append(function_dict)
    }
    public var handleFunctionCallFromSDK: (([String: Any])->())?
    
    //6.Show Chat VC
    public func showNavTalkChatViewController(vc: UIViewController){
        if license.count <= 0{
            DispatchQueue.main.async {
                vc.view.makeToast("Please set the license parameter first; it is your API Key.", duration: 3.0, position: ToastPosition.center, title: "")
            }
            return
        }
        if characterName.count <= 0 && characterId.count <= 0{
            DispatchQueue.main.async {
                vc.view.makeToast("Please set the characterName or characterId first; it is your avatar.", duration: 3.0, position: ToastPosition.center, title: "")
            }
            return
        }
        DispatchQueue.main.async {
            let chatVC = RealTimeTalkVC()
            chatVC.modalPresentationStyle = .fullScreen
            vc.present(chatVC, animated: true)
        }
    }
    
    
    
}
