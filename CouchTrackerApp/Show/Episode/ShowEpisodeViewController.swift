import CouchTrackerCore
import Kingfisher
import RxCocoa
import RxSwift

final class ShowEpisodeViewController: UIViewController {
  private let presenter: ShowEpisodePresenter
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  private var episodeView: ShowEpisodeView {
    guard let episodeView = self.view as? ShowEpisodeView else {
      preconditionFailure("self.view should be of type ShowEpisodeView")
    }
    return episodeView
  }

  init(presenter: ShowEpisodePresenter, schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.schedulers = schedulers
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = ShowEpisodeView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    presenter.observeViewState()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    episodeView.didTouchOnWatch = { [weak self] in
      self?.handleWatch()
    }

    presenter.viewDidLoad()
  }

  private func handleWatch() {
    presenter.handleWatch()
      .observeOn(schedulers.mainScheduler)
      .subscribe { [weak self] error in
        self?.handleSync(error: error)
      }.disposed(by: disposeBag)
  }

  private func handleSync(error: Error) {
    let alert = UIAlertController.createErrorAlert(message: error.localizedDescription)
    present(alert, animated: true, completion: nil)
  }

  private func showEmptyView() {
    print("Nothing to show here!")
  }

  private func showLoadingView() {
    print("Loading view...")
  }

  private func showErrorView(_ error: Error) {
    print("Error view: \(error.localizedDescription)")
  }

  private func updateView(episode: WatchedEpisodeEntity, images: ShowEpisodeImages? = nil) {
    episodeView.previewImageView.kf.setImage(with: images?.previewURL)
    episodeView.posterImageView.kf.setImage(with: images?.posterURL)

    episodeView.titleLabel.text = episode.episode.title
    episodeView.overviewLabel.text = episode.episode.overview ?? "No overview"
    episodeView.releaseDateLabel.text = episode.episode.firstAired?.shortString() ?? "Unknown".localized
    episodeView.watchedAtLabel.text = episode.lastWatched?.shortString() ?? "Unwatched"

    let buttonTitle = episode.lastWatched == nil ?
      R.string.localizable.addToHistory() :
      R.string.localizable.removeFromHistory()

    episodeView.watchButton.setTitle(buttonTitle, for: .normal)
  }

  private func handleViewState(_ viewState: ShowEpisodeViewState) {
    switch viewState {
    case .loading:
      showLoadingView()
    case .empty:
      showEmptyView()
    case let .error(error):
      showErrorView(error)
    case let .showing(episode, images):
      updateView(episode: episode, images: images)
    case let .showingEpisode(episode):
      updateView(episode: episode)
    }
  }
}
