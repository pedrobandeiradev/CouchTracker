import RxSwift
import Trakt

final class MovieDetailsService: MovieDetailsInteractor {

  private let repository: MovieDetailsRepository
  private let genreRepository: GenreRepository
  private let imageRepository: ImageRepository
  private let movieIds: MovieIds

  init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
       imageRepository: ImageRepository, movieIds: MovieIds) {
    self.repository = repository
    self.genreRepository = genreRepository
    self.imageRepository = imageRepository
    self.movieIds = movieIds
  }

  func fetchDetails() -> Observable<MovieEntity> {
    let detailsObservable = repository.fetchDetails(movieId: movieIds.slug)
    let genresObservable = genreRepository.fetchMoviesGenres()

    return Observable.combineLatest(detailsObservable, genresObservable) {
      let movie = $0.0
      let movieGenres = $0.1.filter { genre -> Bool in
        return movie.genres?.contains(genre.slug) ?? false
      }

      return MovieEntityMapper.entity(for: movie, with: movieGenres)
    }
  }

  func fetchImages() -> Observable<ImagesEntity> {
    guard let tmdbId = movieIds.tmdb else { return Observable.empty() }
    return imageRepository.fetchMovieImages(for: tmdbId, posterSize: .w780, backdropSize: .w780)
  }
}
