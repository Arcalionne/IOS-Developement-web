//
//  EventView.swift
//  Event_Efrei
//
//  Created by CGalbon on 18/12/2022.
//

import SwiftUI
import EventKit
import EventKitUI

struct EventView: View {
    let item: EventRecord?
    @State private var presentPopup:Bool = false
    @State private var presentError:Bool = false
    @State var returnMessage:String = ""
    
    var calendarHandle: CalendarHandle = CalendarHandle()
    @State var speakers: [SpeakerRecord] = []
    var body: some View {
        VStack(alignment: .leading){
            // Title
            VStack(alignment: .leading){
                Text(item?.fields.activity ?? "Title").font(.system(.largeTitle, design: .rounded).weight(.bold)).foregroundColor(.white)
                HStack(){
                    Text(item?.fields.type ?? "Activity").font(.system(.title)).foregroundColor(.white)
                    Text(EmojiEventTypes[item?.fields.type ?? "Default"] ?? "❓")
                }
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading).background(Color(red:0.51, green:0.22, blue:0.93)).padding(.bottom,10)
            //Event info
            VStack(alignment:.leading){
                ForEach(speakers){speaker in
                        Text("👤 \(speaker.fields.name)").font(.system(.title3))
                }
                HStack(){
                    Text("From :")
                    Text(item?.fields.start.formatted(.dateTime) ?? "2022")}.padding(.top, 10).frame(maxWidth: .infinity, alignment: .center)
                HStack(){
                    Text("To :")
                    Text(item?.fields.end.formatted(.dateTime) ?? "2022")}.frame(maxWidth: .infinity, alignment: .center)
                HStack(){
                Text("Room :")
                    Text(item?.fields.location ?? "Location")}.frame(maxWidth: .infinity, alignment: .center)
            }.frame(maxWidth: .infinity, alignment: .leading)
            //Ajouter au Calendar.
            HStack(){
                Spacer()
                Button("Add To Calendar") {
                    returnMessage = calendarHandle.addEventToCalendar(startDate: item?.fields.start, endDate: item?.fields.end, title: item?.fields.activity,location:
                                                                        item?.fields.location, speakers:speakers,activity_type:item?.fields.type)
                    if(returnMessage == "OK")
                    {
                        presentPopup = true
                    }
                    else
                    {
                        presentError = true
                    }
                }.padding().background(Color(red:0.51,green:0.22,blue:0.93)).foregroundColor(.white).fontWeight(.bold).clipShape(Capsule())
                    .alert("Event added to your calendar !", isPresented:  $presentPopup){
                        Button("OK", role:.cancel){}
                    }
                    .alert(returnMessage, isPresented:$presentError){
                        Button("OK", role:.cancel){}
                    }.frame(alignment:.center)
                Spacer()
            }
            Spacer()
        }.frame(minHeight: 0, maxHeight: .infinity).onAppear{
            let api = ScheduleApiCall()
            speakers = []
            if let elems = item?.fields.speakers{
                for elem in elems
                {
                    api.getSpeakerFromID(speakerID: elem){(errorHandle, records) in
                        if let _ = errorHandle.errorType, let errorMessage = errorHandle.errorMessage{
                            print(errorMessage)
                        }
                        else if let list = records{
                            speakers.append(list)
                        }
                        else{
                            print("Fatal Error.")
                        }
                    }
                }
                
            }
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(item:nil)
    }
}
