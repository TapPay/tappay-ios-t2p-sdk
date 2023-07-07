# tappay-ios-t2p-sdk

### The TapPay iOS SDK helps you build Tap to Pay on iPhone into your iOS app

---
## How to start
### Get your App key
#### 請洽TapPay業務
### Install the SDK
1. 進入TPT2P-Example，複製TPSDKT2P.framework到您的專案下
2. 開啟您的專案，到Build Phases下，展開Link Binary With Libraries，點擊"+"並加入TPSDKT2P.framework

### Setup entitlement file
1. 新增T2P功能到開發用的Apple ID
    - 登入[Apple Developer](https://developer.apple.com/account)帳號，點選Certificates, Identifiers & Profiles
    - 在側邊欄點選Identifiers
    - 從列表中選取要導入T2P功能的App
    - 選擇Additional Capabilities<br><br>
    ![](./Images/App_ID_Configuration.png)<br><br>
    - 勾選T2P
    - 儲存設定
    - 新增配置該App ID的provisioning profile，下載並開啟，在App專案內選擇使用該provisioning profile (如果已經新增過該provisioning profile，重新下載即可)<br><br>
2. 新增entitlements file到App專案內<br><br>
![](./Images/Create_Entitlements_File.png)<br><br>
    - 在App專案內新增檔案，新增一個property list
    - 將檔名替換為 ___________.entitlements (檔案格式依舊為.plist)，空白部分請填入App專案名稱
    - 到Project Editor，點選Build Settings
    - 點選All和點選Combined
    - 搜尋Code Signing Entitlements<br><br>
    ![](./Images/Setup_Entitlements_Path.png)<br><br>
    - 輸入剛剛產生的檔案的路徑
    - 開啟該檔案，新增key為com.apple.developer.proximity-reader.payment.acceptance，value type為Boolean，value設定為true (P.S. 如果你的專案內已有.entitlements檔案，直接執行最後一步即可)<br><br>
    ![](./Images/Setup_Entitlements_File.png)

### Setup Location Privacy Settings
由於使用此SDK必須開啟GPS的功能，故須到Info.plist新增NSLocationWhenInUseUsageDescription

---
## SDK initialize
![](./Images/SDK_Initialize.png) <br><br>
## Start to use SDK
![](./Images/T2P_SDK_Flow.svg)
![](./Images/TPSDKT2P_Flow.png)
---

---
  ## Initialize
  ### Initialize service with app key
  #### Function
  ```swift
  func setupWithAppKey(_ registeredAppKey: String!, _ environment: Environment!) async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPT2PManager.shared.setupWithAppKey("123456789", .production)
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | registeredAppKey  | String | 用於SDK的驗證金鑰(取得方式待補) |
  | environment  | Environment | 使用的伺服器種類<br>測試時請使用 Sandbox 環境 (Environment.sandbox, .sandbox)<br>實體上線後請切換至 Production 環境 (Environment.production, .production) |

  ---
  ## Bind
  ### Get binding list
  #### Function
  ```swift
  func getBindingList(page: Int, countPerPage: Int) async throws -> [BindItem]?
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          // Get 10 bind items per page, the first page of list
          let bindList = try await TPT2PService.shared.getBindingList(page: 0, countPerPage: 10)
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
    public let hash: String?
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
  | hash  | String | 綁定資訊 |

  ### Bind
  #### Function
  ```swift
  func bind(bindItem: BindItem, description: String?) async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPT2PService.shared.bind(bindItem: BindItem(), description: "123456")
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | bindItem  | BindItem | 綁定資訊 |
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
          try await TPT2PService.shared.bindDelete()
      }catch {
          // error handling
      }
  }
  ```
---
  ## Prepare reader
  ### Prepare reader
  #### Function
  ```swift
  func configureReader() async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPT2PReader.shared.configureReader()
      }catch {
          // error handling
      }
  }
  ```
---
  ## Transaction
  ### Transaction authorization
  #### Function
  ```swift
  func readCardAndAuthorization(amount: Decimal) async throws -> Transaction?
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          let transactionResult = try await TPT2PReader.shared.readCardAndAuthorization(amount: 100)
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | amount  | Decimal | 交易金額 |
  
  #### Item detail
  ```swift
  struct Transaction: Codable {
    public let receiptId: String
    public let transactionId: String
    public let bankTransactionId: String
    public let orderNumber: String
    public let state: Int
    public let createTime: CLong
    public let amount: Double
    public let currency: String
    public let cardMask : String
    public let authCode: String
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | receiptId  | String | 簽單編號 |
  | transactionId  | String | 交易編號 |
  | bankTransactionId  | String | 銀行交易編號 |
  | orderNumber  | String | 訂單編號（商戶系統帶入）|
  | state  | Int | 交易狀態<br>-1  : ERROR<br>0   : AUTH_SUCCESS<br>1   : SETTLE_SUCCESS<br>3  : CANCEL_SUCCESS |
  | createTime  | CLong | 訂單時間 |
  | amount  | Double | 交易金額 |
  | currency  | String | 幣別 |
  | cardMask  | String | 卡號資訊（屏蔽）|
  | authCode  | String | 授權碼 |

  ### Upload signature
  #### Function
  ```swift
  func createElectronicSignature(receiptIdentifier: String, signCanvas: PKCanvasView) async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPT2PService.shared.createElectronicSignature(receiptIdentifier: "123", signCanvas: PKCanvasView())
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | receiptIdentifier  | String | 簽單編號 |
  | signCanvas  | PKCanvasView | 簽名 |

---
  ## Receipt
  ### Get receipt
  #### Function
  ```swift
  func getReceipt(receiptIdentifier: String, type: Int, email: String?) async throws -> String
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          let receiptUrl = try await TPT2PService.shared.getReceipt(receiptIdentifier: "123456", type: 1, email: "test@test.com")
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | receiptIdentifier  | String | 簽單編號 |
  | type  | Int | 簽單瀏覽格式<br>1 : html<br>2 : pkpass |
  | email  | String | 欲收到簽單的信箱 |
---
