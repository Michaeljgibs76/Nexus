import Foundation

// MARK: - NewsService

final class NewsService {

    /// Simulates an async network fetch. Replace the body with real API calls
    /// (e.g. NewsAPI.org) when you have a key.
    func fetchStories() async throws -> [NewsStory] {
        // Simulate realistic network latency
        try await Task.sleep(nanoseconds: 700_000_000)
        return Self.mockStories
    }
}

// MARK: - Bias Analysis Engine

extension NewsService {

    /// Returns a (score 0–1, flagged keywords, explanation) tuple for any article.
    static func analyzeBias(
        title: String,
        content: String,
        source: String,
        viewpoint: PoliticalViewpoint
    ) -> (score: Double, keywords: [String], explanation: String) {

        let text = (title + " " + content).lowercased()
        var found: [String] = []

        // Emotionally charged / partisan vocabulary
        let chargedWords = [
            "crisis", "disaster", "catastrophe", "radical", "extreme",
            "dangerous", "threat", "attack", "destroy", "expose",
            "corrupt", "regime", "propaganda", "lies", "fraud",
            "unprecedented", "alarming", "outrage", "shameful", "shocking",
            "devastate", "refuse", "slam", "blasted", "ripped",
            "squash", "banned", "assault", "surge", "explode"
        ]
        for w in chargedWords where text.contains(w) { found.append(w) }

        let languageScore = min(Double(found.count) * 0.09, 0.55)
        let sourceScore   = sourceBaselineScore(source)
        let rawScore      = (languageScore * 0.45 + sourceScore * 0.55)
        let finalScore    = min(rawScore, 1.0)

        let explanation = buildExplanation(
            score: finalScore,
            keywords: found,
            source: source,
            viewpoint: viewpoint
        )
        return (finalScore, found, explanation)
    }

    private static func sourceBaselineScore(_ source: String) -> Double {
        // Lean scores based on widely-cited media-bias research
        let table: [String: Double] = [
            // Left-leaning
            "Mother Jones":       0.85,
            "MSNBC":              0.78,
            "HuffPost":           0.72,
            "The Nation":         0.80,
            "Vox":                0.62,
            "The Guardian":       0.48,
            "The New York Times": 0.40,
            "NPR":                0.32,
            // Center
            "AP News":            0.10,
            "Reuters":            0.10,
            "BBC":                0.18,
            "The Hill":           0.22,
            "Bloomberg":          0.24,
            "Politico":           0.28,
            "USA Today":          0.25,
            "The Economist":      0.26,
            // Right-leaning
            "Wall Street Journal":0.40,
            "New York Post":      0.60,
            "Newsmax":            0.74,
            "Fox News":           0.78,
            "The Daily Wire":     0.82,
            "The Blaze":          0.80,
            "Breitbart":          0.92,
        ]
        return table[source] ?? 0.35
    }

    private static func buildExplanation(
        score: Double,
        keywords: [String],
        source: String,
        viewpoint: PoliticalViewpoint
    ) -> String {
        var parts: [String] = []
        parts.append("'\(source)' carries a baseline \(viewpoint.slantLabel.lowercased()) rating in independent media-bias research.")
        if !keywords.isEmpty {
            let list = keywords.prefix(3).joined(separator: ", ")
            parts.append("Emotionally charged language detected: \(list).")
        }
        switch score {
        case 0..<0.20:
            parts.append("Overall language is measured and largely neutral.")
        case 0.20..<0.40:
            parts.append("Minor framing choices suggest a slight \(viewpoint.rawValue.lowercased()) lean.")
        case 0.40..<0.60:
            parts.append("Noticeable framing, word choice, and source selection reflect a moderate \(viewpoint.rawValue.lowercased()) perspective.")
        case 0.60..<0.80:
            parts.append("Strong editorial slant is evident through recurring partisan framing and selective emphasis.")
        default:
            parts.append("Heavy one-sided language, selective facts, and emotionally charged rhetoric indicate extreme bias.")
        }
        return parts.joined(separator: " ")
    }
}

// MARK: - Mock Data

extension NewsService {

    static let mockStories: [NewsStory] = leftStories + centerStories + rightStories

    // MARK: Left

