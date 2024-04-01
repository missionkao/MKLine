import Foundation

public class LineAPI {
    let host = "api.line.me"
    let channelToken: String
    let session = URLSession.shared
    
    public init(channelToken: String) {
        self.channelToken = channelToken
    }
    
    public func pushMessage(message: LinePushMessages) {
        let request = makePushRequest(
            url: makeURL(path: "/v2/bot/message/push"),
            messages: message
        )
        
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(
            with: request,
            completionHandler: { (_, _, error) in
                if let error {
                    print(error.localizedDescription)
                }
                semaphore.signal()
            }
        ).resume()
        semaphore.wait()
    }
    
    private func makeURL(path: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = "https"
        urlComponents.path = path
        return urlComponents.url!
    }
    
    private func makePushRequest(
        url: URL,
        messages: MessagesProtocol
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(channelToken)"
        ]
        request.httpBody = messages.data
        return request
    }
}
