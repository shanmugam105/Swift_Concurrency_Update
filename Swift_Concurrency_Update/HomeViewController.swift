//
//  HomeViewController.swift
//  Swift_Concurrency_Update
//
//  Created by Mac on 08/08/22.
//

import UIKit

class HomeViewModel {
    var users: [User] = []
    
    func getUserList(completion: @escaping (Error?) -> Void) {
        let userListApi = Route.baseURL + Route.user.description
        NetworkService.makeRequest(url: userListApi, type: [User].self) {[self] result in
            switch result {
            case .success(let value):
                users = value
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}


class HomeViewController: UITableViewController {
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserList { error in
            if let error = error {
                // Some error
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.users[indexPath.row].name
        return cell
    }
}

struct User: Codable {
    let name: String
}