    private static var leftStories: [NewsStory] {
        let now = Date()
        return [
            NewsStory(
                title: "Scientists Sound Alarm as Record Temperatures Devastate Coastal Communities",
                summary: "A new IPCC report warns that without radical government intervention, sea-level rise will displace millions within a generation, yet GOP lawmakers continue blocking climate legislation.",
                content: """
                Climate scientists released a landmark report Monday warning that the window to prevent \
                catastrophic warming is rapidly closing. The report, compiled by over 800 researchers, \
                found that extreme weather events have intensified 40% over the past decade. \
                Progressive lawmakers called for emergency climate spending, while Republican \
                legislators dismissed the findings as alarmist. Activists gathered outside the \
                Capitol demanding a Green New Deal, arguing that the fossil-fuel industry's \
                lobbying has corrupted the legislative process.
                """,
                source: "MSNBC",
                sourceURL: "https://msnbc.com",
                publishedAt: now.addingTimeInterval(-2 * 3600),
                viewpoint: .left,
                biasScore: 0.76,
                biasKeywords: ["radical", "catastrophic", "corrupted", "devastating", "alarm"],
                biasExplanation: "'MSNBC' carries a baseline liberal slant rating in independent media-bias research. Emotionally charged language detected: radical, catastrophic, corrupted. Strong editorial slant is evident through recurring partisan framing and selective emphasis.",
                imageURL: nil,
                category: "Climate"
            ),
            NewsStory(
                title: "Activists Demand Medicare for All as Insurance Industry Profits Soar to Record Highs",
                summary: "Health advocates are pressing Congress to pass universal healthcare after insurers posted a combined $80 billion in annual profit while millions remain uninsured.",
                content: """
                Progressive healthcare advocates descended on Washington this week demanding \
                an end to what they call the 'predatory' insurance system. Industry giants \
                reported record earnings as medical bankruptcies climbed to a ten-year high. \
                Grassroots organizations argue that the current system is a moral catastrophe \
                that disproportionately harms working-class Americans and communities of color. \
                Centrist Democrats have resisted broader reform, drawing sharp criticism from \
                the party's progressive wing.
                """,
                source: "HuffPost",
                sourceURL: "https://huffpost.com",
                publishedAt: now.addingTimeInterval(-4 * 3600),
                viewpoint: .left,
                biasScore: 0.72,
                biasKeywords: ["predatory", "catastrophe", "disproportionately", "harms"],
                biasExplanation: "'HuffPost' carries a baseline liberal slant rating in independent media-bias research. Emotionally charged language detected: predatory, catastrophe, disproportionately. Strong editorial slant evident through framing.",
                imageURL: nil,
                category: "Healthcare"
            ),
            NewsStory(
                title: "New Voter ID Laws Condemned as Thinly Veiled Voter Suppression by Civil Rights Groups",
                summary: "A wave of Republican-led voter ID legislation is drawing fierce opposition from voting rights organizations who argue the bills deliberately target minority voters.",
                content: """
                Civil rights groups filed federal lawsuits in six states Thursday, arguing that \
                newly enacted voter ID requirements amount to a modern poll tax designed to \
                suppress turnout among Black, Latino, and low-income voters. Legal analysts \
                supporting the plaintiffs say the laws lack evidentiary basis for the fraud \
                they purport to prevent. Republicans counter that the measures protect \
                election integrity, a claim activists say is a pretext for disenfranchisement.
                """,
                source: "The Guardian",
                sourceURL: "https://theguardian.com",
                publishedAt: now.addingTimeInterval(-6 * 3600),
                viewpoint: .left,
                biasScore: 0.62,
                biasKeywords: ["suppression", "disenfranchisement", "pretext", "targeted"],
                biasExplanation: "'The Guardian' carries a baseline liberal slant rating. Language such as 'suppress' and 'disenfranchisement' reflects a clear progressive framing. Moderate-to-strong lean detected.",
                imageURL: nil,
                category: "Politics"
            ),
            NewsStory(
                title: "Amazon Workers Win Landmark Union Vote After Years of Grassroots Organizing",
                summary: "Warehouse workers in three states voted to unionize in a historic decision that labor advocates call a turning point for workers' rights in the gig economy.",
                content: """
                In what labor organizers are calling a watershed moment, Amazon warehouse \
                workers voted to certify union representation at facilities in New York, \
                Illinois, and Georgia. Workers cited grueling productivity quotas, high injury \
                rates, and stagnating wages despite the company's record profits. The wins \
                come after Amazon spent millions on an anti-union campaign that critics called \
                coercive and deceptive.
                """,
                source: "The New York Times",
                sourceURL: "https://nytimes.com",
                publishedAt: now.addingTimeInterval(-8 * 3600),
                viewpoint: .left,
                biasScore: 0.48,
                biasKeywords: ["coercive", "deceptive", "grueling"],
                biasExplanation: "'The New York Times' has a moderate liberal baseline. Framing strongly favors worker perspectives while describing company tactics as coercive. Moderate lean overall.",
                imageURL: nil,
                category: "Economy"
            ),
            NewsStory(
                title: "Study: Racial Disparities in Policing Persist Across Every Major U.S. City",
                summary: "A comprehensive Stanford analysis of 100 million traffic stops finds Black and Latino drivers are stopped at significantly higher rates than white drivers.",
                content: """
                Researchers at Stanford's Open Policing Project released updated findings \
                showing that racial disparities in traffic enforcement persist even after \
                controlling for socioeconomic factors. The study found Black drivers are \
                20% more likely to be stopped and twice as likely to be searched despite \
                lower rates of contraband discovery. Advocates argue the data exposes \
                systemic racism embedded in law enforcement culture, while police unions \
                dispute the methodology.
                """,
                source: "Vox",
                sourceURL: "https://vox.com",
                publishedAt: now.addingTimeInterval(-10 * 3600),
                viewpoint: .left,
                biasScore: 0.65,
                biasKeywords: ["systemic racism", "embedded", "exposes"],
                biasExplanation: "'Vox' carries a moderate-to-strong liberal slant. Framing centers advocacy language around systemic racism and embeds progressive analysis throughout the piece.",
                imageURL: nil,
                category: "Crime"
            ),
            NewsStory(
                title: "Book Bans Surge 200% as Right-Wing Groups Target School Libraries Nationwide",
                summary: "The American Library Association reports a record 1,247 challenges to library books last year, with conservative parent groups driving the vast majority of removals.",
                content: """
                Librarians and educators are sounding the alarm about an unprecedented wave \
                of book bans sweeping the country, with organized conservative campaigns \
                successfully removing titles covering race, LGBTQ+ identity, and history \
                from school shelves. Critics call the movement a dangerous assault on \
                intellectual freedom that robs students of diverse perspectives. \
                Supporters say they are protecting children from age-inappropriate content.
                """,
                source: "Mother Jones",
                sourceURL: "https://motherjones.com",
                publishedAt: now.addingTimeInterval(-12 * 3600),
                viewpoint: .left,
                biasScore: 0.83,
                biasKeywords: ["sounding the alarm", "unprecedented", "dangerous assault", "sweeping"],
                biasExplanation: "'Mother Jones' carries a strong liberal baseline. Heavily charged framing — 'sounding the alarm,' 'dangerous assault' — and exclusively progressive sourcing indicate extreme lean.",
                imageURL: nil,
                category: "Education"
            ),
        ]
    }

