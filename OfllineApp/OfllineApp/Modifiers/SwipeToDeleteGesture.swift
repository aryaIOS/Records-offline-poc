//
//  SwipeToDeleteGesture.swift
//  OfllineApp
//
//  Created by Arya Vashisht on 30/05/24.
//

import SwiftUI

extension View {
  func swipeToDelete(isDeleting: Binding<Bool>, deleteAction: @escaping () -> Void) -> some View {
    ZStack {
      self
      
      if isDeleting.wrappedValue {
        HStack {
          Spacer()
          Button(action: {
            withAnimation {
              deleteAction()
              isDeleting.wrappedValue = false
            }
          }) {
            Image(systemName: "trash")
              .foregroundColor(.white)
              .padding()
              .background(Color.red)
              .clipShape(Circle())
          }
          .offset(x: -30)
          .transition(.move(edge: .trailing))
        }
        .frame(height: .infinity)
        .background(Color.clear)
        .gesture(
          DragGesture()
            .onChanged { value in
              if value.translation.width < -50 {
                isDeleting.wrappedValue = true
              }
            }
            .onEnded { value in
              if value.translation.width < -100 {
                withAnimation {
                  deleteAction()
                  isDeleting.wrappedValue = false
                }
              } else {
                withAnimation {
                  isDeleting.wrappedValue = false
                }
              }
            }
        )
        .animation(.default)
      }
    }
  }
}
