//
//  NLLanguage + Ext.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 02.06.2024.
//

import NaturalLanguage

extension NLLanguage: CaseIterable {
    public static var allCases: [NLLanguage] {
        [
            .amharic,
            .arabic,
            .armenian,
            .bengali,
            .bulgarian,
            .burmese,
            .catalan,
            .cherokee,
            .croatian,
            .czech,
            .danish,
            .dutch,
            .english,
            .finnish,
            .french,
            .georgian,
            .german,
            .greek,
            .gujarati,
            .hebrew,
            .hindi,
            .hungarian,
            .icelandic,
            .indonesian,
            .italian,
            .japanese,
            .kannada,
            .khmer,
            .korean,
            .lao,
            .malay,
            .malayalam,
            .marathi,
            .mongolian,
            .norwegian,
            .oriya,
            .persian,
            .polish,
            .portuguese,
            .punjabi,
            .romanian,
            .russian,
            .simplifiedChinese,
            .sinhalese,
            .slovak,
            .spanish,
            .swedish,
            .tamil,
            .telugu,
            .thai,
            .tibetan,
            .traditionalChinese,
            .turkish,
            .ukrainian,
            .urdu,
            .vietnamese,
            .kazakh
        ]
    }
    
    var title: String {
        switch self {
        case .amharic: String(localized: "Амхарский")
        case .arabic: String(localized: "Арабский")
        case .armenian: String(localized: "Армянский")
        case .bengali: String(localized: "Бенгальский")
        case .bulgarian: String(localized: "Болгарский")
        case .burmese: String(localized: "Бирманский")
        case .catalan: String(localized: "Каталонский")
        case .cherokee: String(localized: "Чероки")
        case .croatian: String(localized: "Хорватский")
        case .czech: String(localized: "Чешский")
        case .danish: String(localized: "Датский")
        case .dutch: String(localized: "Голландский")
        case .english: String(localized: "Английский")
        case .finnish: String(localized: "Финский")
        case .french: String(localized: "Французский")
        case .georgian: String(localized: "Грузинский")
        case .german: String(localized: "Немецкий")
        case .greek: String(localized: "Греческий")
        case .gujarati: String(localized: "Гуджарати")
        case .hebrew: String(localized: "Иврит")
        case .hindi: String(localized: "Хинди")
        case .hungarian: String(localized: "Венгерский")
        case .icelandic: String(localized: "Исландский")
        case .indonesian: String(localized: "Индонезийский")
        case .italian: String(localized: "Итальянский")
        case .japanese: String(localized: "Японский")
        case .kannada: String(localized: "Каннада")
        case .khmer: String(localized: "Кхмерский")
        case .korean: String(localized: "Корейский")
        case .lao: String(localized: "Лао")
        case .malay: String(localized: "Малайский")
        case .malayalam: String(localized: "Малаялам")
        case .marathi: String(localized: "Маратхи")
        case .mongolian: String(localized: "Монгольский")
        case .norwegian: String(localized: "Норвежский")
        case .oriya: String(localized: "Ория")
        case .persian: String(localized: "Персидский")
        case .polish: String(localized: "Польский")
        case .portuguese: String(localized: "Португальский")
        case .punjabi: String(localized: "Панджаби")
        case .romanian: String(localized: "Румынский")
        case .russian: String(localized: "Русский")
        case .simplifiedChinese: String(localized: "Китайский (упр.)")
        case .sinhalese: String(localized: "Сингальский")
        case .slovak: String(localized: "Словацкий")
        case .spanish: String(localized: "Испанский")
        case .swedish: String(localized: "Шведский")
        case .tamil: String(localized: "Тамильский")
        case .telugu: String(localized: "Телугу")
        case .thai: String(localized: "Тайский")
        case .tibetan: String(localized: "Тибетский")
        case .traditionalChinese: String(localized: "Китайский (трад.)")
        case .turkish: String(localized: "Турецкий")
        case .ukrainian: String(localized: "Украинский")
        case .urdu: String(localized: "Урду")
        case .vietnamese: String(localized: "Вьетнамский")
        case .kazakh: String(localized: "Казахский")
        default:
            ""
        }
    }
}