    // MARK: Center

    private static var centerStories: [NewsStory] {
        let now = Date()
        return [
            NewsStory(
                title: "Federal Reserve Holds Interest Rates Steady as Inflation Eases to Three-Year Low",
                summary: "The Fed left its benchmark rate unchanged at 5.25%–5.50% after fresh data showed CPI falling to 2.9%, the lowest reading since early 2021.",
                content: """
                Federal Reserve officials voted unanimously to hold the federal funds rate \
                steady at its current range, citing encouraging progress toward the central \
                bank's 2% inflation target while cautioning that the labor market remains \
                tighter than ideal. Chair Jerome Powell indicated that rate cuts remain on \
                the table for later in the year if data continues to improve, though he \
                stressed the Fed will not pre-commit to a specific timeline.
                """,
                source: "Reuters",
                sourceURL: "https://reuters.com",
                publishedAt: now.addingTimeInterval(-1 * 3600),
                viewpoint: .center,
                biasScore: 0.09,
                biasKeywords: [],
                biasExplanation: "'Reuters' carries a minimal baseline lean score. Language is factual, sourced from official statements, and presents no detectable editorial framing. Minimal lean detected.",
                imageURL: nil,
                category: "Economy"
            ),
            NewsStory(
                title: "NATO Defense Ministers Agree on Expanded Spending Commitments Through 2030",
                summary: "Alliance members endorsed a new long-term defense investment plan at a Brussels summit, with 23 of 32 nations now meeting the 2% GDP spending target.",
                content: """
                Defense ministers from NATO's 32 member states concluded two days of \
                meetings in Brussels by endorsing a framework that commits members to \
                sustained defense spending increases through the end of the decade. \
                Secretary General Jens Stoltenberg called the agreement a 'historic' \
                step. Russia condemned the expansion as provocative, while China urged \
                restraint. U.S. officials expressed satisfaction while pressing European \
                allies to close the remaining gap.
                """,
                source: "AP News",
                sourceURL: "https://apnews.com",
                publishedAt: now.addingTimeInterval(-3 * 3600),
                viewpoint: .center,
                biasScore: 0.11,
                biasKeywords: [],
                biasExplanation: "'AP News' ranks among the lowest-bias sources in media research. Report draws on official statements from multiple sides with no overt editorial framing.",
                imageURL: nil,
                category: "International"
            ),
            NewsStory(
                title: "Senate Committee Advances AI Accountability Bill with Bipartisan Support",
                summary: "Senators from both parties backed a bill requiring transparency reports and third-party audits for large AI systems deployed in healthcare, finance, and hiring.",
                content: """
                The Senate Commerce Committee advanced the Algorithmic Accountability Act \
                in a 14-9 vote, with six Republicans joining all Democrats on the panel. \
                The bill would require companies deploying AI in high-stakes domains to \
                conduct and publish bias audits. Tech industry groups expressed concern \
                about compliance costs, while consumer advocates praised the measure as \
                a first step toward meaningful oversight of automated decision-making.
                """,
                source: "The Hill",
                sourceURL: "https://thehill.com",
                publishedAt: now.addingTimeInterval(-5 * 3600),
                viewpoint: .center,
                biasScore: 0.20,
                biasKeywords: [],
                biasExplanation: "'The Hill' sits in the center-to-slight-left zone. This piece presents both industry and consumer perspectives with balanced sourcing. Minimal lean.",
                imageURL: nil,
                category: "Politics"
            ),
            NewsStory(
                title: "U.S. Budget Deficit Widens to $1.7 Trillion as Congress Misses Spending Deadline",
                summary: "Treasury data shows the federal deficit grew 8% year-over-year as continuing resolutions keep the government funded without a full appropriations deal.",
                content: """
                The Congressional Budget Office projects the federal deficit will widen to \
                $1.7 trillion this fiscal year, driven by rising interest payments on the \
                national debt and mandatory spending growth. Lawmakers from both parties \
                have traded blame for the impasse on the twelve annual spending bills, \
                with fiscal hawks in the House demanding deeper cuts and Senate Democrats \
                insisting on maintained program funding. A government shutdown remains a \
                possibility if negotiators cannot bridge the gap before the next deadline.
                """,
                source: "Politico",
                sourceURL: "https://politico.com",
                publishedAt: now.addingTimeInterval(-7 * 3600),
                viewpoint: .center,
                biasScore: 0.24,
                biasKeywords: [],
                biasExplanation: "'Politico' leans slight center-left but maintains straight reporting here. Both party positions are represented without editorial commentary.",
                imageURL: nil,
                category: "Politics"
            ),
            NewsStory(
                title: "U.S. Unemployment Falls to 3.7% as Job Growth Beats Forecasts",
                summary: "The Labor Department reported 272,000 new jobs in the latest month, with gains concentrated in healthcare, construction, and leisure sectors.",
                content: """
                Payroll growth exceeded economist forecasts for the fourth consecutive month \
                as the U.S. economy added 272,000 jobs, the Labor Department reported Friday. \
                The unemployment rate edged down to 3.7%. Wage growth remained at 4.1% \
                year-over-year, above the Fed's preferred pace. Analysts noted the data \
                complicates the central bank's path to interest rate cuts, as robust labor \
                demand keeps upward pressure on prices.
                """,
                source: "Bloomberg",
                sourceURL: "https://bloomberg.com",
                publishedAt: now.addingTimeInterval(-9 * 3600),
                viewpoint: .center,
                biasScore: 0.12,
                biasKeywords: [],
                biasExplanation: "'Bloomberg' maintains a centrist business-news baseline. Economic data is reported factually with multi-source analyst commentary.",
                imageURL: nil,
                category: "Economy"
            ),
            NewsStory(
                title: "U.S.-China Diplomatic Talks Resume Amid Ongoing Tensions Over Trade and Taiwan",
                summary: "Senior diplomats from Washington and Beijing met for two days in Geneva, producing a joint statement on re-establishing military communication channels.",
                content: """
                American and Chinese officials concluded a second round of diplomatic \
                talks in Geneva with a limited joint communiqué committing both sides \
                to restore direct military-to-military communications. Trade and technology \
                disputes remain unresolved, and Taiwan continues to be the most sensitive \
                flashpoint. Analysts described the outcome as modest but meaningful given \
                the depth of recent tensions. Both governments indicated further discussions \
                are planned for later in the quarter.
                """,
                source: "BBC",
                sourceURL: "https://bbc.com",
                publishedAt: now.addingTimeInterval(-11 * 3600),
                viewpoint: .center,
                biasScore: 0.14,
                biasKeywords: [],
                biasExplanation: "'BBC' maintains a low-bias rating internationally. The report presents both U.S. and Chinese perspectives without taking a side.",
                imageURL: nil,
                category: "International"
            ),
        ]
    }

