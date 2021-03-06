import TraktSwift

public final class EpisodeEntityMapper {
  private init() {}

  public static func entity(for episode: Episode, showIds: ShowIds) -> EpisodeEntity {
    // CT-TODO Don't handle title here
    return EpisodeEntity(ids: episode.ids,
                         showIds: showIds,
                         title: episode.title ?? "TBA".localized,
                         overview: episode.overview,
                         number: episode.number,
                         season: episode.season,
                         firstAired: episode.firstAired)
  }
}
