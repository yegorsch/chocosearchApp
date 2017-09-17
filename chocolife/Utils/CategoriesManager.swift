//
//  CategoriesManager.swift
//  chocolife
//
//  Created by Егор on 9/11/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation

struct Categories {
  static let entertainment = Category(name: "Entertainment", subcategories: ["#stadium", "#aquarium", "#bowling_alley", "#campground", "#night_club"])
  static let beauty = Category(name: "Health", subcategories: ["#beauty_salon", "#dentist", "#hospital", "#doctor", "#spa", "#hair_care", "#physiotherapist"])
  static let sport = Category(name: "Sport", subcategories: ["#bicycle_store", "#shoe_store", "#stadium", "#gym"])
  static let goods = Category(name: "Goods", subcategories: ["#jewelry_store", "#book_store", "#clothing_store", "#florist"])
  static let services = Category(name: "Services", subcategories: ["#accounting", "#laundry", "#bank", "#car_wash"])
  static let food = Category(name: "Food", subcategories: ["#bakery", "#liquor_store", "#bar", "#meal_delivery", "#cafe", "#restaurant"])
  static let tourism = Category(name: "Tourism", subcategories: ["#art_gallery", "#library", "#campground", "#night_club"])
  static let all = [Categories.entertainment, Categories.beauty, Categories.sport, Categories.goods, Categories.services, Categories.food, Categories.tourism]
}

struct Category {
  var name: String
  var subcategories: [String]

  init(name: String, subcategories: [String]) {
    self.name = name
    self.subcategories = subcategories
  }
}

enum CategoryTypes {
  case category
  case subcategory
}

class CategoriesManager {

  static let shared = CategoriesManager()

  private init() { }

  func subcategories(for category: String) -> [String]? {
    for item in Categories.all {
      if item.name == category {
        return item.subcategories
      }
    }
    return nil
  }


}
