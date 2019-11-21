import UIKit

class PostCell: UITableViewCell {
  
  var userAction: (() -> Void)? = nil
  
  @IBOutlet private var userButton: UIButton!
  @IBOutlet private var headerLabel: UILabel!
  @IBOutlet private var bodyLabel: UILabel!

  var viewModel: PostViewModel? {
    didSet {
      userButton.setTitle(viewModel?.user.name, for: .normal)
      headerLabel.text = viewModel?.post.title
      bodyLabel.text = viewModel?.post.body
    }
  }
  
  @IBAction func userClicked() {
    userAction?()
  }
}
