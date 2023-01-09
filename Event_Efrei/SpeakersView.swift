//
//  SpeakersView.swift
//  Event_Efrei
//
//  Created by CGalbon on 02/01/2023.
//

import SwiftUI

struct SpeakersView: View {
    @State var speakers: [SpeakerRecord] = []
    @State private var searchText = ""
    var searchResults: [SpeakerRecord] {
            if searchText.isEmpty {
                return speakers
            } else {
                return speakers.filter { $0.fields.name.contains(searchText) }
            }
        }

    var body: some View {
        NavigationView{
            List{
                ForEach(searchResults, id:\.self) { speaker in
                    NavigationLink(destination:SpeakerView(item: speaker))
                    {
                        VStack(alignment: .leading)
                        {
                            Text(speaker.fields.name).fontWeight(.bold).foregroundColor(Color(red:0.51, green:0.22, blue:0.93))
                            Text(speaker.fields.company).italic()
                        }
                    }
                }
            }.navigationTitle("Speakers").searchable(text:$searchText)
        }.onAppear{
            let api = ScheduleApiCall()
            api.getSpeakers{
                (errorHandle, records) in
                if let _ = errorHandle.errorType, let errorMessage = errorHandle.errorMessage{
                    print(errorMessage)
                }
                else if let list = records{
                    speakers = list
                }
                else
                {
                    print("Fatal error!")
                }
            }
        }
    }
    
}

struct SpeakersView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakersView()
    }
}
