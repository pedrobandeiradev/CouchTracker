import CouchTrackerCore
import Kingfisher
import RxSwift

public final class ShowOverviewViewController: UIViewController {
  private let presenter: ShowOverviewPresenter
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  private var showView: ShowOverviewView {
    guard let showView = self.view as? ShowOverviewView else {
      preconditionFailure("self.view should be of type ShowOverviewView")
    }
    return showView
  }

  public init(presenter: ShowOverviewPresenter, schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.schedulers = schedulers
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    view = ShowOverviewView()
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    adjustForNavigationBar()
    showView.backgroundColor = Colors.View.background

    presenter.observeImagesState()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] imageState in
        self?.handleImageState(imageState)
      }).disposed(by: disposeBag)

    presenter.observeViewState()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleImageState(_ imageState: ShowOverviewImagesState) {
    switch imageState {
    case .empty: break
    case .loading: break
    case let .showing(images):
      show(images: images)
    case let .error(error):
      print(error.localizedDescription)
    }
  }

  private func handleViewState(_ viewState: ShowOverviewViewState) {
    switch viewState {
    case .loading: return
    case let .showing(show):
      self.show(details: show)
    case let .error(error):
      print(error.localizedDescription)
    }
  }

  func show(details: ShowEntity) {
    let firstAired = details.firstAired?.parse() ?? "Unknown".localized

    let genres = details.genres.map { $0.name }.joined(separator: " | ")

    showView.titleLabel.text = details.title ?? R.string.localizable.tbA()
    showView.statusLabel.text = details.status?.rawValue.localized ?? R.string.localizable.unknown()
    showView.networkLabel.text = details.network ?? R.string.localizable.unknown()
    showView.overviewLabel.text = details.overview
    showView.genresLabel.text = genres
    showView.releaseDateLabel.text = firstAired
  }

  func show(images: ImagesViewModel) {
    if let posterLink = images.posterLink {
      showView.posterImageView.kf.setImage(with: posterLink.toURL, placeholder: R.image.posterPlacehoder())
    }

    if let backdropLink = images.backdropLink {
      showView.backdropImageView.kf.setImage(with: backdropLink.toURL, placeholder: R.image.backdropPlaceholder())
    }
  }
}
