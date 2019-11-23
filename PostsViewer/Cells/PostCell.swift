import UIKit
import RxSwift
import RxCocoa

class PostCell: UITableViewCell {
  
  var userAction: (() -> Void)? = nil
  var disposeBag = DisposeBag()
  
  @IBOutlet fileprivate var userButton: UIButton!
  @IBOutlet private var headerLabel: UILabel!
  @IBOutlet private var bodyLabel: UILabel!

  var viewModel: PostViewModel? {
    didSet {
      userButton.setTitle(viewModel?.user.name, for: .normal)
      headerLabel.text = viewModel?.post.title
      bodyLabel.text = viewModel?.post.body
      
      guard let viewModel = viewModel else {
        return
      }
      
      disposeBag = DisposeBag()
      
      userButton.rx.tap
        .debug("userButton.rx.tap")
        .bind(to: viewModel.inputAction)
        .disposed(by: disposeBag)
    }
  }
  
  @IBAction func userClicked() {
    userAction?()
  }
}

extension Reactive where Base: PostCell {
  var userClicked: ControlEvent<Void> {
    return base.userButton.rx.tap
  }
}
