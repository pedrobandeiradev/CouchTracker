import RealmSwift
import TraktSwift

public final class EpisodeIdsRealm: Object {
  @objc public dynamic var trakt = -1
  public let tmdb = RealmOptional<Int>()
  @objc public dynamic var imdb: String?
  public let tvdb = RealmOptional<Int>()
  public let tvrage = RealmOptional<Int>()

  public override static func primaryKey() -> String? {
    return "trakt"
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? EpisodeIdsRealm else { return false }

    return self == entity
  }

  public static func == (lhs: EpisodeIdsRealm, rhs: EpisodeIdsRealm) -> Bool {
    return lhs.trakt == rhs.trakt &&
      lhs.tmdb.value == rhs.tmdb.value &&
      lhs.imdb == rhs.imdb &&
      lhs.tvdb.value == rhs.tvdb.value &&
      lhs.tvrage.value == rhs.tvrage.value
  }

  public func toEntity() -> EpisodeIds {
    return EpisodeIds(trakt: trakt,
                      tmdb: tmdb.value,
                      imdb: imdb,
                      tvdb: tvdb.value,
                      tvrage: tvrage.value)
  }
}

public extension EpisodeIds {
  public func toRealm() -> EpisodeIdsRealm {
    let entity = EpisodeIdsRealm()

    entity.trakt = trakt
    entity.tmdb.value = tmdb
    entity.imdb = imdb
    entity.tvdb.value = tvdb
    entity.tvrage.value = tvrage

    return entity
  }
}
