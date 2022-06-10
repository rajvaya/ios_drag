//
//  ContentView.swift
//  DummyDrawer
//
//  Created by raj vaya on 06/06/22.
//

import SwiftUI

struct ContentView: View {
  @State private var offset: CGFloat = 0
  @State private var lastOffset: CGFloat = 0
  @GestureState var gestureOffset: CGFloat = 0
  
  var body: some View {
    ZStack {
      DrawerHome()
        .ignoresSafeArea(.all, edges: .all)
      GeometryReader { proxy -> AnyView in
        let height = proxy.frame(in: .global).height
        return AnyView(
          ZStack {
            VStack(alignment: .center) {
              HStack(alignment: .center) {
                Spacer()
                Capsule()
                  .frame(width: 60, height: 10, alignment: .center)
                  .foregroundColor(Color.white)
                Spacer()
              }.padding()
              ScrollViewContent()
                .padding(20)
            }
            .background(Color.blue)
          }.offset(y: height - 500)
            .offset(y: -offset > 0 ? -offset <= (height - 500) ? offset :
                      -(height - 500) : 0)
            .gesture(DragGesture().updating($gestureOffset, body: {
              value, out, _ in

              out = value.translation.height
              onChange()
            }).onEnded { _ in
              let maxHeight = height - 500
              withAnimation {
                if -offset > maxHeight / 2 {
                  offset = -maxHeight
                }
                else {
                  offset = 0
                }
              }
              
              lastOffset = offset
            }
          )
        )
      }.ignoresSafeArea(.all, edges: .bottom)
    }
  }
  
  func onChange() {
    DispatchQueue.main.async {
      self.offset = gestureOffset + lastOffset
    }
  }
}

struct DrawerHome: View {
  var body: some View {
    GeometryReader { proxy in
      let frame = proxy.frame(in: .global)
      Rectangle()
        .foregroundColor(Color.red)
        .frame(
          width: frame.width,
          height: frame.height,
          alignment: .center
      )
    }
  }
}

struct ScrollViewContent: View {
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack{
        ForEach(0 ... 10, id: \.self) { _ in
          Image("image")
        }
      }
    }
  }
}
