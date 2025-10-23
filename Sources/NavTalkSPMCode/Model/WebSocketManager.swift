
import Foundation
import AVFoundation
import Starscream
import Toast

class WebSocketManager: NSObject, WebSocketDelegate, @unchecked Sendable{
    
    var superVC: RealTimeTalkVC!
    
    enum websocketStatus: Int{
        case NotConnected = 0
        case Connectting = 1
        case Connected = 2
        case UpdatedSession = 3
    }
    
    //MARK: 1.init
    static let shared = WebSocketManager()
    private override init(){
        super.init()
    }
    
    //MARK: 2.Connect NavTalk WebSocket
    var socket_status: websocketStatus = .NotConnected
    var socket: WebSocket!
    
  
    @MainActor func connectWebSocketOfNavTalk(){
        
        if socket_status == .NotConnected{
            //(1).
            let encodedLicense = NavTalkManager.shared.license.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedCharacterName = NavTalkManager.shared.characterName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            guard let url = URL(string: "wss://\(NavTalkManager.shared.baseUrl)/api/realtime-api?license=\(encodedLicense)&characterName=\(encodedCharacterName)") else { return }
            //2.
            let request = URLRequest(url: url)
            socket = WebSocket(request: request)
            socket.delegate = self
            socket.connect()
            socket_status = .Connectting
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
        }else if socket_status == .Connected{
            getCurrentVc().view.makeToast("The WebSocket is already connected, no need to connect again.")
            //MBProgressHUD.showTextWithTitleAndSubTitle(title: "The WebSocket is already connected, no need to connect again.", subTitle: "", view:  getCurrentVc().view)
        }else if socket_status == .Connectting{
            getCurrentVc().view.makeToast("The WebSocket is currently connecting, please try again later.")
            //MBProgressHUD.showTextWithTitleAndSubTitle(title: "The WebSocket is currently connecting, please try again later.", subTitle: "", view: getCurrentVc().view)
        }
        
        
    }
    
