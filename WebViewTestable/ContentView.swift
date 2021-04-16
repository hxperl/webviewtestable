//
//  ContentView.swift
//  WebViewTestable
//
//  Created by Geonseok Lee on 2021/04/16.
//

import SwiftUI

struct ContentView: View {
  
  @State var text: String = "about:blank"
  
  var body: some View {
    NavigationView {
      VStack(spacing: 40) {
        TextField(
          "웹 주소 입력",
          text: $text
        )
        NavigationLink(
          destination: NavigationLazyView(
            BaseWebView(
              url: URL(string: self.text)!
            )
          ),
          label: {
            Text("웹 뷰 열기")
          }
        )
      }
      .padding(.horizontal, 20)
      .onChange(of: text, perform: { value in
        print("text", text)
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


struct NavigationLazyView<Content: View>: View {
  let build: () -> Content
  init(_ build: @autoclosure @escaping () -> Content) {
    self.build = build
  }
  var body: Content {
    build()
  }
}
