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

  - Key: Privacy - Microphone Usage Description  
  - Value: We need access to your microphone to record audio.

  - Key: Privacy - Camera Usage Description      
  - Value: The app needs access to the camera to capture images.

## Installation

Xcode –> File –> **Add Package Dependencies...**

Search: https://github.com/navtalk/iOS-SDK.git 

Then click **Add Package**.

## Usage
![Chat Interface Screenshot](Sources/Assets/NavTalk_First_Shot.PNG)

1.Import the SDK in the file where the chat interface will be displayed (required)
```swift
  import NavTalkSPM
```

2.Required configuration parameters (required)

2.1.NavTalk License (required)
```swift
  NavTalkManager.shared.license = "*******"
```

2.2.NavTalk Avatar Name Or Avatar Id (required)
```swift
  NavTalkManager.shared.characterName = "*******"
  NavTalkManager.shared.characterId = "*******"
```
  - Note: characterName: not unique, characterId: unique
  - Note: You must provide one of the two parameters; if both are provided, characterId will be used.
  - Note: When the system role provider is 11Labs, function call and image recognition are not supported.
  - Custom roles support function call and image recognition only when OpenAIRealtime is selected.

2.3.Navigate to the chat interface in your UIViewController (required)
```swift
  NavTalkManager.shared.showNavTalkChatViewController(vc: self)
```

3.Custom configuration parameters (optional)

3.1.Whether to save chat history locally, default is false
```swift
  NavTalkManager.shared.isOrNotSaveHistoryChatMessages = false
```

3.2.WebSocket domain, default is production environment
```swift
  NavTalkManager.shared.navtalkBaseURL = "wss://transfer.navtalk.ai/wss/v2/realtime-chat"
```
  - Self-hosted users can customize their own domain.

3.3.URL for fetching avatar information:

(1).API endpoint to get avatar details by AvatarName.
```swift
  NavTalkManager.shared.fetchAvatarInfoByName = "https://api.navtalk.ai/api/open/v1/avatar/getByName?name="
```
(2).API endpoint to get avatar details by AvatarId.
```swift
  NavTalkManager.shared.fetchAvatarInfoById = "https://api.navtalk.ai/api/open/v1/avatar/detail?avatarId="
```

4.Custom UI parameters (optional)

4.1.Background image displayed before the digital human is loaded:
```swift
  NavTalkManager.shared.navtalk_chatpage_backgroundImage = UIImage(named: "******")
```

4.2.Back button related:
```swift
  // Set the size and position of the back button
  NavTalkManager.shared.navtalk_backButton_frame = CGRect(x: 100, y: 100, width: 50, height: 50)
  // Set the icon of the back button
  NavTalkManager.shared.navtalk_backButton_image = UIImage(named: "******")
```

4.3.Microphone button related:
```swift
  // Set the frame (position and size) of the microphone button
  NavTalkManager.shared.navtalk_micphoneButton_frame = CGRect(x: 10, y: 700, width: 120, height:120)
  // Set the image when the microphone button is ON (active state)
  NavTalkManager.shared.navtalk_micphoneButton_image_on = UIImage(named: "******")
  // Set the image when the microphone button is OFF (inactive state)
  NavTalkManager.shared.navtalk_micphoneButton_image_off = UIImage(named: "******")
  // Set the title text of the microphone button
  NavTalkManager.shared.navtalk_micphoneButton_title = "test_micphone"
  // Set the title color of the microphone button
  NavTalkManager.shared.navtalk_micphoneButton_titleColor = UIColor.red
  // Set the title font size of the microphone button
  NavTalkManager.shared.navtalk_micphoneButton_titleFont = UIFont.systemFont(ofSize: 10)
  // Whether to show the microphone button
  NavTalkManager.shared.navtalk_micphoneButton_isShow = true
```

