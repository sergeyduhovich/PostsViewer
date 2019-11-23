import SVProgressHUD
import RxSwift
import RxCocoa

extension Reactive where Base: SVProgressHUD {
  static var isShown: Binder<Bool> {
    return Binder(UIApplication.shared) { _, value in
      if value {
        SVProgressHUD.show()
      } else {
        SVProgressHUD.dismiss()
      }
    }
  }
}
