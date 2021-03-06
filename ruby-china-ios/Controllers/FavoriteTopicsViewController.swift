//
//  FavoriteTopicsViewController.swift
//  ruby-china-ios
//
//  Created by 柯磊 on 16/11/2.
//  Copyright © 2016年 ruby-china. All rights reserved.
//

import UIKit

class FavoriteTopicsViewController: TopicsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "favorites".localized
        tableView.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteChangedAction), name: NSNotification.Name(NOTICE_FAVORITE_CHANGED), object: nil)
    }
    
    override func loadTopics(offset: Int, limit: Int, callback: @escaping (APICallbackResponse, [Topic]?) -> ()) {
        let userLogin = OAuth2.shared.currentUser!.login
        UsersService.favorites(userLogin: userLogin, offset: offset, limit: limit, callback: callback)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let topic = topicList?.remove(at: indexPath.row), editingStyle == .delete {
            TopicsService.unfavorite(topic.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func favoriteChangedAction() {
        var limit = topicList == nil ? defaultLimit : topicList!.count
        limit = max(defaultLimit, limit)
        load(offset: 0, limit: limit)
    }
}
