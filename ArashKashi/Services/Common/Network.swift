//
//  Network.swift
//  ArashKashi
//
//  Created by Arash Kashi on 31.01.22.
//

import Foundation
import UIKit
import Combine


/// Responsible for network communication with server. Network class uses routing information to compose the service request.
class Network {
	
	enum _Error: Error {
		case parsing(String)
		case network
		case noConnection
	}
	
	private static var timeout: TimeInterval = 20
	
	/// url session used for communication. it has a timeout interval of 10 seconds, and allows for the cookies to be set.
	/// For security reasons session is configured with ephemeral as it persists NO information of the session including cookies etc.
	static var session: URLSession = {
		
		let config = URLSessionConfiguration.ephemeral
		config.timeoutIntervalForRequest = Network.timeout
		config.httpShouldSetCookies = true
		
		return URLSession(configuration: config)
	}()
	
	
	/// Sends the request to the server. In debug mode it logs the status of communication data
	/// into the console. Logs are disabled in production due to security purposes.
	///
	/// - Parameters:
	///   - route: enum type variable which includes information of request such as http type, body of request, and headers.
	///   - completion: call back in the case of finishing the network communication. The return value of completion is optional.
	///                 the details of the failed operation is not included in the completion parameter.
	static func sendRequest<T: Codable>(urlRequest: URLRequest,
										completion: @escaping (Result<(result: T, httpRes: HTTPURLResponse), _Error>) -> Void) {
#if DEBUG
		NSLog("-----------------------------------------------------------")
		NSLog("Network Request--------------------------------------------")
		NSLog(urlRequest.url?.absoluteString ?? "unknown url")
		if let validBody =  urlRequest.httpBody {
			print((String(data: validBody, encoding: .utf8) ?? "unknown body"))
		}
		NSLog("-----------------------------------------------------------")
#endif
		
		Network.session.dataTask(with: urlRequest, completionHandler: { (data, urlRes, error) in
			
			guard error == nil else {
#if DEBUG
				NSLog(error!.localizedDescription)
#endif
				DispatchQueue.main.async { completion(.failure(.network)) }; return
			}
			
			guard let validURLRes = urlRes as? HTTPURLResponse else {
				DispatchQueue.main.async { completion(.failure(.network)) }
				return
				
			}
			
#if DEBUG
			NSLog("-------------------------------------------------------")
			NSLog("Status Code--------------------------------------------")
			NSLog("\(validURLRes.statusCode)")
			NSLog("-------------------------------------------------------")
#endif
			guard validURLRes.statusCode == 200 else {
				DispatchQueue.main.async { completion(.failure(.network)) }
				return
			}
			
			guard let validData = data else {
				DispatchQueue.main.async { completion(.failure(.network)) }
				return
			}
			
			do {
#if DEBUG
				let jsonObject = try JSONSerialization.jsonObject(with: validData)
				let prettyData = try JSONSerialization.data(withJSONObject: jsonObject,
															options: .prettyPrinted)
				NSLog(String(data: prettyData, encoding: .utf8) ?? "unknown")
#endif
				let decodedInstance = try JSONDecoder().decode(T.self, from: validData)
				DispatchQueue.main.async { completion(.success((decodedInstance, validURLRes))) }
			} catch {
				DispatchQueue.main.async { completion(.failure(.parsing(error.localizedDescription))) }
			}
		}).resume()
	}
}
