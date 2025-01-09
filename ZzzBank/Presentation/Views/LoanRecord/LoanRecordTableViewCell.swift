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
        
        loanTime.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        date.snp.makeConstraints {
            $0.leading.equalTo(loanTime.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with loanRecord: LoanRecord) {
        loanTime.text = String(loanRecord.loanTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 형식 지정
        let dateString = dateFormatter.string(from: loanRecord.date)
        date.text = dateString
    }

}
