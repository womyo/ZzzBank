import UIKit

class ActivityViewCell: UITableViewCell {
    static let identifier = "ActivityViewCell"
    
    private let chatLabel: UILabel = {
        let label = UILabel()
        
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
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = .customBackgroundColor
        
        contentView.addSubview(chatLabel)
        
        chatLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with text: String) {
        chatLabel.text = text
    }
}
