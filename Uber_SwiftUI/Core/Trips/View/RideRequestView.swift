//
//  RideRequestView.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 28/03/23.
//

import SwiftUI

struct RideRequestView: View {
  @State private var selectedRideType: RideType = .uberX
  @State private var confirmRide: Bool = false
  @State private var didConfirmedRide: Bool = false
  
  
  
  
  
  
  
  @EnvironmentObject var locationViewModel: LocationSearchViewModel
  
  var body: some View {
    VStack {
      Capsule().foregroundColor(Color(.systemGray5)).frame(width: 48, height: 6).padding(.top, 8)
      
      // Trip info view
      HStack {
        VStack {
          Circle().fill(Color(.systemGray3)).frame(width: 8, height: 8)
          
          Rectangle().fill(Color(.systemGray3)).frame(width: 1, height: 32)
          
          Rectangle().fill(.black).frame(width: 8, height: 8)
        }
        
        VStack(alignment: .leading, spacing: 24) {
          HStack {
            Text("Current location").font(.system(size: 16, weight: .semibold)).foregroundColor(.gray)
            Spacer()
            Text(locationViewModel.pickupTime ?? "").font(.system(size: 14, weight: .semibold)).foregroundColor(.gray)
          }.padding(.bottom, 10)
          
          HStack {
            if let destination = locationViewModel.selectedUberLocation {
              Text(destination.title).font(.system(size: 16, weight: .semibold)).lineLimit(1)
            }
            Spacer()
            Text(locationViewModel.dropoffTime ?? "").font(.system(size: 14, weight: .semibold)).foregroundColor(.gray)
          }
        }.padding(.leading, 8)
      }.padding()
      
      Divider()
      
      // ride type selection view
      Text("SUGGESTED RIDES").font(.subheadline).fontWeight(.semibold).padding().foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(RideType.allCases) { rideType in
            VStack(alignment: .leading) {
              Image(rideType.imageName).resizable().scaledToFit()
              VStack(alignment: .leading, spacing: 4) {
                Text(rideType.description).font(.system(size: 14, weight: .semibold))
                Text(locationViewModel.computeRidePrice(forType: rideType).toCurrency()).font(.system(size: 14, weight: .semibold))
              }.padding()
            }.frame(width: 112, height: 140)
              .foregroundColor(selectedRideType == rideType ? .white : Color.theme.primaryTextColor)
              .background(selectedRideType == rideType ? Color(.systemBlue) : Color.theme.secondaryBackgroundColor)
              .scaleEffect(selectedRideType == rideType ? 1.2 : 1.0)
              .cornerRadius(10)
              .onTapGesture {
                withAnimation(.spring()) {
                  selectedRideType = rideType
                }
              }
          }
        }
      }.padding(.horizontal)
      
      Divider().padding(.vertical, 8)
      
      // payment option view
      HStack(spacing: 12) {
        Text("Visa").font(.subheadline).fontWeight(.semibold).padding(6).background(.blue)
          .cornerRadius(4).foregroundColor(.white).padding(.leading)
        Text("**** 1234").fontWeight(.bold)
        Spacer()
        Image(systemName: "chevron.right").imageScale(.medium).padding()
      }
      .frame(height: 50).background(Color.theme.secondaryBackgroundColor).cornerRadius(10).padding(.horizontal)
      
      // request ride button
      //      Button { } label: {
      //        Text("CONFIRM RIDE").fontWeight(.bold).frame(width: UIScreen.main.bounds.width - 32, height: 50)
      //          .background(.blue).cornerRadius(10).foregroundColor(.white)
      //      }
      
      if confirmRide {
        SwipeToRequestRideView()
          .onSwipeSuccess {
            self.didConfirmedRide = true
            self.confirmRide = false
          }
          .transition(AnyTransition.scale.animation(Animation.spring(response: 0.3, dampingFraction: 0.5)))
      }
      
      if didConfirmedRide {
        ProgressView()
          .transition(AnyTransition.scale.animation(Animation.spring(response: 0.5, dampingFraction: 0.5)))
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              self.didConfirmedRide = false
              self.confirmRide = true
            }
          }
      }
    }
    .padding(.bottom, 24).background(Color.theme.backgroundColor).cornerRadius(16)
    .onAppear {
      self.confirmRide = true
    }
  }
}

struct RideRequestView_Previews: PreviewProvider {
  static var previews: some View {
    RideRequestView().environmentObject(LocationSearchViewModel())
  }
}