4.4.Call button related:
```swift
  // Set the frame (position and size) of the NavTalk button
  NavTalkManager.shared.navtalk_navtalkButton_frame = CGRect(x: UIScreen.main.bounds.size.width/2-120/2, y: 700, width: 120, height: 120)
  // Set the button image for OFF state
  NavTalkManager.shared.navtalk_navtalkButton_image_off = UIImage(named: "******")
  // Set the button image for CONNECTING state
  NavTalkManager.shared.navtalk_navtalkButton_image_connecting = UIImage(named: "******")
  // Set the button image for ON state
  NavTalkManager.shared.navtalk_navtalkButton_image_on = UIImage(named: "******")
  // Set the title text for OFF state (before call starts)
  NavTalkManager.shared.navtalk_navtalkButton_off_title = "test_Call"
  // Set the title color for OFF state
  NavTalkManager.shared.navtalk_navtalkButton_off_titleColor = UIColor.blue
  // Set the title font for OFF state
  NavTalkManager.shared.navtalk_navtalkButton_off_titleFont = UIFont.systemFont(ofSize: 10)
  // CONNECTING state
  NavTalkManager.shared.navtalk_navtalkButton_connecting_title = "test_Connecting…"
  NavTalkManager.shared.navtalk_navtalkButton_connecting_titleColor = UIColor.red
  NavTalkManager.shared.navtalk_navtalkButton_connecting_titleFont = UIFont.systemFont(ofSize: 10)
  // ON state
  NavTalkManager.shared.navtalk_navtalkButton_on_title = "test_Hang Up"
  NavTalkManager.shared.navtalk_navtalkButton_on_titleColor = UIColor.yellow
  NavTalkManager.shared.navtalk_navtalkButton_on_titleFont = UIFont.systemFont(ofSize: 10)
```

4.5.Camera button related:
```swift
  // Set the frame (position and size) of the camera button
  NavTalkManager.shared.navtalk_cameraButton_frame = CGRect(x: UIScreen.main.bounds.size.width-120-10, y: 700, width: 120, height: 120)
  // Set the image for camera button OFF state
  NavTalkManager.shared.navtalk_cameraButton_image_off = UIImage(named: "******")
  // Set the image for camera button ON state
  NavTalkManager.shared.navtalk_cameraButton_image_on = UIImage(named: "******")
  // Set the title text of the camera button
  NavTalkManager.shared.navtalk_cameraButton_title = "test_camera"
  // Set the title color of the camera button
  NavTalkManager.shared.navtalk_cameraButton_titleColor = UIColor.red
  // Set the title font size of the camera button
  NavTalkManager.shared.navtalk_cameraButton_titleFont = UIFont.systemFont(ofSize: 10)
  // Whether to show the camera button
  NavTalkManager.shared.navtalk_cameraButton_isShow = true
```

4.6.Camera preview related:
```swift
  // Set the frame (position and size) of the camera preview
  NavTalkManager.shared.navtalk_cameraPreview_frame = CGRect(x: UIScreen.main.bounds.size.width-10-120, y: 100, width: 120, height: 180)
  // Whether to show the camera preview
  NavTalkManager.shared.navtalk_cameraPreview_isShow = true
  // Set the frame (position and size) of the switch camera button
  NavTalkManager.shared.navtalk_switchCameraButton_frame = CGRect(x: 120/2, y: 30/2, width: 30, height: 30)
  // Whether to show the switch camera button
  NavTalkManager.shared.navtalk_switchCameraButton_isShow = true
  // Set the image of the switch camera button
  NavTalkManager.shared.navtalk_switchCameraButton_image = UIImage(named: "******")
```

4.7.Message list related:
```swift
  // Message List Configuration
  NavTalkManager.shared.navtalk_messageList_frame = CGRect(x: 0, y: 300, width: 250, height: 300)
  NavTalkManager.shared.navtalk_messageList_enableGradient = false
  NavTalkManager.shared.navtalk_messageList_isShow = true
  // AI Message Item Style
  NavTalkManager.shared.navtalk_messageItem_ai_backgroundColor = UIColor.blue
  NavTalkManager.shared.navtalk_messageItem_ai_titleColor = UIColor.black
  NavTalkManager.shared.navtalk_messageItem_ai_titleFont = UIFont.systemFont(ofSize: 17)
  NavTalkManager.shared.navtalk_messageItem_ai_cornerRadius = 12.0
  // User Message Item Style
  NavTalkManager.shared.navtalk_messageItem_user_backgroundColor = UIColor.red
  NavTalkManager.shared.navtalk_messageItem_user_titleColor = UIColor.black
  NavTalkManager.shared.navtalk_messageItem_user_titleFont = UIFont.systemFont(ofSize: 18)
  NavTalkManager.shared.navtalk_messageItem_user_cornerRadius = 5.0
```

5.Function Call (Optional)

- Example: A function that calculates the sum of two numbers.
  
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
    

## Specific usage demo

NavTalk iOS Demo Code | Fully open source | Swift code available on GitHub | [GitHub](https://github.com/navtalk/Samples/tree/main/iOS)

## Related Projects

If you want to learn more about AI or chat-related projects, check out:

[NavTalk Samples](https://github.com/navtalk/Samples)

## Author

Frank Fu, fuwei007@gmail.com



