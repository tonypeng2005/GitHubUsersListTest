//
//  GitHubUser.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/15.
//

import Foundation

struct GitHubUser: Identifiable, Decodable {
    let id: Int
    let login: String
    let avatar_url: String
}
