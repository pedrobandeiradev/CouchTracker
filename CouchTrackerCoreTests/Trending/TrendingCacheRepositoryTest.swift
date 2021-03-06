@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class TrendingCacheRepositoryTest: XCTestCase {
  private let scheduler = TestSchedulers()
  private let disposeBag = DisposeBag()
  private var repository: TrendingCacheRepository!
  private var moviesObserver: TestableObserver<[TrendingMovie]>!
  private var showsObserver: TestableObserver<[TrendingShow]>!

  override func setUp() {
    super.setUp()

    moviesObserver = scheduler.createObserver([TrendingMovie].self)
    showsObserver = scheduler.createObserver([TrendingShow].self)
    repository = TrendingCacheRepository(traktProvider: createTraktProviderMock(), schedulers: scheduler)
  }

  func testFetchMoviesEmitMoviesAndComplete() {
    repository.fetchMovies(page: 0, limit: 50).asObservable().subscribe(moviesObserver).disposed(by: disposeBag)

    scheduler.start()

    let expectedMovies = TraktEntitiesMock.createTrendingMoviesMock()
    let expectedEvents: [Recorded<Event<[TrendingMovie]>>] = [Recorded.next(0, expectedMovies), Recorded.completed(0)]

    RXAssertEvents(moviesObserver, expectedEvents)
  }

  func testFetchShowsEmitShowsAndComplete() {
    repository.fetchShows(page: 0, limit: 50).asObservable().subscribe(showsObserver).disposed(by: disposeBag)

    scheduler.start()

    let expectedShows = TraktEntitiesMock.createTrendingShowsMock()
    let expectedEvents: [Recorded<Event<[TrendingShow]>>] = [Recorded.next(0, expectedShows), Recorded.completed(0)]

    RXAssertEvents(showsObserver, expectedEvents)
  }
}
