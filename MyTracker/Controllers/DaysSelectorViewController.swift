import UIKit

final class DaysSelectorViewController: UIViewController {

    var chosenDays: Set<Day> = []
    var onDaysSelected: ((Set<Day>) -> Void)?
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let daysTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
    }()

    private let confirmButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Готово", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(named: "YPBlack") ?? .black
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
        view.layer.cornerRadius = 16
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTable()
        setupUI()
        setupConfirmButtonAction()
        daysTableView.isScrollEnabled = false
        daysTableView.backgroundColor = .clear
    }

    private func setupTable() {
        daysTableView.delegate = self
        daysTableView.dataSource = self
        daysTableView.register(DaysSelectorCell.self, forCellReuseIdentifier: DaysSelectorCell.reuseID)
    }

    private func setupUI() {
        view.addSubview(headerLabel)
        view.addSubview(containerView)
        containerView.addSubview(daysTableView)
        view.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            containerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: CGFloat(Day.allCases.count) * 75),

            daysTableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            daysTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            daysTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            daysTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupConfirmButtonAction() {
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    @objc private func confirmTapped() {
        onDaysSelected?(chosenDays)
        dismiss(animated: true)
    }
}

extension DaysSelectorViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Day.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DaysSelectorCell.reuseID,
            for: indexPath
        ) as? DaysSelectorCell else {
            return UITableViewCell()
        }

        let day = Day.allCases[indexPath.row]
        let isLast = indexPath.row == Day.allCases.count - 1
        cell.configure(with: day, isOn: chosenDays.contains(day), hideSeparator: isLast)
        
        cell.onSwitchChanged = { [weak self] isOn in
            guard let self = self else { return }
            if isOn {
                self.chosenDays.insert(day)
            } else {
                self.chosenDays.remove(day)
            }
        }
        
        return cell
    }
}
