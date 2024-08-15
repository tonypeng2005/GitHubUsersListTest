//
//  GitHubUserDetail.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/15.
//

import Foundation

struct GitHubUserDetail: Decodable {
    let login: String
    let name: String?
    let bio: String?
    let blog: String?
    let public_repos: Int
    let followers: Int
    let following: Int
    let avatar_url: String
    let html_url: String
    let location: String?
}
