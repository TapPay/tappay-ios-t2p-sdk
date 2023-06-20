# tappay-ios-t2p-sdk

### The TapPay iOS SDK helps you build Tap to Pay on iPhone into your iOS app

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
  |  :----  | :----  | :---- |
  | appKey  | String | 用於SDK的驗證金鑰(取得方式待補) |
  | serverType  | TPServerType | 使用的伺服器種類<br>測試時請使用 Sandbox 環境 (TPServerType.sandbox, .sandbox)<br>實體上線後請切換至 Production 環境 (TPServerType.production, .production) |

  ### Initialize service with TapPay portal account
  #### Function
  ```swift
  func setupWithAppKey(partnerAccount: String, email: String, password: String, serverType: TPServerType) async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPReader.shared.setupWithAppKey(partnerAccount: "Test", email: "Test@test.com", password: "Test", serverType: .production)
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | partnerAccount  | String | 建立於TapPay portal的partner account |
  | email  | String | 建立於TapPay portal的email |
  | password  | String | 建立於TapPay portal的密碼 |
  | serverType  | TPServerType | 使用的伺服器種類<br>測試時請使用 Sandbox 環境 (TPServerType.sandbox, .sandbox)<br>實體上線後請切換至 Production 環境 (TPServerType.production, .production) |
  ---

  ---
  ## Bind
  ### Get binding list
  #### Function
  ```swift
  func getBindingList(page: Int, countPerPage: Int) async throws -> Array<BindItem>
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          // Get 10 bind items per page, the first page of list
          let bindList = try await TPReader.shared.getBindingList(page: 0, countPerPage: 10)
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | page  | Int | 第幾頁 |
  | countPerPage  | Int | 每頁筆數 |

  #### Item detail
  ```swift
  struct BindItem: Codable {
    public let id: String?
    public let partnerId: Int
    public let acquirerId: Int
    public let acquirerName: String?
    public let acquirerIcon: String?
    public let merchantId: String?
    public let merchantAccount: String?
    public let terminalId: String?
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | id  | String | 綁定代號 |
  | partnerId  | Int | Partner代號 |
  | acquirerId  | Int | 收單機構代號 |
  | acquirerName  | Int | 收單機構名稱 |
  | acquirerIcon  | String | 收單機構logo |
  | merchantId  | String | TapPay商店代碼 |
  | merchantAccount  | String | 商店代號 |
  | terminalId  | String | 端末機代號 |
  | bindingInfo  | String | 綁定資訊 |

  ### Bind
  #### Function
  ```swift
  func bind(bindingInfo: String, description: String?) async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPReader.shared.bind(bindingInfo: "123456", description: "123456")
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | bindingInfo  | String | 綁定資訊 |
  | description  | String | 端末機備註 |

  ### Bind delete
  #### Function
  ```swift
  func bindDelete() async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPReader.shared.bindDelete()
      }catch {
          // error handling
      }
  }
  ```
  ---
