import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

class PostViewModel {
  let post: Post
  let user: User
  
  init(post: Post, user: User) {
    self.post = post
    self.user = user
  }
  
  private(set) var inputAction = PublishRelay<Void>()
  lazy var rx_user: Observable<User> = {
    return self.inputAction
      .compactMap { [weak self] _ -> User? in
        self?.user
    }
  }()
}

class PostsViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private let usersAPI = DI.dependencies.userUseCase
  private let postsAPI = DI.dependencies.postUseCase
  
  private let cellClassName = String(describing: PostCell.self)
  @IBOutlet private var tableView: UITableView!
  private let refresh = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Posts"
    
    tableView.register(UINib(nibName: cellClassName, bundle: nil), forCellReuseIdentifier: cellClassName)
    tableView.refreshControl = refresh
    
    let initialObservale = Observable<Void>.just(())
    let refreshObservable = refresh.rx.controlEvent(.valueChanged)
      .asObservable()
    let viewModels = Observable.merge(initialObservale, refreshObservable)
      .flatMapLatest{ [weak self] _ -> Observable<[PostViewModel]> in
        guard let self = self else { return .empty() }
        return self.rx_reloadPosts()
          .catchError { error in
            print(error)
            SVProgressHUD.showError(withStatus: "Posts loading failed")
            SVProgressHUD.dismiss(withDelay: Constants.hudDismissDelay)
            return .just([])
        }
    }
    .share()

    viewModels
      .map { _ in false }
      .bind(to: refresh.rx.isRefreshing, SVProgressHUD.rx.isShown)
      .disposed(by: disposeBag)
    
    refreshObservable
      .map { _ in true }
      .bind(to: SVProgressHUD.rx.isShown)
      .disposed(by: disposeBag)
    
    viewModels
      .bind(to: tableView.rx.items(cellIdentifier: cellClassName, cellType: PostCell.self)) { index, vm, cell in
        cell.viewModel = vm
        
//        cell.rx
//          .userClicked
//          .flatMapLatest { [weak self] _ -> Observable<User> in
//            guard let self = self else { return .empty() }
//            return self.usersAPI
//              .rx_details(userId: vm.user.id)
//              .catchError { error -> Observable<User> in
//                print(error)
//                return .empty()
//            }
//        }
//        .subscribe(onNext: { [weak self] user in
//          let controller = SettingsViewController()
//          controller.user = user
//          self?.navigationController?.pushViewController(controller, animated: true)
//        })
//          .disposed(by: self.disposeBag)
    }
    .disposed(by: disposeBag)
    
    viewModels.flatMapLatest { vms -> Observable<User> in
      let arrayOfObservables = vms.map { $0.rx_user }
      return Observable.merge(arrayOfObservables)
    }
    .subscribe(onNext: { [weak self] user in
      let controller = SettingsViewController()
      controller.user = user
      self?.navigationController?.pushViewController(controller, animated: true)
    })
      .disposed(by: disposeBag)
    
    tableView.rx
      .modelSelected(PostViewModel.self)
      .subscribe(onNext: { [weak self] viewModel in
        let controller = PostDetailsViewController()
        controller.viewModel = viewModel
        self?.navigationController?.pushViewController(controller, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func rx_reloadPosts() -> Observable<[PostViewModel]> {
    return Observable.combineLatest(
      postsAPI.rx_allPosts(),
      usersAPI.rx_allUsers()
    )
      .map { (posts, users) -> [PostViewModel] in
        let vms: [PostViewModel] = posts
          .compactMap { post in
            guard let user = users.first(where: { $0.id == post.userId }) else {
              return nil
            }
            return PostViewModel.init(post: post, user: user)
        }
        return vms
    }
  }
  
  deinit {
    print("\(#file) \(#function)")
  }
}
