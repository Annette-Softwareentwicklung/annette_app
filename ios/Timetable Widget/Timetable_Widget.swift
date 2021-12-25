//
//  FlutterWidget.swift
//  FlutterWidget
//
//  Created by Thomas Leiter on 28.10.20.
//

import WidgetKit
import SwiftUI
import Intents

struct FlutterData: Decodable, Hashable {
    let id: Int
    let subject: String
    let room: String
    let dayNumber: Int
    let lessonNumber: Int}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let flutterData: FlutterData?
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), flutterData: FlutterData(id: 1, subject: "Annette App", room: "A100",dayNumber: 1,lessonNumber: 1))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), flutterData: FlutterData(id: 1, subject: "Annette App", room: "A100",dayNumber: 1,lessonNumber: 1))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.annetteapp")
        var flutterData: FlutterData? = nil
        
        if(sharedDefaults != nil) {
            do {
              let shared = sharedDefaults?.string(forKey: "widgetData")
              if(shared != nil){
                let decoder = JSONDecoder()
                flutterData = try decoder.decode(FlutterData.self, from: shared!.data(using: .utf8)!)
              }
            } catch {
              print(error)
            }
        }

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, flutterData: flutterData)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct FlutterWidgetEntryView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        Text(entry.flutterData!.subject)
    }
    
    private var NoDataView: some View {
        
        VStack (alignment: .trailing) {
            HStack(alignment: .top) {
                Image(systemName: "1.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 40))
                Spacer()
                
                    Text("8:00 - 8:45")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 15,weight: .regular,design: .default))
            }
            Text("Orientierungsstunde")
                .font(.system(size: 25,weight: .medium,design: .default))

            HStack() {
                Text("A101")
                    .font(.system(size: 20,weight: .regular,design: .default))
                Image(systemName: "location.circle")
                    .font(.system(size: 20,weight: .light))
            }
            
        }.padding()
      //Text("Konfiguriere den Stundenplan in der Annette App!")
    }
    
    
    var body: some View {
      if(entry.flutterData == nil) {
        NoDataView
      } else {
        FlutterDataView
      }
    }
}


@main
struct FlutterWidget: Widget {
    let kind: String = "FlutterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlutterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Stundenplan")
        .description("Zeigt die aktuelle Stunde inklusive Raum an.")
        .supportedFamilies([.systemSmall,.systemMedium])
    }
}

struct FlutterWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FlutterWidgetEntryView(entry: SimpleEntry(date: Date(), flutterData: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            FlutterWidgetEntryView(entry: SimpleEntry(date: Date(), flutterData: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
}
