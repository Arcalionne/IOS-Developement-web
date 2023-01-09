//
//  ScheduleView.swift
//  Event_Efrei
//
//  Created by CGalbon on 18/12/2022.
//

import SwiftUI

struct ScheduleView: View {
    @State var events: [EventRecord] = []
    @State var locations: [String] = []
    @State private var searchText=""
    @State private var searchLocation:String = "Any"
    @State private var searchType: String = "Any"
    @State private var day: Int = 1
    let api = ScheduleApiCall()
    var searchResults: [EventRecord] {
        var results = events
        var components = DateComponents()
        components.year = 2023
        components.month = 2
        components.day = 8
        let firstDay = Calendar.current.date(from:components)
        if searchText.isEmpty && searchLocation == "Any" && searchType == "Any" && day==0{
                return events
        }
        else {
                if(!searchText.isEmpty)
                {
                    results = results.filter { $0.fields.activity.contains(searchText)
                        
                    }
                }
                if(searchLocation != "Any"){
                    results = results.filter {
                        $0.fields.location.contains(searchLocation)
                    }
                }
                if(searchType != "Any"){
                    results = results.filter{
                        $0.fields.type == searchType
                    }
                }
                if(day>0)
                {
                    let dateToCompare = Calendar.current.date(byAdding: .day, value:(day-1), to: firstDay!)
                    
                    results = results.filter{
                        Calendar.current.isDate($0.fields.start, equalTo: dateToCompare!, toGranularity: .day)  }
                }
                return results
            }
        }
    var body: some View {
        NavigationView {
            List{
                VStack {
                    Picker(selection: $searchLocation, label: Text("Location")) {
                        Text("Any").tag("Any")
                        ForEach(locations,id: \.self){item in
                            Text("\(item)").tag(item)
                        }
                    }
                    Picker(selection: $searchType, label: Text("Type")) {
                        Text("Any").tag("Any")
                        ForEach(EventTypes,id: \.self){item in
                            Text("\(item)\(EmojiEventTypes[item] ?? "")").tag(item)
                        }                    }
                    Picker(selection:$day, label:Text("Day"))
                    {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("All").tag(0)
                    }
                }
                if searchResults.isEmpty{
                    VStack(){
                        Text("Not found").font(.title)
                        Text("Try to do another research with broader criterias !")}
                    
                }
                ForEach(searchResults) { event in
                    NavigationLink(destination: EventView(item:event))
                    {
                        VStack(alignment:.leading)
                        {
                            Text(event.fields.activity).font(.headline)
                            Text(event.fields.location)
                            Text(event.fields.start.formatted())
                           
                        }
                    }
                }
               
            }.navigationTitle("Conferences").searchable(text:$searchText)
        }.onAppear{
            var locationSet:Set<String>=[]
            api.getSchedule{(errorHandle, records) in
                if let _ = errorHandle.errorType, let errorMessage = errorHandle.errorMessage{
                    print(errorMessage)
                }
                else if let list = records{
                    for record in list {
                        locationSet.insert(record.fields.location)
                    }
                    events = list
                    locations = Array(locationSet)
                }
                else{
                    print("Fatal Error.")
                }
            }
        }
    }
}


struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
