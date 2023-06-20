# tappay-ios-t2p-sdk

### The TapPay iOS SDK helps you build Tap to Pay on iPhone into your iOS app

---
## SDK initialize
![](./Images/SDK_Initialize.png) <br><br>
## Start to use SDK
![](./Images/T2P_SDK_Flow.svg)
---

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
---
  ## Prepare reader
  ### Prepare reader
  #### Function
  ```swift
  func prepareReader() async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPReader.shared.prepareReader()
      }catch {
          // error handling
      }
  }
  ```
---

---
  ## Transaction
  ### Transaction authorization
  #### Function
  ```swift
  func transactionAuthorization(amount: Decimal) async throws -> TransactionDetail?
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          let transactionResult = try await TPReader.shared.transactionAuthorization(amount: 100)
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
  struct TransactionDetail: Codable {
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
  func uploadSignature(signatureImage: UIImage, receiptId: String) async throws
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          try await TPReader.shared.uploadSignature(signatureImage: UIImage, receiptId: "123")
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | signatureImage  | UIImage | 簽名圖檔 |
  | receiptId  | String | 簽單編號 |
---

---
  ## Receipt
  ### Get receipt
  #### Function
  ```swift
  func getReceipt(receiptId: String, type: Int, email: String?) async throws -> String
  ```
  #### Sample
  ```swift
  // Sample code
  Task {
      do {
          let receiptUrl = try await TPReader.shared.getReceipt(receiptId: "123456", type: 1, email: "test@test.com")
      }catch {
          // error handling
      }
  }
  ```
  #### Parameters
  |  Parameter   | Type  |  Description   | 
  |  :----  | :----  | :---- |
  | receiptId  | String | 簽單編號 |
  | type  | Int | 簽單瀏覽格式<br>1 : html<br>2 : pkpass |
  | email  | String | 用於SDK的驗證金鑰(取得方式待補) |
---
