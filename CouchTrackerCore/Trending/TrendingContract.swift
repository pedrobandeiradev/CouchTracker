import RxSwift
import TraktSwift

public enum TrendingType {
  case movies
  case shows
}

public protocol TrendingPresenter: class {
  var dataSource: TrendingDataSource { get }

  init(view: TrendingViewProtocol, interactor: TrendingInteractor,
       router: TrendingRouter, dataSource: TrendingDataSource, type: TrendingType, schedulers: Schedulers)

  func viewDidLoad()
  func showDetailsOfTrending(at index: Int)
}

public protocol TrendingViewProtocol: BaseView {
  var presenter: TrendingPresenter! { get set }

  func showEmptyView()
  func showTrendingsView()
}

public protocol TrendingRouter: class {
  func showDetails(of movie: MovieEntity)
  func showDetails(of show: ShowEntity)
  func showError(message: String)
}

public protocol TrendingInteractor: class {
  func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovieEntity]>
  func fetchShows(page: Int, limit: Int) -> Single<[TrendingShowEntity]>
}

public protocol TrendingRepository: class {
  func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovie]>
  func fetchShows(page: Int, limit: Int) -> Single<[TrendingShow]>
}

public protocol TrendingDataSource: class {
  var viewModels: [PosterViewModel] { get set }
}
