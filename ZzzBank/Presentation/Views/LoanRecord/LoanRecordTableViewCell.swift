//
//  LoanRecordTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 1/10/25.
//

import UIKit
import SnapKit

class LoanRecordTableViewCell: UITableViewCell {
    static let identifier = "LoanRecordTableView"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, loanStatusLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [flagLabel, infoLabel])
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let flagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)

        return label
    }()
    
    private let infoLabel = UILabel()
    private let loanStatusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(infoStackView)
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with record: DateSortable) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM:SS"
        
        if let loan = record as? LoanRecord {
            flagLabel.text = "Borrowed"
            flagLabel.textColor = .systemBlue
            infoLabel.text = "\(loan.loanTime) hours"
            dateLabel.text = "\(dateFormatter.string(from: loan.date))"
            
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let loanDate = calendar.startOfDay(for: loan.repaymentDate)
            let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: today), to: calendar.startOfDay(for: loanDate))
            
            if loan.loanTimeCP == 0 {
                loanStatusLabel.text = "Complete"
            } else {
                if let days = dateComponents.day {
                    if loanDate > today {
                        loanStatusLabel.text = "상환 마감까지 \(days)일"
                    } else if loanDate == today {
                        loanStatusLabel.text = "상환 마감 당일"
                    } else {
                        loanStatusLabel.text = "상환 마감 \(abs(days))일 초과. 연체 이자: \(loan.overdueInterest)"
                    }
                }
            }

        } else if let repayment = record as? RepayRecord {
            flagLabel.text = "Repaid"
            flagLabel.textColor = .systemRed
            infoLabel.text = "\(repayment.repayTime) hours"
            dateLabel.text = "\(dateFormatter.string(from: repayment.date))"
        }
    }
}
