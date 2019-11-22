import UIKit
import SVProgressHUD

struct PostViewModel {
  let post: Post
  let user: User
}

class PostsViewController: UIViewController {
 
  private let usersAPI = DI.dependecies.userUseCase
  private let postsAPI = DI.dependecies.postUseCase
  
  private let cellClassName = String(describing: PostCell.self)
  @IBOutlet private var tableView: UITableView!
  private let refresh = UIRefreshControl()
  private let group = DispatchGroup()
  
  private var dataSource: [PostViewModel] = []
  private var users: [User]?
  private var posts: [Post]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Posts"
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(UINib.init(nibName: cellClassName, bundle: nil), forCellReuseIdentifier: cellClassName)
    tableView.refreshControl = refresh
    
    refresh.addTarget(self, action: #selector(reloadPosts), for: .valueChanged)
    
    reloadPosts()
  }
  
  @objc private func reloadPosts() {
    group.enter()
    postsAPI.allPosts { [weak self] result in
      if case .success(let posts) = result {
        self?.posts = posts
      } else {
        self?.posts = nil
      }
      self?.group.leave()
    }
    
    group.enter()
    usersAPI.allUsers { [weak self] result in
      if case .success(let users) = result {
        self?.users = users
      } else {
        self?.users = nil
      }
      self?.group.leave()
    }
    
    SVProgressHUD.show()
    group.notify(queue: DispatchQueue.main) {
      SVProgressHUD.dismiss()
      self.refresh.endRefreshing()
      self.processResponses()
    }
  }
  
  private func processResponses() {
    guard let users = users, let posts = posts else {
      SVProgressHUD.showError(withStatus: "Posts loading failed")
      SVProgressHUD.dismiss(withDelay: Constants.hudDismissDelay)
      return
    }
    
    let vms: [PostViewModel] = posts
      .compactMap { post in
        guard let user = users.first(where: { $0.id == post.userId }) else {
          return nil
        }
        return PostViewModel.init(post: post, user: user)
    }
    dataSource = vms
    tableView.reloadData()
  }
}

extension PostsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellClassName, for: indexPath) as? PostCell else {
      return UITableViewCell()
    }
    
    let viewModel = dataSource[indexPath.row]
    cell.viewModel = viewModel
    
    cell.userAction = { [weak self] in
      SVProgressHUD.show()
      self?.usersAPI.details(userId: viewModel.user.id, completion: { [weak self] result in
        SVProgressHUD.dismiss()
        switch result {
        case .success(let user):
          let controller = SettingsViewController()
          controller.user = user
          self?.navigationController?.pushViewController(controller, animated: true)
        case .failure(let error):
          SVProgressHUD.showError(withStatus: "User loading failed")
          SVProgressHUD.dismiss(withDelay: Constants.hudDismissDelay)
          print(error.localizedDescription)
        }
      })
    }
    
    return cell
  }
}

extension PostsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    let viewModel = dataSource[indexPath.row]
    let controller = PostDetailsViewController()
    controller.viewModel = viewModel
    navigationController?.pushViewController(controller, animated: true)
  }
}
