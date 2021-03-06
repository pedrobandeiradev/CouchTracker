import CouchTrackerCore
import RxSwift

final class AppConfigurationsViewController: UITableViewController {
  private static let defaultCellIdentifier = "DefaultAppConfigCell"
  private let disposeBag = DisposeBag()
  private let presenter: AppConfigurationsPresenter
  private let schedulers: Schedulers
  private var configurationSections = [AppConfigurationsViewModel]()

  init(presenter: AppConfigurationsPresenter, schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.schedulers = schedulers

    super.init(style: .plain)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = R.string.localizable.settings()

    view.backgroundColor = Colors.View.background
    tableView.separatorColor = Colors.View.background

    presenter.observeViewState()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleViewState(_ state: AppConfigurationsViewState) {
    switch state {
    case .loading:
      print("Loading...")
    case let .showing(configs):
      showConfigurations(models: configs)
    }
  }

  private func showConfigurations(models: [AppConfigurationsViewModel]) {
    configurationSections.removeAll()
    configurationSections.append(contentsOf: models)
    tableView.reloadData()
  }

  override func numberOfSections(in _: UITableView) -> Int {
    return configurationSections.count
  }

  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section < configurationSections.count else { return 0 }
    let section = configurationSections[section]
    return section.configurations.count
  }

  override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section < configurationSections.count else { return nil }
    return configurationSections[section].title
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = AppConfigurationsViewController.defaultCellIdentifier

    let appConfigCell: UITableViewCell

    if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
      appConfigCell = cell
    } else {
      appConfigCell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
      appConfigCell.backgroundColor = Colors.View.background
      appConfigCell.textLabel?.textColor = Colors.Text.primaryTextColor
      appConfigCell.detailTextLabel?.textColor = Colors.Text.secondaryTextColor
    }

    let section = configurationSections[indexPath.section]
    let configuration = section.configurations[indexPath.row]

    appConfigCell.textLabel?.text = configuration.title
    appConfigCell.detailTextLabel?.text = configuration.subtitle

    switch configuration.value {
    case .none:
      appConfigCell.accessoryType = .none
    case let .hideSpecials(wantsToHideSpecials):
      appConfigCell.accessoryType = wantsToHideSpecials ? .checkmark : .none
    case let .traktLogin(wantsToLogin):
      appConfigCell.accessoryType = wantsToLogin ? .none : .checkmark
    case .externalURL:
      appConfigCell.accessoryType = .disclosureIndicator
    }

    return appConfigCell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let selectedConfigurationSection = configurationSections[indexPath.section]
    let selectedConfiguration = selectedConfigurationSection.configurations[indexPath.row]

    presenter.select(configuration: selectedConfiguration)
  }
}
