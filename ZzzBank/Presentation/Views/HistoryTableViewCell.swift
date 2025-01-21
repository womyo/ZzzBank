//
//  TableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 1/18/25.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    static let identifier = "TableView"
    
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.001)
        
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Feb 15"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(dotView)
        contentView.addSubview(lineView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(dateLabel)
        
        dotView.snp.makeConstraints {
            $0.width.height.equalTo(10)
            $0.leading.equalToSuperview().offset(16)
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
            infoLabel.text = "Repay \(repayment.repayTime) hours"
            dateLabel.text = "\(dateFormatter.string(from: repayment.date))"
        }
    }
}
