//
//  ShoppingListViewController.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 2.09.22.
//

import UIKit

final class ShoppingListViewController: UIViewController {
    
    var shoppingData: [String] = []
    
    let defaults = UserDefaults.standard
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Shopping item title"
        textField.returnKeyType = UIReturnKeyType.done
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ShoppingCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shoppingData = defaults.object(forKey: "shoppingData") as? [String] ?? [String]()
    }
}

extension ShoppingListViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleTextField)
        view.addSubview(tableView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            //TextField
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            //TableView
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func enterPressed(){
        shoppingData.append(titleTextField.text ?? "")
        defaults.set(shoppingData, forKey: "shoppingData")
        tableView.reloadData()
        titleTextField.text = ""
        titleTextField.resignFirstResponder()
    }
}

extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ShoppingCell else {
            return UITableViewCell()
        }
        cell.label.text = shoppingData[indexPath.row]
        return cell
    }
}

extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingData.remove(at: indexPath.row)
            defaults.set(shoppingData, forKey: "shoppingData")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
