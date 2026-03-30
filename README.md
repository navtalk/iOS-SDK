# NavTalkSPMCode

NavTalkSPM is an iOS SDK that allows developers to quickly integrate AI-powered voice and chat interfaces into their applications.

## Get Project License and Custom Avatar

Before using the SDK, you need to obtain a **project license** and configure a **custom avatar**.

Please apply for them here: 
[NavTalk Console](https://console.navtalk.ai/#/)

## Xcode Configuration

1.Creating a Swift Project

2.Minimum project version: 15.0

3.Add privacy permission requests in Target –> Info:

  (1).Key: Privacy - Microphone Usage Description  
      Value: We need access to your microphone to record audio.

  (2).Key: Privacy - Camera Usage Description      
      Value: The app needs access to the camera to capture images.

## Installation

Xcode –> File –> **Add Package Dependencies...**

Search: https://github.com/navtalk/iOS-SDK.git 

Then click **Add Package**.

## Usage
![Chat Interface Screenshot](Sources/Assets/NavTalk_First_Shot.PNG)

1.Import the SDK in the file where the chat interface will be displayed
```swift
  import NavTalkSPM
```

2.NavTalk License (required)
```swift
  NavTalkManager.shared.license = "*******"
```

3.NavTalk Avatar Name (required)
```swift
  NavTalkManager.shared.characterName = "*******"
```
  - Note: name: The name of the digital human character (query method 1)
  - Note: avatarId: Direct avatar ID for precise lookup (query method 2, higher priority)
  - Note: Query Priority: If both avatarId and name are provided, avatarId takes precedence.
  - Note: Multiple Avatars Warning: If using name query and multiple avatars share the same name, the system will:  
    - Automatically select the most recently updated avatar  
    - Send a conversation.connected.warning event with the selected avatarId immediately after the connection success event  
  - Note: When the system role provider is 11Labs, function call and image recognition are not supported.
  - Custom roles support function call and image recognition only when OpenAIRealtime is selected.
  

4.Save chat history locally (optional)
```swift
  NavTalkManager.shared.isOrNotSaveHistoryChatMessages = false
```

5.Function Call (Optional)

  Example: A function that calculates the sum of two numbers.
  
  (1) Add Function Call
  ```swift
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
  
  (2) Trigger Function Call
  ```swift
    NavTalkManager.shared.handleFunctionCallFromSDK = {functioncall_message in
      //print("functionCall_ReturnData:\(functioncall_message)")
      guard let name = functioncall_message["name"] as? String else { return }
      if name == "thisAddFunction",
          let arguments = functioncall_message["arguments"] as? [String: Any],
          let number1 = Float(arguments["number1"] as? String ?? ""),
          let number2 = Float(arguments["number2"] as? String ?? ""){
          print("\n number1=\(number1),number2=\(number2)\n result=\(number1+number2)")
      }
    }
  ```
    
6.Navigate to the chat interface in your UIViewController (required)
```swift
  NavTalkManager.shared.showNavTalkChatViewController(vc: self)
```
  
## Specific usage demo

NavTalk iOS Demo Code | Fully open source | Swift code available on GitHub | [GitHub](https://github.com/navtalk/Samples/tree/main/iOS)

## Related Projects

If you want to learn more about AI or chat-related projects, check out:

[NavTalk Samples](https://github.com/navtalk/Samples)

## Author

Frank Fu, fuwei007@gmail.com




