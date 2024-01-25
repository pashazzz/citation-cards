//
//  Citation_widget.swift
//  Citation widget
//
//  Created by Pavlo Malyshkin on 19.1.2024.
//

import WidgetKit
import SwiftUI

struct CitationForDisplay {
    var text: String
    var author: String
    var source: String
}
struct CitationEntry: TimelineEntry {
    var date: Date
    var citation: CitationForDisplay
}

private func createCitationTemplate() -> CitationEntry {
    return CitationEntry(
        date: Date(),
        citation: CitationForDisplay(
            text: "Citation",
            author: "Author",
            source: "Source")
    )
}

struct Provider: TimelineProvider {
    // needed to initialize shared persistent storage
    let persistent = Persistent()
    
    func placeholder(in context: Context) -> CitationEntry {
        return createCitationTemplate()
    }

    func getSnapshot(in context: Context, completion: @escaping (CitationEntry) -> ()) {
        let entry = createCitationTemplate()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let storage = Storage()
        let settings = Settings()
        
        let onlyFavourites = settings.getWidgetOnlyFavourites()
        let includedTags = settings.getWidgetTags()

        let date = Date()
        var entry: CitationEntry = createCitationTemplate()
        let citation = storage.getRandomCitation(
            onlyFavourites: onlyFavourites,
            withTags: includedTags)

        if citation != nil {
            entry = CitationEntry(
                date: date,
                citation: CitationForDisplay(
                    text: citation?.text ?? "",
                    author: citation?.author ?? "",
                    source: citation?.source ?? ""))
        }
        
        let updateInterval = Int(settings.getWidgetUpdateInterval())
        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: updateInterval, to: date)!
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        
        completion(timeline)
    }
}

struct Citation_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.citation.text)
                .font(.system(size: 12))
                .padding([.bottom], 2)
            Text(entry.citation.author)
                .font(.system(size: 11))
            Text(entry.citation.source)
                .font(.system(size: 11))
        }
    }
}

struct Citation_widget: Widget {
    let kind: String = "Citation_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Citation_widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Citation_widgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Citation Widget")
        .description("Display random citation from existed")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    Citation_widget()
} timeline: {
    CitationEntry(date: .now, citation: CitationForDisplay(text: "text", author: "author", source: "source"))
    CitationEntry(date: .now, citation: CitationForDisplay(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", author: "author", source: "source"))
}
