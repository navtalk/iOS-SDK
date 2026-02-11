import Foundation
import Toast
import UIKit

public class NavTalkManager: NSObject, @unchecked Sendable{
    
    //1.Initatial
    public static let shared = NavTalkManager()
    private override init(){
        super.init()
    }
    
    //2.All Params In NavTalk Swifit Package Manager:
    //WebSocket URL
    public var websocketUrl = "wss://transfer.navtalk.ai/wss/v2/realtime-chat"
    // your api kye here -- Requied
    public var license = ""
    // Currently supported characters include: navtalk.Leo, navtalk.Emily, navtalk.Lisa
    // https://docs.navtalk.ai/api/resources/avatars
    public var characterName = "navtalk.Freya"
    // optional
    public var modelName = "gpt-realtime-mini"
    // alloy/shimmer/ballad/coral/echo/ash/sage/verse
    // https://docs.navtalk.ai/api/real-time-digital-human-api/voice-styles
    public var voice_type = "verse"
    // Is or not save history chat message
    public var isOrNotSaveHistoryChatMessages = false
    
    //3.Add Function Call
    public var all_function_array = [[String: Any]]()
    public func addFunctionCall(functionCallName: String, functionCallDescription: String, functionCallProperties:[[String: Any]]){
        let function_dict: [String : Any] = ["functionCall_Name": functionCallName, "functionCall_Description": functionCallDescription, "functionCall_Properties": functionCallProperties]
        all_function_array.append(function_dict)
    }
    public var handleFunctionCallFromSDK: (([String: Any])->())?
    
    //4.Show Chat VC
    public func showNavTalkChatViewController(vc: UIViewController){
        if license.count <= 0{
            DispatchQueue.main.async {
                vc.view.makeToast("Please set the license parameter first; it is your API Key.", duration: 3.0, position: ToastPosition.center, title: "")
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
