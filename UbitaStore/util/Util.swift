import Foundation
import UIKit
import SwiftMessages

func numToSol(num: Double) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "es_PE")
    return formatter.string(from: NSNumber(value: num)) ?? ""
}

func hexStringToUIColor(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray  // Retorna gris si el hex no es válido
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func mensajeAlerta(mensaje: String, theme: Theme) {
    SwiftMessages.show {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(theme)
        view.configureContent(body: mensaje)
        return view
    }}
