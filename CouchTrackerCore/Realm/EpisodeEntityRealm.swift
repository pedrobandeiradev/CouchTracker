import RealmSwift

final class EpisodeEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingIds: EpisodeIdsRealm?
  @objc dynamic var showIds: ShowIdsRealm?
  @objc dynamic var title: String = ""
  @objc dynamic var overview: String?
  @objc dynamic var number = -1
  @objc dynamic var season = -1
  @objc dynamic var firstAired: Date?

  var ids: EpisodeIdsRealm? {
    get {
      return backingIds
    }
    set {
      backingIds = newValue
      if let traktId = newValue?.trakt {
        let typeName = String(describing: WatchedShowEntity.self)
        identifier = "\(typeName)-\(traktId)"
      }
    }
  }

  override static func primaryKey() -> String? {
    return "identifier"
  }

  override static func ignoredProperties() -> [String] {
    return ["ids"]
  }

  override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? EpisodeEntityRealm else { return false }

    return self == entity
  }

  static func == (lhs: EpisodeEntityRealm, rhs: EpisodeEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.backingIds == rhs.backingIds &&
      lhs.showIds == rhs.showIds &&
      lhs.title == rhs.title &&
      lhs.overview == rhs.overview &&
      lhs.number == rhs.number &&
      lhs.season == rhs.season &&
      lhs.firstAired == rhs.firstAired
  }

  func toEntity() -> EpisodeEntity {
    guard let showIds = self.showIds?.toEntity() else {
      Swift.fatalError("How showIds is not present on EpisodeEntityRealm?!")
    }

    guard let ids = self.ids?.toEntity() else {
      Swift.fatalError("How ids is not present on EpisodeEntityRealm?!")
    }

    return EpisodeEntity(ids: ids,
                         showIds: showIds,
                         title: title,
                         overview: overview,
                         number: number,
                         season: season,
                         firstAired: firstAired)
  }
}

extension EpisodeEntity {
  func toRealm() -> EpisodeEntityRealm {
    let entity = EpisodeEntityRealm()

    entity.ids = ids.toRealm()
    entity.showIds = showIds.toRealm()
    entity.title = title
    entity.overview = overview
    entity.number = number
    entity.season = season
    entity.firstAired = firstAired

    return entity
  }
}
