//
//  ContentView.swift
//  test.realitykit
//
//  Created by H1Gdev on 2022/08/01.
//

import SwiftUI

struct ContentView : View {
#if true
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
#else
    @State var orientation = UIDevice.current.orientation

    var body: some View {
        CameraViewContainer(orientation: $orientation)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                orientation = UIDevice.current.orientation
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
    }
#endif
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
