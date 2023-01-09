//
//  SpeakerView.swift
//  Event_Efrei
//
//  Created by CGalbon on 02/01/2023.
//

import SwiftUI


struct SpeakerView: View {

    let item: SpeakerRecord?
    @State var conferences: [EventRecord] = []

    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment:.leading){
                Text(item?.fields.name ?? "Title").font(.system(.largeTitle, design: .rounded)).fontWeight(.bold).foregroundColor(.white)
                Text(item?.fields.role ?? "Position").font(.system(.title2)).foregroundColor(.white)
                Text(item?.fields.company ?? "Company").font(.system(.title3)).italic().foregroundColor(.white)
            } .frame(maxWidth: .infinity, alignment:.leading).background(Color(red:0.51, green:0.22, blue:0.93)).scrollContentBackground(.hidden)
       
                Text("Contact information").font(.system(.title2))
                HStack(){
                    Image(systemName: "envelope.fill")
                    Text(item?.fields.email ?? "email@mail.com")}
                HStack(){
                    Image(systemName: "phone.fill")
                    Text(item?.fields.phone ?? "06-0000-0000")}
                Spacer()
                Text("Conferences").font(.system(.title2))
                if(item?.fields.speaking_at?.count ?? 0 <= 0)
                {
                    VStack(alignment: .center){
                        Text("This speaker has no scheduled talk yet, keep in touch !").font(.title)
                        Image(systemName: "questionmark.app").resizable().scaledToFit()
                    }
                }
                else{                Text("Speaking at \(item?.fields.speaking_at?.count ?? 0) talks this year")
                }
                NavigationView(){
                    List(){
                        ForEach(conferences){ conference in
                            NavigationLink(destination:EventView(item: conference))
                            {
                                VStack(alignment: .leading){
                                Text(conference.fields.activity)
                                Text("🗓\(conference.fields.start.formatted())")
                                Text("📍\(conference.fields.location)")
                                }
                            }
                        }
                    }
                }
                
            }.onAppear{
                let api = ScheduleApiCall()
                conferences = []
                if let elems = item?.fields.speaking_at{
                    for elem in elems
                    {
                        api.getEventFromID(eventID: elem){(errorHandle, records) in
                            if let _ = errorHandle.errorType, let errorMessage = errorHandle.errorMessage{
                                print(errorMessage)
                            }
                            else if let list = records{
                                conferences.append(list)
                            }
                            else{
                                print("Fatal Error.")
                            }
                        }
                    }
                    let temp = conferences.sorted(by:{ $0.fields.start < $1.fields.start})
                    conferences = temp
                }
            }
    }
}


struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerView(item:nil)
    }
}
