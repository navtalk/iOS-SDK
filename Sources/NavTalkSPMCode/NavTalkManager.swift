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
    //2.1.Required Params
    //Your Api Kye Here -- Requied
    public var license = ""
    //Your Avatar Name Here -- Requied
    //Option 1: Connect using character name
    public var characterName = "Brain"
    //Option 2: Connect using avatarId (recommended, higher priority)
    //Test: faab967a08e1731076b39edd9538636f
    public var characterId = ""
    
    // Is or not save history chat message
    public var isOrNotSaveHistoryChatMessages = false

    //Avatar Image URL
    var avatar_image_url = ""
    //Avatar Provide Type Name
    var avatar_provider_type = ""
    
    
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
        if characterName.count <= 0{
            DispatchQueue.main.async {
                vc.view.makeToast("Please set the characterName parameter first; it is your avatar name.", duration: 3.0, position: ToastPosition.center, title: "")
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
