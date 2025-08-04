import UIKit

final class DaysSelectorCell: UITableViewCell {
    static let reuseID = "DaysSelectorCell"

    private let dayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "YPBlack") ?? .label
        return label
    }()

    let daySwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = UIColor(named: "YPBlue")
        toggle.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return toggle
    }()

    private let bottomSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "YPGray") ?? .lightGray
        return view
    }()
    
    var onSwitchChanged: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(dayNameLabel)
        contentView.addSubview(daySwitch)
        contentView.addSubview(bottomSeparator)

        NSLayoutConstraint.activate([
            dayNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with day: Day, isOn: Bool, hideSeparator: Bool) {
        dayNameLabel.text = day.rawValue
        daySwitch.isOn = isOn
        bottomSeparator.isHidden = hideSeparator
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
}
