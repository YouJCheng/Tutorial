//
//  ViewController.swift
//  MVVMPlayground
//
//  Created by YouJCheng on 2021/12/6.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        // Bind
        viewModel.users.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let userModels = try JSONDecoder().decode([User].self, from: data)
                self.viewModel.users.value = userModels.compactMap({
                    UserTableViewCellViewModel(name: $0.name)
                })
            } catch {
                
            }
        }
        task.resume()
    }

}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.value?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.users.value?[indexPath.row].name
        return cell
    }
}
// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
}


struct User: Codable {
    let name: String
}

struct UserListViewModel {
    var users: Observerble<[UserTableViewCellViewModel]> = Observerble([])
    
}

struct UserTableViewCellViewModel{
    let name: String
}
