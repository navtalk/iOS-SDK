# NavTalkSPMCode

## Xcode configuration

1.Creating a Swift Project

2.Minimum project version: 15.0

3.Add privacy permission requests in Target –> Info:

  Privacy - Microphone Usage Description

  We need access to your microphone to record audio.

## Installation

Xcode --> File --> Add Package Dependencies... --> Serch: https://github.com/navtalk/iOS-SDK.git --> Add Package


## Usage
![Chat Interface Screenshot](Sources/Assets/ChatShot.png)

1.Import the header file at the top of the file where the chat interface will be displayed:
```ruby
import NavTalkSPMCode
```

2.NavTalk available license (required):
```ruby
NavTalkManager.shared.license = "*******"
```

3.Initialize parameters (optional):

  3.1.Access the NavTalk domain (usually the default is fine)
  ```ruby
    NavTalkManager.shared.baseUrl = "transfer.navtalk.ai"
  ```
  
  3.2.Select character type. [NavTalk Supported Characters](https://navtalk.gitbook.io/api/real-time-digital-human-api/system-character#system-supported-characters)
  ```ruby
    NavTalkManager.shared.baseUrl = "transfer.navtalk.ai"
  ```
  
  3.3.Modify the sound effect type of voice chat. [NavTalk Supported Voice](https://navtalk.gitbook.io/api/real-time-digital-human-api/editor#supported-voice-styles-voice)
  ```ruby
    NavTalkManager.shared.voice_type = "verse"
  ```
  
  3.4.Whether to clear local chat history (whether to clear previous chat data when entering the chat interface)
  ```ruby
    NavTalkManager.shared.isClearLocalChatMessagesHistoryData = true
  ```
  
  3.5.Whether to send historical chat messages (whether to send historical chat data each time connecting to the NavTalk server)
  ```ruby
    NavTalkManager.shared.isSendOpenAIChatMessagesHistoryData = true
  ```
  

4.FunctionCall related:

  Example: Calculate the sum of two numbers.
  
  (1).Add FunctionCall
  ```ruby
  var functionCallProperties = [[String: Any]]()
  let functionCallProperty1: [String: Any] = [
      "property_name": "number1",
      "property_type": "string",
      "property_description": "This is the first number to be added. This data must be obtained. If this parameter is missing, please ask me: What is the first number?",
      "property_isRequired": true
    ]
  let functionCallProperty2: [String: Any] = [
    "property_name": "number2",
    "property_type": "string",
    "property_description": "This is the second number to be added. This data must be obtained. If this parameter is missing, please ask me: What is the second number?",
    "property_isRequired": true
    ]
  functionCallProperties.append(functionCallProperty1)
  functionCallProperties.append(functionCallProperty2)
  NavTalkManager.shared.addFunctionCall(functionCallName: "thisAddFunction", functionCallDescription: "Please perform addition. Both parameter numbers must be obtained. Once both numbers are retrieved, please directly return their sum.", functionCallProperties: functionCallProperties)
  ```
  
  (2).Trigger FunctionCall
  ```ruby
  NavTalkManager.shared.shared.handleFunctionCallFromSDK = {functioncall_message in
      //print("functionCall_ReturnData:\(functioncall_message)")
      guard let name = functioncall_message["name"] as? String else{return}
      if name == "thisAddFunction",
          let arguments = functioncall_message["arguments"] as? [String: Any],
          let number1 = Float(arguments["number1"] as? String ?? ""),
          let number2 = Float(arguments["number2"] as? String ?? ""){
          print("\n number1=\(number1),number2=\(number2)\n result=\(number1+number2)")
      }
  }
  ```
    
5.Navigate to the chat interface in your UIViewController (required):
  ```ruby
  NavTalkManager.shared.showChatVC(fromVC: self)
  ```
  
## Specific usage demo

NavTakl iOS Demo Code | Fully open source | Swift code available on GitHub | [GitHub](https://github.com/navtalk/Samples/tree/main/iOS)

## Related Projects

If you want to learn more about AI or chat-related projects, you can check out my other project.[navtalk](https://github.com/navtalk/Samples/tree/main)

## Author

Frank Fu, fuwei007@gmail.com




