import UIKit

final class TrackerCardCell: UICollectionViewCell {
    static let reuseIdentifier = "TrackerCardCell"

    var onToggleTapped: (() -> Void)?

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let daysCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tracker: Tracker, isCompleted: Bool, completedDaysCount: Int) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        daysCounterLabel.text = "\(completedDaysCount) дней"

        let imageName = isCompleted ? "checkmark.circle.fill" : "plus.circle"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        toggleButton.tintColor = isCompleted ? .systemGreen : .systemBlue

        contentView.backgroundColor = UIColor(hex: tracker.color)
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    private func setupUI() {
        contentView.addSubview(emojiLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(daysCounterLabel)
        contentView.addSubview(toggleButton)

        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            daysCounterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            daysCounterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            toggleButton.widthAnchor.constraint(equalToConstant: 34),
            toggleButton.heightAnchor.constraint(equalToConstant: 34)
        ])

        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }

    @objc private func toggleButtonTapped() {
        onToggleTapped?()
    }
}
