//
//  LimitedEmojiProvider.swift
//  ExpensePal
//
//  Created by Gokul P on 16/06/24.
//

import Foundation
import EmojiPicker

final class LimitedEmojiProvider: EmojiProvider {

    func getAll() -> [Emoji] {
        return [
            Emoji(value: "🛒", name: "shopping cart"),
            Emoji(value: "🛍️", name: "shopping bags"),
            Emoji(value: "🏷️", name: "label"),
            Emoji(value: "💳", name: "credit card"),
            Emoji(value: "🧾", name: "receipt"),
            Emoji(value: "💰", name: "money bag"),
            Emoji(value: "💵", name: "dollar banknote"),
            Emoji(value: "💴", name: "yen banknote"),
            Emoji(value: "💶", name: "euro banknote"),
            Emoji(value: "💷", name: "pound banknote"),
            Emoji(value: "🪙", name: "coin"),
            Emoji(value: "🏦", name: "bank"),
            Emoji(value: "👗", name: "dress"),
            Emoji(value: "👠", name: "high-heeled shoe"),
            Emoji(value: "👞", name: "man's shoe"),
            Emoji(value: "👕", name: "t-shirt"),
            Emoji(value: "👖", name: "jeans"),
            Emoji(value: "👙", name: "bikini"),
            Emoji(value: "👛", name: "purse"),
            Emoji(value: "👜", name: "handbag"),
            Emoji(value: "👚", name: "woman’s clothes"),
            Emoji(value: "🎒", name: "backpack"),
            Emoji(value: "👓", name: "glasses"),
            Emoji(value: "🕶️", name: "sunglasses"),
            Emoji(value: "⌚️", name: "watch"),
            Emoji(value: "📱", name: "mobile phone"),
            Emoji(value: "💻", name: "laptop"),
            Emoji(value: "🎧", name: "headphone"),
            Emoji(value: "📺", name: "television"),
            Emoji(value: "📷", name: "camera"),
            Emoji(value: "🔧", name: "wrench"),
            Emoji(value: "🔨", name: "hammer"),
            Emoji(value: "🚗", name: "car"),
            Emoji(value: "🛏️", name: "bed"),
            Emoji(value: "🛋️", name: "couch"),
            Emoji(value: "🏠", name: "house"),
            Emoji(value: "🪑", name: "chair"),
            Emoji(value: "🖼️", name: "framed picture"),
            Emoji(value: "🛁", name: "bathtub"),
            Emoji(value: "🍽️", name: "plate with cutlery"),
            Emoji(value: "🍴", name: "fork and knife"),
            Emoji(value: "🔪", name: "kitchen knife"),
            Emoji(value: "🍾", name: "bottle with popping cork"),
            Emoji(value: "🥂", name: "clinking glasses"),
            Emoji(value: "🍷", name: "wine glass"),
            Emoji(value: "🍺", name: "beer mug"),
            Emoji(value: "🍸", name: "cocktail glass"),
            Emoji(value: "🍫", name: "chocolate bar"),
            Emoji(value: "🍿", name: "popcorn"),
            Emoji(value: "🍪", name: "cookie"),
            Emoji(value: "🍩", name: "doughnut"),
            Emoji(value: "🍔", name: "hamburger"),
            Emoji(value: "🍕", name: "pizza"),
            Emoji(value: "🍣", name: "sushi"),
            Emoji(value: "🍎", name: "apple"),
            Emoji(value: "🍇", name: "grapes"),
            Emoji(value: "🍓", name: "strawberry"),
            Emoji(value: "🥦", name: "broccoli"),
            Emoji(value: "🥕", name: "carrot"),
            Emoji(value: "🍞", name: "bread"),
            Emoji(value: "🧀", name: "cheese"),
            Emoji(value: "🧸", name: "teddy bear"),
            Emoji(value: "🧴", name: "lotion bottle"),
            Emoji(value: "🧼", name: "soap"),
            Emoji(value: "🧻", name: "toilet paper"),
            Emoji(value: "🧹", name: "broom"),
            Emoji(value: "🧽", name: "sponge"),
            Emoji(value: "🧺", name: "basket"),
            Emoji(value: "🛒", name: "shopping cart"),
            Emoji(value: "🛍️", name: "shopping bags")
        ]
    }

}
