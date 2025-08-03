import UIKit

final class HabitEditorViewController: UIViewController {

    var didCreateNewTracker: ((Tracker) -> Void)?
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let habitNameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Введите название трекера"
        field.backgroundColor = UIColor(named: "Background")
        field.tintColor = UIColor(named: "ypGray")
        field.layer.cornerRadius = 16
        field.font = UIFont.systemFont(ofSize: 17)
        field.clearButtonMode = .whileEditing
        field.setLeftPaddingPoints(16)
        field.returnKeyType = .done
        return field
    }()

    private let optionsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
        view.layer.cornerRadius = 16
        return view
    }()

    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let categoryDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "ypGray")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let categoryStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()

    private let categoryChevron: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(named: "ypGray")
        return imageView
    }()

    private let categoryTapButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        return btn
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "ypGray")
        return view
    }()

    private let scheduleStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()

    private let scheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.textColor = UIColor(named: "ypBlack")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let scheduleDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "ypGray")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let scheduleChevron: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray2
        return imageView
    }()

    private let scheduleTapButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        return btn
    }()

    private let actionButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()

    private let cancelBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Отменить", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "ypRed")?.cgColor
        btn.layer.cornerRadius = 16
        return btn
    }()

    private let confirmBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Создать", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(named: "ypGray")
        btn.layer.cornerRadius = 16
        btn.isEnabled = false
        return btn
    }()

    private var daysSelected: Set<Day> = []
    private var trackerCategory: TrackerCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        applyConstraints()
        configureActions()
        setupFormValidation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(habitNameField)
        scrollView.addSubview(optionsContainer)
        scrollView.addSubview(actionButtonsStack)

        actionButtonsStack.addArrangedSubview(cancelBtn)
        actionButtonsStack.addArrangedSubview(confirmBtn)

        optionsContainer.addSubview(categoryChevron)
        optionsContainer.addSubview(categoryTapButton)

        categoryStack.addArrangedSubview(categoryTitleLabel)
        categoryStack.addArrangedSubview(categoryDetailLabel)

        optionsContainer.addSubview(categoryStack)
        optionsContainer.addSubview(dividerView)

        scheduleStack.addArrangedSubview(scheduleTitleLabel)
        scheduleStack.addArrangedSubview(scheduleDetailLabel)

        optionsContainer.addSubview(scheduleStack)
        optionsContainer.addSubview(scheduleChevron)
        optionsContainer.addSubview(scheduleTapButton)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            habitNameField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            habitNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habitNameField.heightAnchor.constraint(equalToConstant: 75),

            optionsContainer.topAnchor.constraint(equalTo: habitNameField.bottomAnchor, constant: 24),
            optionsContainer.leadingAnchor.constraint(equalTo: habitNameField.leadingAnchor),
            optionsContainer.trailingAnchor.constraint(equalTo: habitNameField.trailingAnchor),
            optionsContainer.heightAnchor.constraint(equalToConstant: 150),

            categoryStack.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 16),
            categoryStack.centerYAnchor.constraint(equalTo: categoryTapButton.centerYAnchor),

            categoryChevron.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -16),
            categoryChevron.centerYAnchor.constraint(equalTo: categoryTapButton.centerYAnchor),

            categoryTapButton.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor),
            categoryTapButton.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor),
            categoryTapButton.topAnchor.constraint(equalTo: optionsContainer.topAnchor),
            categoryTapButton.heightAnchor.constraint(equalToConstant: 75),

            dividerView.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -16),
            dividerView.topAnchor.constraint(equalTo: categoryTapButton.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),

            scheduleStack.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 16),
            scheduleStack.centerYAnchor.constraint(equalTo: scheduleTapButton.centerYAnchor),

            scheduleChevron.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -16),
            scheduleChevron.centerYAnchor.constraint(equalTo: scheduleTapButton.centerYAnchor),

            scheduleTapButton.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor),
            scheduleTapButton.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor),
            scheduleTapButton.bottomAnchor.constraint(equalTo: optionsContainer.bottomAnchor),
            scheduleTapButton.heightAnchor.constraint(equalToConstant: 75),

            actionButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButtonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionButtonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func configureActions() {
        cancelBtn.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        scheduleTapButton.addTarget(self, action: #selector(openScheduleSelector), for: .touchUpInside)
        categoryTapButton.addTarget(self, action: #selector(openCategorySelection), for: .touchUpInside)
        
        habitNameField.addTarget(self, action: #selector(habitNameDidChange), for: .editingChanged)
        confirmBtn.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
    }

    private func setupFormValidation() {
        updateConfirmButtonState()
    }

    private func updateConfirmButtonState() {
        let isNameValid = !(habitNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isScheduleValid = !daysSelected.isEmpty
        let isCategoryValid = trackerCategory != nil
        
        confirmBtn.isEnabled = isNameValid && isScheduleValid && isCategoryValid
        confirmBtn.backgroundColor = confirmBtn.isEnabled ? UIColor(named: "ypBlack") : UIColor(named: "ypGray")
    }

    @objc private func cancelPressed() {
        dismiss(animated: true)
    }

    @objc private func openScheduleSelector() {
        let scheduleVC = DaysSelectorViewController()
        scheduleVC.chosenDays = daysSelected
        scheduleVC.onDaysSelected = { [weak self] selected in
            self?.daysSelected = selected
            
            let allDays = Set(Day.allCases)
            let text: String
            
            if selected == allDays {
                text = "Каждый день"
            } else {
                text = selected
                    .sorted { $0.order < $1.order }
                    .map { $0.shortName }
                    .joined(separator: ", ")
            }
            
            self?.scheduleDetailLabel.text = text
            self?.updateConfirmButtonState()
        }
        present(scheduleVC, animated: true)
    }

    @objc private func openCategorySelection() {
    }
    
    @objc private func habitNameDidChange() {
        refreshConfirmButtonState()
    }
    
    private func refreshConfirmButtonState() {
        let isNameEmpty = habitNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let hasDays = !daysSelected.isEmpty
        confirmBtn.isEnabled = !isNameEmpty && hasDays
        confirmBtn.backgroundColor = confirmBtn.isEnabled ? UIColor(named: "ypBlack") : UIColor(named: "ypGray")
    }
    
    @objc private func confirmButtonPressed() {
        guard
            let trimmedName = habitNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !trimmedName.isEmpty,
            !daysSelected.isEmpty
        else {
            return
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: trimmedName,
            color: "ColorSection15",
            emoji: "🐱",
            schedule: daysSelected.map { $0.rawValue }
        )
        
        didCreateNewTracker?(newTracker)
        dismiss(animated: true)
    }
    
    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardFrame.height + 20,
            right: 0
        )
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

private extension UITextField {
    func setLeftPaddingPoints(_ points: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: points, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}
