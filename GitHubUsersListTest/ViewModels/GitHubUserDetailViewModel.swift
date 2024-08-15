//
//  GitHubUserDetailViewModel.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/15.
//

import Foundation
import Combine

// ViewModel to handle user detail fetching
class GitHubUserDetailViewModel: ObservableObject {
    @Published var user: GitHubUserDetail?
    @Published var isLoading = false
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>()

    func fetchUserDetail(username: String) {
        isLoading = true
        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitHubUserDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
                self.isLoading = false
            }, receiveValue: { [weak self] userDetail in
                self?.user = userDetail
            })
            .store(in: &cancellables)
    }
}
