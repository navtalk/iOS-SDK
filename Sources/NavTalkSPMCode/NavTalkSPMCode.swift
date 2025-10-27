
import Foundation
import UIKit

public class NavTalkManager: NSObject, @unchecked Sendable{
    
    //MARK: 0.Required Parammeter Data:
    public var license = ""
    public var baseUrl = "transfer.navtalk.ai"
    // Currently supported characters include: navtalk.Alex, navtalk.Ethan, navtalk.Leo, navtalk.Lily, navtalk.Emma, navtalk.Sophia, ...
    public var characterName = "navtalk.Leo"
    // alloy/shimmer/ballad/coral/echo/ash/sage/verse
    public var voice_type = "verse"
    
    public var isClearLocalChatMessagesHistoryData = false
    public var isSendOpenAIChatMessagesHistoryData = false
    
    //MARK: 1.init
    public static let shared = NavTalkManager()
    private override init(){
        super.init()
    }
    
    //MARK:2.Show Chat View
     public func showChatVC(fromVC: UIViewController){
         Task{@MainActor in
             if license.count == 0{
                 let alertVC = UIAlertController(title: "Please set your license first!", message: "", preferredStyle: .alert)
                 alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                 fromVC.present(alertVC, animated: true)
                 return
             }
             
             NetworkMonitor.shared.start()
             
             let vc = RealTimeTalkVC()
             vc.modalPresentationStyle = .fullScreen
             fromVC.present(vc, animated: true)
         }
    }
    
    //MARK: 3.Handle message list
    public func getAllMessagesListData() -> [[String: Any]]{
        var messagesListModels = [[String: Any]]()
        if let localMessageList = UserDefaults.standard.value(forKey: "localMessageList_AIChatBotiOSSDK") as? [[String: Any]],
           localMessageList.count > 0{
            messagesListModels.append(contentsOf: localMessageList)
        }
        return messagesListModels
    }
    public func saveMessageWithDictData(message: [String: Any]){
        var messagesListModels = [[String: Any]]()
        if let localMessageList = UserDefaults.standard.value(forKey: "localMessageList_AIChatBotiOSSDK") as? [[String: Any]],
           localMessageList.count > 0{
            messagesListModels.append(contentsOf: localMessageList)
        }
        messagesListModels.append(message)
        UserDefaults.standard.set(messagesListModels, forKey: "localMessageList_AIChatBotiOSSDK")
        UserDefaults.standard.synchronize()
    }
    public func removeMessagesInLocal(){
        UserDefaults.standard.removeObject(forKey: "localMessageList_AIChatBotiOSSDK")
        UserDefaults.standard.synchronize()
    }
    //MARK: 4.Function Call
    public var all_function_array = [[String: Any]]()
    public func addFunctionCall(functionCallName: String, functionCallDescription: String, functionCallProperties:[[String: Any]]){
        let function_dict: [String : Any] = ["functionCall_Name": functionCallName, "functionCall_Description": functionCallDescription, "functionCall_Properties": functionCallProperties]
        all_function_array.append(function_dict)
    }
    public var handleFunctionCallFromSDK: (([String: Any])->())?
}
