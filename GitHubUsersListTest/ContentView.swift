//
//  ContentView.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/15.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GitHubUsersViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some View {
        NavigationView {
            if networkMonitor.isConnected {
                List {
                    ForEach(viewModel.users) { user in
                        NavigationLink(destination: GitHubUserDetailView(username: user.login)) {
                            HStack {
                                if let url = URL(string: user.avatar_url) {
                                    CachedAsyncImage(url: url)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }

                                Text(user.login)
                                    .font(.headline)
                            }
                        }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else if viewModel.hasMore {
                        Text("Load more")
                            .onAppear {
                                viewModel.fetchUsers()
                            }
                            .padding()
                    }
                }
                .navigationTitle("GitHub Users")
                .onAppear {
                    viewModel.fetchUsers()
                }
            } else {
                VStack {
                    Image(systemName: "wifi.exclamationmark")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                    Text("No Internet Connection")
                        .font(.title)
                        .padding()
                    Button(action: {
                        if networkMonitor.isConnected {
                            viewModel.fetchUsers()
                        }
                    }) {
                        Text("Retry")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
