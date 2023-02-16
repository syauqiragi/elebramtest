//
//  PerksDataModel.swift
//  LifeStyle
//
//  Created by Ahmad Syauqi Albana on 21/09/22.
//

import Foundation

struct PerksDataModel: Codable {
    var applicationId: String?
    var createdAt: String?
    var deletedAt: String?
    var description: String?
    var id: String?
    var isActive: Bool?
    var merchantBanner: String?
    var merchantId: String?
    var merchantLogo: String?
    var merchantName: String?
    var perkUrl: String?
    var quota: Int?
    var title: String?
    var uiSections: [UISectionModel]?
    var updatedAt: String?
    var button: ButtonConfig?
    var location: Bool?

    private enum CodingKeys: String, CodingKey {
        case applicationId = "application_id"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case description = "description"
        case id = "id"
        case isActive = "is_active"
        case merchantBanner = "merchant_banner"
        case merchantId = "merchant_id"
        case merchantLogo = "merchant_logo"
        case merchantName = "merchant_name"
        case perkUrl = "perk_url"
        case quota = "quota"
        case title = "title"
        case uiSections = "ui_sections"
        case updatedAt = "updated_at"
        case button = "button"
        case location = "location_permission"
    }
    
    struct ButtonConfig: Codable {

        let type: String?
        let text: String?
        let isActive: Bool?

        private enum CodingKeys: String, CodingKey {
            case type = "type"
            case text = "text"
            case isActive = "is_active"
        }

    }
}
