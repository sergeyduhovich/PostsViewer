import UIKit

class CommentCell: UITableViewCell {
  
  @IBOutlet private var userLabel: UILabel!
  @IBOutlet private var bodyLabel: UILabel!
  
  var comment: Comment? {
    didSet {
      userLabel.text = comment?.email
      bodyLabel.text = comment?.body
    }
  }
}
