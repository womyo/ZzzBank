//
//  SettingViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 3/21/25.
//

import UIKit
import SwiftUI

class SettingViewController: UIViewController {
    private let viewModel: LoanViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = . customBackgroundColor
        
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.identifier)
        tableView.register(ManualRepaymentTableViewCell.self, forCellReuseIdentifier: ManualRepaymentTableViewCell.identifier)
        tableView.register(StepperTableViewCell.self, forCellReuseIdentifier: StepperTableViewCell.identifier)
        tableView.register(ChatViewCell.self, forCellReuseIdentifier: ChatViewCell.identifier)
        
        return tableView
    }()

    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.identifier, for: indexPath) as? AlertTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ManualRepaymentTableViewCell.identifier, for: indexPath) as? ManualRepaymentTableViewCell else {
                    return UITableViewCell()
                }
            
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StepperTableViewCell.identifier, for: indexPath) as? StepperTableViewCell else {
                    return UITableViewCell()
                }
            
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatViewCell.identifier, for: indexPath) as? ChatViewCell else {
                    return UITableViewCell()
                }
            
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let vc = CustomPickerViewController(viewModel: viewModel)
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [
                    .custom { context in
                        return 300
                    }
                ]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24
            }
            
            present(vc, animated: true)
        }
        
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                let vc = ChatViewController(viewModel: ChatViewModel(api: GeminiAPI()), speechRecognizer: SpeechRecognizer())
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ALERT SETTINGS"
        case 1:
            return "SLEEP SETTINGS"
        case 2:
            return "ACTIVITY SETTINGS"
        default:
            return nil
        }
    }
}
