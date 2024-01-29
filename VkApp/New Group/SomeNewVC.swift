//
//  SomeNewVC.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 27.09.2023.
//
//верстка кодом
import UIKit

final class SomeNewVC: UIViewController {
    private lazy var someLableFirst: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello"
        label.textColor = .green
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        
        return label
    }()
    // lazy значиь ее неь еще не памяьи она ьудеь когда ьудеь применяиься
    private lazy var someLableSecond: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "World"
        label.textColor = .green
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        
        return label
    }()
    
    private lazy var someTable: UITableView = {
        let table = UITableView(
            frame: .zero,
            style:.insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .brown
        table.separatorColor = .green
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
    }
    
    //MARK: - Private methods
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeConstraints()
    }
    
    
    private func addSubviews() {
        // здесь иерархии, элементы должны быть полседовательно
        view.addSubview(someTable)
        view.addSubview(someLableFirst)
        view.addSubview(someLableSecond )
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
//            [NSLayoutConstraint]
            someTable.topAnchor.constraint(equalTo: view.topAnchor),
            someTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            someTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            someTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            someLableFirst.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            someLableFirst.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            someLableFirst.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.75),
            
            someLableSecond.centerXAnchor.constraint(equalTo: someLableFirst.centerXAnchor),
            someLableSecond.topAnchor.constraint(equalTo: someLableFirst.bottomAnchor,
                                                 constant: 16),
            someLableSecond.widthAnchor.constraint(equalTo: someLableFirst.widthAnchor),
            
        ])
    }
}

extension SomeNewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
        print(indexPath)
    }
}

extension SomeNewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}
