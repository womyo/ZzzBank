//
//  LoanRecordTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 1/10/25.
//

import UIKit
import SnapKit
import Then

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
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .gray
    }
    
    private let flagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let infoLabel = UILabel()
    private let loanStatusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        flagLabel.text = nil
        infoLabel.text = nil
        loanStatusLabel.text = nil
    }
    
    private func configureUI() {
        contentView.addSubviews(stackView, infoStackView)
        
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
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let loan = record as? LoanRecord {
            flagLabel.text = "Borrowed"
            flagLabel.textColor = .mainColor
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
                        loanStatusLabel.text = "\(days) days until due"
                    } else if loanDate == today {
                        loanStatusLabel.text = "Due today"
                    } else {
                        loanStatusLabel.text = "Overdue by \(abs(days)) days. Interest: \(loan.overdueInterest)h"
                    }
                }
            }

        } else if let repayment = record as? RepayRecord {
            flagLabel.text = "Repaid"
            flagLabel.textColor = .oppositeColor
            infoLabel.text = "\(repayment.repayTime) hours"
            dateLabel.text = "\(dateFormatter.string(from: repayment.date))"
            
            switch repayment.repayTime {
            case 1, 2:
                loanStatusLabel.text = "Light rest"
            case 3, 4:
                loanStatusLabel.text = "Energy restored"
            case 5, 6:
                loanStatusLabel.text = "Fully recharged"
            case 7...:
                loanStatusLabel.text = "Deep recovery"
            default:
                loanStatusLabel.text = ""
            }
        }
    }
}
