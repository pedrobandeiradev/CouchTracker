public struct ImagesEntity: Hashable {
  public let identifier: Int
  public let backdrops: [ImageEntity]
  public let posters: [ImageEntity]
  public let stills: [ImageEntity]

  public func posterImage() -> ImageEntity? {
    return bestImage(of: posters)
  }

  public func backdropImage() -> ImageEntity? {
    return bestImage(of: backdrops)
  }

  public func stillImage() -> ImageEntity? {
    return bestImage(of: stills)
  }

  private func bestImage(of images: [ImageEntity]) -> ImageEntity? {
    return images.max(by: { (lhs, rhs) -> Bool in
      lhs.isBest(then: rhs)
    })
  }

  public var hashValue: Int {
    var hash = identifier.hashValue
    backdrops.forEach { hash = hash ^ $0.hashValue }
    posters.forEach { hash = hash ^ $0.hashValue }
    stills.forEach { hash = hash ^ $0.hashValue }
    return hash
  }

  public static func == (lhs: ImagesEntity, rhs: ImagesEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  public static func empty() -> ImagesEntity {
    let imageEntities = [ImageEntity]()
    return ImagesEntity(identifier: -1, backdrops: imageEntities, posters: imageEntities, stills: imageEntities)
  }
}
