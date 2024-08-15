//
//  GitHubUserDetailView.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/15.
//

import SwiftUI

struct GitHubUserDetailView: View {
    @StateObject private var viewModel = GitHubUserDetailViewModel()
    let username: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                AsyncImage(url: URL(string: user.avatar_url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .padding()
                
                Text(user.login)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                if let name = user.name {
                    Text("Name: \(name)")
                }
                if let bio = user.bio {
                    Text("Bio: \(bio)")
                }
                if let blog = user.blog {
                    Text("Blog: \(blog)")
                }
                Text("Public Repos: \(user.public_repos)")
                Text("Followers: \(user.followers)")
                Text("Following: \(user.following)")
                Link("View on GitHub", destination: URL(string: user.html_url)!)
                    .padding(.top)
                
                Spacer()
            } else if let error = viewModel.error {
                Text("Failed to load user details: \(error.localizedDescription)")
            }
        }
        .navigationTitle("User Detail")
        .padding()
        .onAppear {
            viewModel.fetchUserDetail(username: username)
        }
    }
}

#Preview {
    GitHubUserDetailView(username: "tonypeng2005")
}
