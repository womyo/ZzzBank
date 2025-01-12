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
    
    private let loanTime = UILabel()
    private let date = UILabel()
    private let loanStatusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(loanTime)
        contentView.addSubview(date)
        contentView.addSubview(loanStatusLabel)
        
        loanTime.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        date.snp.makeConstraints {
            $0.leading.equalTo(loanTime.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        loanStatusLabel.snp.makeConstraints {
            $0.leading.equalTo(date.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with loanRecord: LoanRecord) {
        loanTime.text = "대출 시간: \(loanRecord.loanTime)"
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let loanDate = calendar.startOfDay(for: loanRecord.date)
        let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: today), to: calendar.startOfDay(for: loanDate))
        
        if let days = dateComponents.day {
            if loanDate > today {
                loanStatusLabel.text = "상환 마감까지 \(days)일"
            } else if loanDate == today {
                loanStatusLabel.text = "상환 마감 당일"
            } else {
                loanStatusLabel.text = "상환 마감 \(abs(days))일 초과!"
            }
            
            if loanDate < today {
                date.text = "연체 이자: \(loanRecord.overdueInterest)"
            }
        }
    }

}
