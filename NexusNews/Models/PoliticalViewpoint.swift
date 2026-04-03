import SwiftUI

enum PoliticalViewpoint: String, CaseIterable, Identifiable, Codable {
    case left = "Left"
    case center = "Center"
    case right = "Right"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .left:   return Color(red: 0.18, green: 0.38, blue: 0.88)
        case .center: return Color(red: 0.50, green: 0.18, blue: 0.78)
        case .right:  return Color(red: 0.88, green: 0.18, blue: 0.18)
        }
    }

    var tabIcon: String {
        switch self {
        case .left:   return "arrow.left.circle.fill"
        case .center: return "dot.circle.fill"
        case .right:  return "arrow.right.circle.fill"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .left:
            return LinearGradient(
                colors: [Color(red: 0.14, green: 0.30, blue: 0.85),
                         Color(red: 0.22, green: 0.50, blue: 0.95)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .center:
            return LinearGradient(
                colors: [Color(red: 0.40, green: 0.14, blue: 0.72),
                         Color(red: 0.62, green: 0.24, blue: 0.85)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .right:
            return LinearGradient(
                colors: [Color(red: 0.82, green: 0.14, blue: 0.14),
                         Color(red: 0.95, green: 0.30, blue: 0.20)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var description: String {
        switch self {
        case .left:   return "Progressive & Liberal perspectives"
        case .center: return "Balanced & Nonpartisan reporting"
        case .right:  return "Conservative perspectives"
        }
    }

    var slantLabel: String {
        switch self {
        case .left:   return "Liberal Slant"
        case .center: return "Centrist Coverage"
        case .right:  return "Conservative Slant"
        }
    }
}
