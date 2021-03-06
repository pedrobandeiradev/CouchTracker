import CouchTrackerCore
import TraktSwift

public final class MovieDetailsModule {
  private init() {}

  public static func setupModule(movieIds: MovieIds) -> BaseView {
    let trakt = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers
    let appConfigObservable = Environment.instance.appConfigurationsObservable
    let genreRepository = Environment.instance.genreRepository

    let repository = MovieDetailsAPIRepository(traktProvider: trakt, schedulers: schedulers)

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRespository = ImageCachedRepository(tmdb: tmdb,
                                                 tvdb: tvdb,
                                                 cofigurationRepository: configurationRepository,
                                                 schedulers: schedulers)

    let interactor = MovieDetailsService(repository: repository, genreRepository: genreRepository,
                                         imageRepository: imageRespository, movieIds: movieIds)

    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigObservable)

    return MovieDetailsViewController(presenter: presenter)
  }
}
