//
//  UIViewController+Alert.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/11/25.
//

import UIKit

extension UIViewController {
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "알림이 거부되었습니다.",
            message: "알림을 받으려면 설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}
