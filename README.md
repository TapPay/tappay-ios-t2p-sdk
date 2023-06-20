# tappay-ios-t2p-sdk

### The TapPay iOS SDK helps you build Tap to Pay on iPhone into your iOS app

<details>
  <summary>SDK Reference</summary>
  
  ---
  ## Initialize
  ### Initialize service with app key
  #### Function
  ```swift
  func setupWithAppKey(appKey: String, serverType: TPServerType) async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPReader.shared.setupWithAppKey(appKey: "123456789", serverType: .production)
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  ----  | ----  | ---- |
  | appKey  | String | 用於SDK的驗證金鑰(取得方式待補) |
  | serverType  | TPServerType | 使用的伺服器種類<br>測試時請使用 Sandbox 環境 (TPServerType.sandbox, .sandbox)<br>實體上線後請切換至 Production 環境 (TPServerType.production, .production) |
  ---
</details>
