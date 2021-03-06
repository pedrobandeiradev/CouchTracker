import RxSwift
import TraktSwift

public final class AppConfigurationsUserDefaultsDataSource: AppConfigurationsDataSource {
  private static let traktUserKey = "traktUser"
  private static let hideSpecialsKey = "hideSpecials"
  private let userDefaults: UserDefaults
  private let hideSpecialsSubject: BehaviorSubject<Bool>
  private let loginStateSubject: BehaviorSubject<LoginState>

  public init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults

    let hideSpecials = AppConfigurationsUserDefaultsDataSource.currentHideSpecialValue(userDefaults)
    hideSpecialsSubject = BehaviorSubject<Bool>(value: hideSpecials)

    let loginState = AppConfigurationsUserDefaultsDataSource.currentLoginValue(userDefaults)
    loginStateSubject = BehaviorSubject<LoginState>(value: loginState)
  }

  public func save(settings: Settings) throws {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(TraktDateTransformer.dateTimeTransformer.dateFormatter)

    let data = try encoder.encode(settings)
    userDefaults.set(data, forKey: AppConfigurationsUserDefaultsDataSource.traktUserKey)
    loginStateSubject.onNext(LoginState.logged(settings: settings))
  }

  public func fetchLoginState() -> Observable<LoginState> {
    return loginStateSubject.asObservable().distinctUntilChanged()
  }

  public func toggleHideSpecials() throws {
    let hideSpecials = userDefaults.bool(forKey: AppConfigurationsUserDefaultsDataSource.hideSpecialsKey)
    userDefaults.set(!hideSpecials, forKey: AppConfigurationsUserDefaultsDataSource.hideSpecialsKey)
    hideSpecialsSubject.onNext(!hideSpecials)
  }

  public func fetchHideSpecials() -> Observable<Bool> {
    return hideSpecialsSubject.asObservable()
  }

  public static func currentHideSpecialValue(_ userDefaults: UserDefaults) -> Bool {
    return userDefaults.bool(forKey: AppConfigurationsUserDefaultsDataSource.hideSpecialsKey)
  }

  public static func currentLoginValue(_ userDefaults: UserDefaults) -> LoginState {
    guard let jsonData = userDefaults.data(forKey: AppConfigurationsUserDefaultsDataSource.traktUserKey) else {
      return LoginState.notLogged
    }

    guard let settings = try? JSONDecoder().decode(Settings.self, from: jsonData) else { return LoginState.notLogged }

    return LoginState.logged(settings: settings)
  }
}