    //MARK: 3.Disconnect NavTalk WebSocket
    func disconnectWebSocketOfNavTalk(){
        if socket_status == .Connected{
            print("try close WebSocket1")
            socket.disconnect()
        }else if socket_status == .NotConnected{
            
        }else if socket_status == .Connectting{
            print("try close WebSocket2")
            socket.disconnect()
        }else if socket_status == .UpdatedSession{
            print("try close WebSocket3")
            socket.disconnect()
        }
        
    }
    //MARK: 4.WebSocketDelegate： When webSocket received a message
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        print("===========================")
        switch event {
            case .connected(let headers):
                print("WebSocket--WebSocket is connected:\(headers)")
                self.socket_status = .Connected
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
                break
            case .disconnected(let reason, let code):
                print("WebSocket-WebSocket disconnected: \(reason) with code: \(code)")
                self.socket_status = .NotConnected
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
                break
            case .text(let text):
                //print("Received text message:")
                handleRecivedMeaage(message_string: text)
                break
            case .binary(let data):
                print("WebSocket-Process the returned binary data (such as audio data): \(data.count)")
                break
            case .pong(let data):
                print("WebSocket-Received pong: \(String(describing: data))")
                break
            case .ping(let data):
                print("WebSocket-Received ping: \(String(describing: data))")
                break
            case .error(let error):
                print("WebSocket-Error: \(String(describing: error))")
                DispatchQueue.main.async {
                   getCurrentVc().view.makeToast("The WebSocket has some error.")
                }
                self.socket_status = .NotConnected
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
                break
            case .viabilityChanged(let isViable):
                print("WebSocket-WebSocket feasibility has changed: \(isViable)")
                break
            case .reconnectSuggested(let isSuggested):
                print("WebSocket-Reconnect suggested: \(isSuggested)")
                break
            case .cancelled:
                print("WebSocket-WebSocket was cancelled")
                break
            case .peerClosed:
                print("WebSocket-WebSocket peer closed")
                self.socket_status = .NotConnected
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
        }
    }
    
    //MARK: 5.
    func settingThisTalkConfiguration(){
        var sessionConfig = [String: Any]()
        sessionConfig["type"] = "session.update"
        var session = [String: Any]()
        session["instructions"] = "iOS Demo Chat"
        session["voice"] = NavTalkManager.shared.voice_type
        session["temperature"] = 1
        session["modalities"] = ["text", "audio"]
        session["input_audio_format"] = "pcm16"
        session["output_audio_format"] = "pcm16"
        session["input_audio_transcription"] = ["model": "whisper-1"]
        //FuncationCall:
        /*
        let tools = [
            [
                "type": "function",
                "name": "function_call_close_talk",
                "description": "Trigger this method when ending or dropping the current call.",
                "parameters": [
                    "type": "object",
                    "properties": [
                        "userInput": [
                            "type": "string",
                            "description": "Raw user request content to be processed"
                        ]
                    ],
                    "required": ["userInput"]
                ]
            ]
        ]
        session["tools"] = tools
        */
        //5.2.Function Call
        //tools
        var tools_array = [[String: Any]]()
        for i in 0..<NavTalkManager.shared.all_function_array.count {
            let functionCall_Name = NavTalkManager.shared.all_function_array[i]["functionCall_Name"] as? String ?? ""
            let functionCall_Description = NavTalkManager.shared.all_function_array[i]["functionCall_Description"] as? String ?? ""
            var tool_dict = [String: Any]()
            tool_dict["type"] = "function"
            tool_dict["name"] = functionCall_Name
            tool_dict["description"] = functionCall_Description
            
            var properties = [String: Any]()
            var required = [String]()
            if let functionCall_Properties = NavTalkManager.shared.all_function_array[i]["functionCall_Properties"] as? [[String: Any]]{
                for property_value in functionCall_Properties{
                    let property_name = property_value["property_name"] as? String ?? ""
                    let property_type = property_value["property_type"] as? String ?? ""
                    let property_description = property_value["property_description"] as? String ?? ""
                    let property_isRequired = property_value["property_isRequired"] as? Bool ?? false
                    if property_name.count > 0{
                        properties[property_name] = [
                            "type": property_type,
                             "description": property_description
                        ]
                        if property_isRequired{
                            required.append(property_name)
                        }
                    }
                }
            }
            tool_dict["parameters"] = [
                "type": "object",
                "properties": properties,
                "required": required
            ]
            tools_array.append(tool_dict)
        }
        session["tools"] = tools_array

        sessionConfig["session"] = session
        if let jsonData = try? JSONSerialization.data(withJSONObject: sessionConfig),
           let jsonString = String(data: jsonData, encoding: .utf8){
            WebSocketManager.shared.socket.write(string: jsonString) {
                print("===========================\nConfigure session information:\(jsonData)")
            }
        }
    }
    
    //MARK: 6.
    var audio_String = ""
    var audio_String_count = 0
    func handleRecivedMeaage(message_string: String){
        //(1).String-->Dictionay
        let  message_jsonData = message_string.data(using: .utf8) ?? Data()
        var message_dict = [String: Any]()
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: message_jsonData, options: []) as? [String: Any] {
                message_dict = dictionary
            }
        } catch {
            print("Conver fail: \(error.localizedDescription)")
        }
        if let type = message_dict["type"] as? String, type == "response.audio.delta"{
            
        }else{
            print("handle returned data:\(message_dict)")
        }
        //(2).session.created
        if let type = message_dict["type"] as? String, type == "session.created"{
            settingThisTalkConfiguration()
            return
        }
        
        //(3).session.updated
        if let type = message_dict["type"] as? String, type == "session.updated"{
            print("===========================\nConfigure session Success")
            RecordAudioManager.shared.startRecordAudio()
            self.socket_status = .UpdatedSession
            Task{@MainActor in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WebSocketManager_socket_status_changed"), object: nil)
            }
            return
        }
        //(4).input_audio_buffer.speech_started:
        //When OpenAI detects someone speaking, it returns the following message.
        if let type = message_dict["type"] as? String, type == "input_audio_buffer.speech_started"{
            //print("===========================\nConfigure session Success")
            return
        }
        
        //(5).The audio data increment returned by OpenAI: divided into N packets sent sequentially to the frontend until all packets are sent.
        if let type = message_dict["type"] as? String, type == "response.audio.delta"{
            if let delta = message_dict["delta"] as? String{
                //Play Audio
            }
        }
        //(6).The transcribed text content of each incremental packet of audio data returned by OpenAI: divided into N packets sent sequentially to the frontend until all packets are sent.
        if let type = message_dict["type"] as? String, type == "response.audio_transcript.delta"{
            /*
             if let delta = message_dict["delta"] as? String{
                print("\(type)--->\(delta)")
            }*/
        }
        //(7).This is the complete transcribed text content of a detected speech question by OpenAI (the sum of all increments).
        if let type = message_dict["type"] as? String, type == "conversation.item.input_audio_transcription.completed"{
            if let transcript = message_dict["transcript"] as? String{
                let dict = ["text": transcript]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HaveInputText"), object: dict)
            }
        }
        //(8).Complete a reply.
        if let type = message_dict["type"] as? String, type == "response.done"{
            if let response = message_dict["response"] as? [String: Any],
               let output = response["output"] as? [[String: Any]],
               output.count > 0,
               let first_output = output.first,
               let content = first_output["content"] as? [[String: Any]],
               content.count > 0,
               let first_content = content.first,
               let transcript = first_content["transcript"] as? String{
                  let dict = ["text": transcript]
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HaveOutputText"), object: dict)
            }
        }
        //(9).response.function_call_arguments.done
        if let type = message_dict["type"] as? String, type == "response.function_call_arguments.done"{
            Task { @MainActor in
                handleFunctionCall(message: message_dict)
            }
        }
        
    }
    //MARK: 7.Send History Data
    func sendHistoryToCurrentChat(allMessageModels: [[String: Any]]){
        let allMessageModels = allMessageModels
        var allQuestionsMessageModels = [[String: Any]]()
        for value in allMessageModels{
            if let type = value["type"] as? String, type == "question"{
                allQuestionsMessageModels.append(value)
            }
        }
        print("Try To Send History Message: \(allQuestionsMessageModels)")
        for value in allQuestionsMessageModels{
            let content_text = value["content"] as? String
            var message = [String: Any]()
            message["type"] = "conversation.item.create"
            message["item"] = [
                "type": "message",
                "role": "user",
                "content": [
                    [
                        "type": "input_text",
                        "text": content_text
                    ]
                ]
            ]
            if let jsonData = try? JSONSerialization.data(withJSONObject: message),
               let jsonString = String(data: jsonData, encoding: .utf8){
                WebSocketManager.shared.socket.write(string: jsonString) { [weak self] in
                    guard self != nil else { return }
                    print("===========================\nSend History Data Success")
                }
            }
        }
    }
    
    //MARK: 8.FunctionCall
    @MainActor func handleFunctionCall(message: [String: Any]){
        print("FunctionCall:\(message)")
       /*
       ["call_id": call_FpjEsnhzjawKwfye, "event_id": event_CL1O3Hwh8vmP9zbCSM648, "output_index": 0, "arguments": {
         "userInput": "***"
       }
       , "type": response.function_call_arguments.done, "item_id": item_CL1O2jXM1jTwuUKWhfLP6, "name": function_call_close_talk, "response_id": resp_CL1O2od9yCw9OYKNb31Vi]
       */
        var functioncall_message = message
        if let arguments_string = functioncall_message["arguments"] as? String,
           arguments_string.count > 0{
            if let jsonData = arguments_string.data(using: .utf8) {
                do {
                    if let arguments_Object = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        functioncall_message["arguments"] = arguments_Object
                    }
                }catch{
                    print("parse JSON error: \(error.localizedDescription)")
                }
            }
        }
        NavTalkManager.shared.handleFunctionCallFromSDK?(functioncall_message)
    }
}
