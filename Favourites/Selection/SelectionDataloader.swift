//
//  SelectionDataloader.swift
//  Favourites
//
//  Created by Arun Balakrishnan on 26/07/18.
//  Copyright © 2018 Arun Balakrishnan. All rights reserved.
//

import UIKit

class SelectionDataLoader {
    var articles = [Article]()
    var selectedCounter = 0
    
    func loadArticles(endpoint:String = Endpoints.articles.rawValue, completion:@escaping ([Article]?)->Void){
        if let theURL = URL(string: endpoint){
            URLSession.shared.dataTask(with: theURL) {[weak self] (data, response, error) in
                if let theData = data, let json = try? JSONSerialization.jsonObject(with: theData, options: .allowFragments), let theJSON = json as? [String:Any]{
                    self?.articles = Article.articles(from: theJSON)
                    DispatchQueue.main.async {
                        completion( self?.articles)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        }else {
            completion(nil)
        }
    }
    
   
    func setArticleSelection(index:Int, isLiked:ArticleState){
        var theArticle = articles[index]
        theArticle.setLiked(isLiked)
        if isLiked == .liked {
            self.selectedCounter += 1
            self.articles.remove(at: index)
            self.articles.insert(theArticle, at: index)
        }
        
    }
    
    func loadImage(for index:Int, completion:@escaping (UIImage?)-> Void){
        if index > self.articles.count - 1{
            completion(getDefaultImage())
            
        } else {
        var article = self.articles[index]
        if let uri = article.cachedImageURL {
            let theURL = URL(fileURLWithPath: uri)
            if let data = try? Data(contentsOf: theURL){
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        } else {
                if let uri = article.imageURLstring, let url = URL(string: uri){
                    URLSession.shared.downloadTask(with: url) { (url, response, error) in
                        if let theURL = url,let data = try? Data(contentsOf: theURL), let image = UIImage(data: data) {
                            article.setCacheURL(theURL.path)
                            self.articles.remove(at: index)
                            self.articles.insert(article, at: index)
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        }
                    }.resume()
            } else {
                completion(nil)
            }
        }
        }
    }
    func getDefaultImage()-> UIImage? {
        return UIImage(named: "default")
    }
    
    deinit {
        print("Deallocation SelectionDataLoader")
    }
}

struct Article {
    var imageURLstring :String? = nil
    var cachedImageURL:String? = nil
    var title:String = ""
    var isLiked:ArticleState = .none
   fileprivate mutating func setLiked(_ isLiked:ArticleState){
        self.isLiked = isLiked
    }
    fileprivate mutating func setCacheURL(_ uri:String){
        self.cachedImageURL = uri
    }

    init?(json:[String:Any]){
        self.title = json[ArticleKeys.title.rawValue] as? String ?? "" 
        if let media = json[ArticleKeys.media.rawValue] as? [[String:Any]], let uri = media.first?[ArticleKeys.uri.rawValue] as? String{
            self.imageURLstring = uri
        }
    }
}

enum ArticleState {
    case liked
    case disLiked
    case none
}
extension Article {
    static func articles(from json:[String:Any])->[Article]{
        var articles = [Article]()
        // parse JSON
        if let embeddedValues = json[ArticleKeys._embedded.rawValue] as? [String:Any], let theArticles = embeddedValues[ArticleKeys.articles.rawValue] as? [[String:Any]]{
            for theArticle in theArticles {
                if let article = Article(json: theArticle){
                    articles.append(article)
                }
            }
        }
        return articles
    }
}

enum ArticleKeys :String{
    case _embedded
    case articles
    case title
    case media
    case uri
}