    // MARK: Right

    private static var rightStories: [NewsStory] {
        let now = Date()
        return [
            NewsStory(
                title: "Border Crossings Surge to Record High as White House Refuses to Secure Southern Border",
                summary: "New DHS data reveals over 250,000 migrant encounters in a single month, yet the administration continues to resist Republican calls for emergency enforcement measures.",
                content: """
                Monthly border encounter data obtained exclusively by Fox News shows \
                illegal crossings hit an all-time record as the Biden administration \
                maintains what critics call an open-borders policy. Republican governors \
                have deployed National Guard troops to fill the security vacuum. Democrats \
                insist the surge is rooted in root-cause humanitarian conditions and \
                have blocked GOP legislation that would restore Trump-era enforcement \
                mechanisms. Border Patrol sources say morale has 'completely collapsed.'
                """,
                source: "Fox News",
                sourceURL: "https://foxnews.com",
                publishedAt: now.addingTimeInterval(-2 * 3600),
                viewpoint: .right,
                biasScore: 0.80,
                biasKeywords: ["surge", "refuses", "collapsed", "security vacuum", "open-borders"],
                biasExplanation: "'Fox News' carries a strong conservative baseline in media-bias research. Framing exclusively through enforcement lens, use of 'open-borders' and 'security vacuum' indicate extreme conservative slant.",
                imageURL: nil,
                category: "Immigration"
            ),
            NewsStory(
                title: "Republican Tax Reform Package Would Return Over $2,000 to Average American Family",
                summary: "House Republicans unveiled a sweeping tax relief bill that slashes the corporate rate to 18% and doubles the standard deduction, delivering immediate savings to working families.",
                content: """
                House Ways and Means Republicans unveiled a comprehensive tax relief \
                package Tuesday that proponents say would boost take-home pay for \
                middle-income families by an average of $2,100 annually. The plan \
                lowers the corporate tax rate, expands the child tax credit, and \
                eliminates the estate tax on family-owned businesses. Critics argue \
                the cuts disproportionately benefit the wealthy, while supporters \
                contend that reducing the tax burden unleashes the private-sector \
                investment that drives job creation.
                """,
                source: "Wall Street Journal",
                sourceURL: "https://wsj.com",
                publishedAt: now.addingTimeInterval(-4 * 3600),
                viewpoint: .right,
                biasScore: 0.48,
                biasKeywords: ["relief", "unleashes"],
                biasExplanation: "'Wall Street Journal' has a slight-right baseline. Framing emphasizes benefits to average families and uses supply-side economic language. Moderate lean.",
                imageURL: nil,
                category: "Economy"
            ),
            NewsStory(
                title: "Parents Revolt Against Radical Gender Curriculum Pushed in Elementary Schools",
                summary: "School board meetings across 30 states have turned contentious as parents demand the removal of gender-identity materials they say are inappropriate for young children.",
                content: """
                A nationwide parents' rights movement is gaining momentum as thousands \
                of families demand their school districts remove gender ideology curricula \
                from K-5 classrooms. The Daily Wire reviewed lesson plans from a dozen \
                districts showing content that critics say is developmentally inappropriate \
                for children as young as five. State legislatures in Florida, Georgia, \
                and Tennessee have responded with parental rights legislation, which \
                opponents call discriminatory.
                """,
                source: "The Daily Wire",
                sourceURL: "https://dailywire.com",
                publishedAt: now.addingTimeInterval(-6 * 3600),
                viewpoint: .right,
                biasScore: 0.84,
                biasKeywords: ["radical", "revolt", "ideology", "inappropriate", "pushed"],
                biasExplanation: "'The Daily Wire' carries a strong conservative baseline. Terms like 'radical,' 'revolt,' and 'gender ideology' are partisan framing devices. Strong-to-extreme conservative lean.",
                imageURL: nil,
                category: "Education"
            ),
            NewsStory(
                title: "Green Energy Mandates Drive Up Electricity Bills, Devastating Rural American Families",
                summary: "A Heritage Foundation study finds families in states with aggressive renewable-energy mandates pay 40% more for electricity than those in fossil-fuel-friendly states.",
                content: """
                Families in California, New York, and Illinois are paying 40% more \
                for electricity than residents in energy-abundant states like Texas \
                and Wyoming, according to a new Heritage Foundation analysis. The report \
                blames aggressive renewable energy mandates that force utilities to \
                retire reliable baseload generation before adequate replacements are \
                online. Rural residents on fixed incomes say the higher bills represent \
                a crushing burden. The Biden administration has dismissed the study \
                as fossil-fuel propaganda.
                """,
                source: "Breitbart",
                sourceURL: "https://breitbart.com",
                publishedAt: now.addingTimeInterval(-8 * 3600),
                viewpoint: .right,
                biasScore: 0.90,
                biasKeywords: ["devastating", "crushing", "propaganda", "aggressive", "forcing"],
                biasExplanation: "'Breitbart' carries the highest conservative bias rating in peer-reviewed media research. Emotionally loaded language and single-source framing constitute extreme partisan slant.",
                imageURL: nil,
                category: "Energy"
            ),
            NewsStory(
                title: "Crime Surges in Democrat-Run Cities as Progressive Prosecutors Face Voter Backlash",
                summary: "FBI crime data show violent crime rose 12% in cities with elected progressive prosecutors, prompting recall efforts in Los Angeles, San Francisco, and Chicago.",
                content: """
                New FBI statistics show that a cluster of large American cities helmed \
                by progressive prosecutors experienced a 12% jump in violent crime over \
                two years, fueling high-profile recall campaigns against district attorneys \
                backed by George Soros and similar donors. Victims' advocates say the \
                'soft-on-crime' approach has abandoned law-abiding residents. Several \
                prosecutors facing recall argue the data cherry-picks trends and ignores \
                broader national patterns.
                """,
                source: "Newsmax",
                sourceURL: "https://newsmax.com",
                publishedAt: now.addingTimeInterval(-10 * 3600),
                viewpoint: .right,
                biasScore: 0.76,
                biasKeywords: ["surge", "soft-on-crime", "abandoned", "backlash"],
                biasExplanation: "'Newsmax' carries a strong conservative baseline. 'Soft-on-crime' and name-dropping of political donors are classic partisan framing choices. Strong conservative lean.",
                imageURL: nil,
                category: "Crime"
            ),
            NewsStory(
                title: "Second Amendment Advocates Challenge Biden Gun-Control Rules in Federal Court",
                summary: "A coalition of gun-rights groups filed suit against ATF pistol-brace regulations they say unlawfully reclassify millions of legally-owned firearms without Congressional approval.",
                content: """
                Gun-rights organizations filed a broad legal challenge in federal district \
                court Thursday targeting ATF regulations issued under the Biden \
                administration that reclassify pistol-braced firearms as short-barreled \
                rifles, subjecting them to National Firearms Act restrictions. Plaintiffs \
                argue the agency exceeded its statutory authority and that the rules \
                effectively criminalize millions of law-abiding gun owners overnight. \
                The DOJ defended the regulations as a narrowly tailored public-safety measure.
                """,
                source: "The Blaze",
                sourceURL: "https://theblaze.com",
                publishedAt: now.addingTimeInterval(-12 * 3600),
                viewpoint: .right,
                biasScore: 0.70,
                biasKeywords: ["criminalize", "unlawfully", "exceeded authority"],
                biasExplanation: "'The Blaze' carries a strong conservative baseline. Framing exclusively through a gun-rights lens with language like 'criminalize law-abiding owners' reflects a strong conservative slant.",
                imageURL: nil,
                category: "Politics"
            ),
        ]
    }
}
