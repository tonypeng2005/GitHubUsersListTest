//
//  GitHubUserViewModel.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/15.
//

import Foundation
import Combine

class GitHubUsersViewModel: ObservableObject {
    @Published var users: [GitHubUser] = []
    @Published var isLoading = false
    @Published var hasMore = true
    
    private var since = 0
    private let per_page = 20
    private let maxUsers = 100
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers() {
        guard !isLoading, users.count < maxUsers, hasMore else { return }
        
        isLoading = true
        let urlString = "https://api.github.com/users?since=\(since * per_page)&per_page=\(per_page)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GitHubUser].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching users: \(error)")
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] newUsers in
                guard let self = self else { return }
                if newUsers.isEmpty {
                    self.hasMore = false
                } else {
                    let remain = self.maxUsers - self.users.count
                    self.users.append(contentsOf: Array(newUsers.prefix(remain)))
                    self.since += 1
                    if self.users.count >= self.maxUsers {
                        self.hasMore = false
                    }
                }
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
}
