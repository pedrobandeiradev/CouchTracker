import RxSwift
import TraktSwift

public final class SearchService: SearchInteractor {
  private let trakt: TraktProvider
  private let schedulers: Schedulers

  public init(traktProvider: TraktProvider, schedulers: Schedulers = DefaultSchedulers.instance) {
    trakt = traktProvider
    self.schedulers = schedulers
  }

  public func search(query: String, types: [SearchType], page: Int, limit: Int) -> Single<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query, page: page, limit: limit)

    return trakt.search.rx.request(target)
      .observeOn(schedulers.networkScheduler)
      .map([SearchResult].self)
  }
}
