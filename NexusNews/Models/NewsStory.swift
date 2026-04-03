import Foundation
import SwiftUI

struct NewsStory: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let summary: String
    let content: String
    let source: String
    let sourceURL: String
    let publishedAt: Date
    let viewpoint: PoliticalViewpoint
    /// 0.0 = no detectable lean, 1.0 = extremely skewed
    let biasScore: Double
    let biasKeywords: [String]
    let biasExplanation: String
    let imageURL: String?
    let category: String

    // MARK: - Computed helpers

    var biasLabel: String {
        switch biasScore {
        case 0.0 ..< 0.20: return "Minimal Lean"
        case 0.20 ..< 0.40: return "Slight Lean"
        case 0.40 ..< 0.60: return "Moderate Lean"
        case 0.60 ..< 0.80: return "Strong Lean"
        default:            return "Extreme Lean"
        }
    }

    var biasColor: Color {
        switch biasScore {
        case 0.0  ..< 0.25: return Color(red: 0.20, green: 0.72, blue: 0.30)
        case 0.25 ..< 0.50: return Color(red: 0.82, green: 0.70, blue: 0.00)
        case 0.50 ..< 0.75: return Color(red: 0.95, green: 0.50, blue: 0.05)
        default:            return Color(red: 0.90, green: 0.18, blue: 0.18)
        }
    }

    var biasPercentage: Int { Int(biasScore * 100) }

    var formattedDate: String {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .abbreviated
        return f.localizedString(for: publishedAt, relativeTo: Date())
    }

    var categoryIcon: String {
        switch category.lowercased() {
        case "politics":              return "building.columns.fill"
        case "economy", "finance":    return "chart.line.uptrend.xyaxis"
        case "environment", "climate":return "leaf.fill"
        case "health", "healthcare":  return "heart.fill"
        case "education":             return "book.fill"
        case "immigration":           return "figure.walk"
        case "energy":                return "bolt.fill"
        case "crime", "law":          return "shield.fill"
        case "international":         return "globe"
        default:                      return "newspaper.fill"
        }
    }
}
