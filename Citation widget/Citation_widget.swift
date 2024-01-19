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
    func placeholder(in context: Context) -> CitationEntry {
        return createCitationTemplate()
    }

    func getSnapshot(in context: Context, completion: @escaping (CitationEntry) -> ()) {
        let entry = createCitationTemplate()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let date = Date()
        let entry = createCitationTemplate()
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 12, to: date)!
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        
        completion(timeline)
    }
}

struct Citation_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.citation.text)
            Text(entry.citation.author)
            Text(entry.citation.source)
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
    CitationEntry(date: .now, citation: CitationForDisplay(text: "text", author: "author", source: "source"))
}
