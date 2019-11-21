import UIKit

class PostDetailsViewController: UIViewController {
  
  private let postsAPI: PostUseCase = PostUseCaseAPI()
  
  private let cellClassName = String(describing: CommentCell.self)
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var bodyLabel: UILabel!
  private let refresh = UIRefreshControl()
  
  private var dataSource: [Comment] = []
  
  var viewModel: PostViewModel? {
    didSet {
      guard isViewLoaded == true else { return }
      updateView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self
    refresh.addTarget(self, action: #selector(reloadComments), for: .valueChanged)
    tableView.refreshControl = refresh
    
    tableView.register(UINib.init(nibName: cellClassName, bundle: nil), forCellReuseIdentifier: cellClassName)
    
    updateView()
    reloadComments()
  }
  
  @objc private func reloadComments() {
    guard let postId = viewModel?.post.id else {
      return
    }
    self.refresh.beginRefreshing()
    postsAPI.comments(postId: postId) { [weak self] result in
      self?.refresh.endRefreshing()
      switch result {
      case .success(let comments):
        self?.dataSource = comments
        self?.tableView.reloadData()
      case .failure(let error):
        self?.showAlert(message: "Comments loading failed")
        print(error.localizedDescription)
      }
    }
  }
  
  private func updateView() {
    title = viewModel?.user.name
    bodyLabel.text = viewModel?.post.body
  }
}

extension PostDetailsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellClassName, for: indexPath) as? CommentCell else {
      return UITableViewCell()
    }
    
    let comment = dataSource[indexPath.row]
    cell.comment = comment
    return cell
  }
}

extension PostDetailsViewController: UITableViewDelegate {}
