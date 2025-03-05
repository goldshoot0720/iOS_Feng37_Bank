//
//  ViewController.swift
//  ios37_Feng37_Bank
//
//  Created by 鋒兄三七_二零二五 on 2025/3/4.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let dataSource = [
        "(006)合作金庫(5880)",
        "(013)國泰世華(2882)",
        "(017)兆豐銀行(2886)",
        "(048)王道銀行(2897)",
        "(103)新光銀行(2888)",
        "(396)街口支付(6038)",
        "(700)中華郵政",
        "(808)玉山銀行(2884)",
        "(812)台新銀行(2887)",
        "(822)中國信託(2891)"]
    
    var selectItemIndex = 0
    var bankSavings = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    
    func calcSumSaving() -> Int {
        var sumSaving = 0
        for i in 0..<10 {
            sumSaving += self.bankSavings[i]
            // print(self.bankSavings[i])
        }
        return sumSaving
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(primaryAction: nil)

        let actionClosure = { (action: UIAction) in
            let index = self.findIndexWithForLoop(keyword: action.title)
            // print(action.title,index)
            self.selectItemIndex = index!
            // print(self.selectItemIndex)
            if self.selectItemIndex == index {
                // print(action.title)
                self.textField1.text = String(self.bankSavings[self.selectItemIndex])
            }
            else{
            }
        }

        var menuChildren: [UIMenuElement] = []
        for fruit in dataSource {
            menuChildren.append(UIAction(title: fruit, handler: actionClosure))
        }
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        button.frame = CGRect(x: 150, y: 145, width: 200, height: 50)
        self.view.addSubview(button)
        
        // clearAllBankAccounts(context: context)
        
        let context = self.context
        let allAccounts = fetchBankAccount(context: context)


        for account in allAccounts {
            if let bankInt = Int(account.bankName!)  {
                print("銀行名稱: \(bankInt), 存款: \(account.bankSaving)")
                self.bankSavings[bankInt] = Int(account.bankSaving)
            }
            else{
                
            }
        }
        self.label1.text = String(self.calcSumSaving())
        self.textField1.text = String(self.bankSavings[0])
    }
       
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
        
    @IBOutlet weak var textField1: UITextField!
    
    func findIndexWithForLoop(keyword: String) -> Int? {
        for (index, item) in dataSource.enumerated() {
            if item.contains(keyword) {
                return index
            }
        }
        return nil
    }
    
    @IBAction func Button1_Click(_ sender: Any) {
        if isInteger(textField1.text!){
            // print(self.selectItemIndex);
            self.bankSavings[self.selectItemIndex] = Int(self.textField1.text!)!
            self.label1.text = String(self.calcSumSaving())
            self.textField1.resignFirstResponder()
            self.showToast(message: "已修改")
        }
        else{
            self.label1.text = "請輸入數字";
        }
    }
    
    @IBAction func Button2_Click(_ sender: Any) {
        let bankName: String = String(self.selectItemIndex)
        let bankSaving: Int64 = Int64(self.bankSavings[self.selectItemIndex])
        let context = self.context
        addOrUpdateBankAccount(bankName: bankName, bankSaving: bankSaving, context: context)
        self.showToast(message: "已存檔")
    }
    
    
    @IBAction func Button3_Click(_ sender: Any) {
        let alert = UIAlertController(title: "Feng37_2025", message: "委任第五職等\n簡任第十二職等\n第12屆臺北市長\n第23任總統\n中央銀行鋒兄分行", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func isInteger(_ str: String) -> Bool {
        return Int(str) != nil
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
            let toastLabel = UILabel()
            toastLabel.text = message
            toastLabel.textColor = .white
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            toastLabel.textAlignment = .center
            toastLabel.numberOfLines = 0
            
            // 設定大小與位置
            let padding: CGFloat = 16
            let maxWidth = self.view.frame.width - 2 * padding
            let textSize = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            let labelWidth = min(maxWidth, textSize.width + 20)
            let labelHeight = textSize.height + 10
            
            toastLabel.frame = CGRect(
                x: (self.view.frame.width - labelWidth) / 2,
                y: self.view.frame.height - 120,
                width: labelWidth,
                height: labelHeight
            )
            
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            self.view.addSubview(toastLabel)
            
            // 動畫顯示與消失
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
      
    func fetchBankAccount(bankName: String? = nil, context: NSManagedObjectContext) -> [BankAccount] {
        let fetchRequest: NSFetchRequest<BankAccount> = BankAccount.fetchRequest()
        
        // 如果提供了 bankName，就加上篩選條件
        if let name = bankName {
            fetchRequest.predicate = NSPredicate(format: "bankName == %@", name)
        }
        
        do {
            let accounts = try context.fetch(fetchRequest)
            return accounts
        } catch {
            print("查詢 BankAccount 失敗: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearAllBankAccounts(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BankAccount.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("✅ 已清除所有 BankAccount 資料")
        } catch {
            print("❌ 清除 BankAccount 失敗: \(error.localizedDescription)")
        }
    }
    
    func addOrUpdateBankAccount(bankName: String, bankSaving: Int64, context: NSManagedObjectContext) {
        // 1️⃣ 先查詢是否已存在相同 bankName 的帳戶
        let fetchRequest: NSFetchRequest<BankAccount> = BankAccount.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bankName == %@", bankName)
        fetchRequest.fetchLimit = 1  // 只取第一筆，提高效能

        do {
            if let existingAccount = try context.fetch(fetchRequest).first {
                // 2️⃣ 如果帳戶存在，則更新存款金額
                existingAccount.bankSaving = bankSaving
                print("🔄 更新銀行帳戶 '\(bankName)'，新存款金額: \(bankSaving)")
            } else {
                // 3️⃣ 如果帳戶不存在，才新增
                let newAccount = BankAccount(context: context)
                newAccount.bankName = bankName
                newAccount.bankSaving = bankSaving
                print("✅ 成功新增 BankAccount: \(bankName), 存款: \(bankSaving)")
            }

            // 4️⃣ 確保有變更才執行 save()
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("❌ 操作 BankAccount 失敗: \(error.localizedDescription)")
        }
    }
    
}

