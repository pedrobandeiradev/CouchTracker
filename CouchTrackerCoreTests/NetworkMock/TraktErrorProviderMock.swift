import TraktSwift
import RxSwift
import Moya
@testable import CouchTrackerCore

final class TraktErrorProviderMock: TraktProvider {
	func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
		return Single.just(AuthenticationResult.undetermined)
	}

	var oauth: URL?

	var movies: MoyaProvider<Movies> = MoyaProviderMock<Movies>(stubClosure: MoyaProvider.immediatelyStub)
	var genres: MoyaProvider<Genres> = MoyaProviderMock<Genres>(stubClosure: MoyaProvider.immediatelyStub)
	var search: MoyaProvider<Search> = MoyaProviderMock<Search>(stubClosure: MoyaProvider.immediatelyStub)
	var shows: MoyaProvider<Shows> = MoyaProviderMock<Shows>(stubClosure: MoyaProvider.immediatelyStub)
	var authentication: MoyaProvider<Authentication> = MoyaProviderMock<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
	var sync: MoyaProvider<Sync> = MoyaProviderMock<Sync>(stubClosure: MoyaProvider.immediatelyStub)
	var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
	var users: MoyaProvider<Users> = MoyaProviderMock<Users>(stubClosure: MoyaProvider.delayedStub(100))

	init(oauthURL: URL? = nil) {
		self.oauth = oauthURL
	}
}