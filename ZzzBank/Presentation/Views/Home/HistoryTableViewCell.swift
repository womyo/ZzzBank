//
//  TableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 1/18/25.
//

import UIKit
import Then

class HistoryTableViewCell: UITableViewCell {
    static let identifier = "TableView"
    
    private let dotView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    }
    
    private let infoLabel = UILabel()
    
    private let dateLabel = UILabel().then {
        $0.textColor = .lightGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubviews(dotView, lineView, infoLabel, dateLabel)

        dotView.snp.makeConstraints {
            $0.width.height.equalTo(10)
            $0.leading.equalToSuperview().offset(32)
            $0.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(dotView.snp.bottom)
            $0.width.equalTo(2)
            $0.centerX.equalTo(dotView.snp.centerX)
            $0.height.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dotView.snp.trailing).offset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(4)
            $0.leading.equalTo(infoLabel)
        }
    }
    
    func configure(with record: DateSortable, index: Int, count: Int) {
        lineView.isHidden = (index == count - 1)
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        if let loan = record as? LoanRecord {
            infoLabel.text = "Borrowed \(loan.loanTime) hours"
            dateLabel.text = "\(dateFormatter.string(from: loan.date))"
        } else if let repayment = record as? RepayRecord {
            infoLabel.text = "Repaid \(repayment.repayTime) hours"
            dateLabel.text = "\(dateFormatter.string(from: repayment.date))"
        }
    }
}
