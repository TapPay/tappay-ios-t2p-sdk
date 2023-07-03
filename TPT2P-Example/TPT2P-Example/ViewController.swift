//
//  ViewController.swift
//  TPT2P-Example
//
//

import UIKit
import TPSDKT2P
import TPT2PModel

class ViewController: UIViewController {
    
    @IBOutlet weak var inititialWithKeyBtn: UIButton!
    @IBOutlet weak var getBindingListBtn: UIButton!
    @IBOutlet weak var bindingListTableView: UITableView!
    @IBOutlet weak var bindBtn: UIButton!
    @IBOutlet weak var initialReaderBtn: UIButton!
    @IBOutlet weak var readCardBtn: UIButton!
    @IBOutlet weak var bindDeleteBtn: UIButton!
    @IBOutlet weak var authorizationResultLabel: UILabel!
    @IBOutlet weak var getReceiptBtn: UIButton!
    @IBOutlet weak var receiptUrlTextfield: UITextField!
    
    var selectedRow: Int?
    var bindList: [BindItem]?
    var transactionResult: Transaction?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setAllElementsHidden()
    }
    
    func setAllElementsHidden() {
        getBindingListBtn.isHidden = true
        bindingListTableView.isHidden = true
        bindBtn.isHidden = true
        initialReaderBtn.isHidden = true
        readCardBtn.isHidden = true
        bindDeleteBtn.isHidden = true
        authorizationResultLabel.isHidden = true
        getReceiptBtn.isHidden = true
        receiptUrlTextfield.isHidden = true
    }

    @IBAction func initialWithKey(_ sender: Any) {
        Task {
            do {
                try await TPT2PManager.setupWithAppKey("", .sandbox)
                print("Initial success")
                if TPT2PReader.isReaderBinded == true {
                    DispatchQueue.main.async {
                        self.initialReaderBtn.isHidden = false
                        self.bindDeleteBtn.isHidden = false
                    }
                }else {
                    DispatchQueue.main.async {
                        self.getBindingListBtn.isHidden = false
                    }
                }
            }catch {
                print(error)
            }
        }
    }
    
    @IBAction func getBindingList(_ sender: Any) {
        if TPT2PReader.isReaderBinded == false {
            Task {
                do {
                    let result = try await TPT2PService.shared().getBindingList(page: 0, countPerPage: 10)
                    bindList = result
                    bindingListTableView.reloadData()
                    DispatchQueue.main.async {
                        self.bindingListTableView.isHidden = false
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func bind(_ sender: Any) {
        if let selectedRow {
            let item = bindList![selectedRow]
            Task {
                do {
                    try await TPT2PService.shared().bind(bindItem: item, description: "123")
                    print("Bind success")
                    DispatchQueue.main.async {
                        self.bindDeleteBtn.isHidden = false
                        self.initialReaderBtn.isHidden = false
                        self.getBindingListBtn.isHidden = true
                        self.bindingListTableView.isHidden = true
                        self.bindBtn.isHidden = true
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func initialReader(_ sender: Any) {
        if TPT2PReader.isReaderBinded == true {
            Task {
                do {
                    try await TPT2PReader.shared().configureReader()
                    print("Ready")
                    DispatchQueue.main.async {
                        self.readCardBtn.isHidden = false
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func readCard(_ sender: Any) {
        if TPT2PReader.isReaderBinded == true {
            Task {
                do {
                    let result = try await TPT2PReader.shared().readCardAndAuthorization(for: 10)
                    transactionResult = result
                    DispatchQueue.main.async {
                        self.authorizationResultLabel.isHidden = false
                        self.getReceiptBtn.isHidden = false
                        self.authorizationResultLabel.text = result?.transactionId
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func getReceipt(_ sender: Any) {
        if let transactionResult {
            Task {
                do {
                    let receiptUrl = try await TPT2PService.shared().getReceipt(receiptIdentifier: transactionResult.receiptId, type: 1, email: nil)
                    DispatchQueue.main.async {
                        self.receiptUrlTextfield.isHidden = false
                        self.receiptUrlTextfield.text = receiptUrl
                    }
                }catch {
                    
                }
            }
        }
    }
    
    @IBAction func bindDelete(_ sender: Any) {
        if TPT2PReader.isReaderBinded == true {
            Task {
                do {
                    try await TPT2PService.shared().bindDelete()
                    print("Bind Delete Success")
                    DispatchQueue.main.async {
                        self.setAllElementsHidden()
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if bindList?.count ?? 0 > indexPath.row {
            let bindItem = bindList![indexPath.row]
            cell.textLabel?.text = bindItem.terminalId
        }
        if indexPath.row == selectedRow {
            cell.contentView.backgroundColor = .blue.withAlphaComponent(0.5)
        }else {
            cell.contentView.backgroundColor = .white
        }
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        bindingListTableView.reloadData()
        DispatchQueue.main.async {
            self.bindBtn.isHidden = false
        }
    }
    
}