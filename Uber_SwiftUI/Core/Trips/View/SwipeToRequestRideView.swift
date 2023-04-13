//
//  SwipeToRequestRideView.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 29/03/23.
//

import SwiftUI

struct SwipeToRequestRideView: View {
  /// - we want to animate the thumb size when user starts dragging ( swipe )
  @State private var thumbSize: CGSize = CGSize.inactiveThumbSize
  /// - we need to keep track of the dragging value. Initially it's zero
  @State private var dragOffset: CGSize = .zero
  // keep track of when enough was swipped
  @State private var isEnough: Bool = false
  
  /// - The track doesn't change size
  let trackSize = CGSize.trackSize
  
  private var actionSuccess: (()->())?
  
  var body: some View {
    ZStack {
      // Swipe Track
      Capsule().frame(width: trackSize.width , height: trackSize.height)
        .foregroundColor(Color.theme.buttonSecondaryColor)
      // Help Text
      Text("Swipe to confirm ride")
        .fontWeight(.semibold).foregroundColor(.black).offset(x: 30, y: 0)
        .opacity(Double(1 - ( (self.dragOffset.width * 2) / self.trackSize.width )))
        .shimmer(.init(tint: .black.opacity(0.2), highlight: .black, blur: 5))
      
      // Thumb
      ZStack {
        Capsule().frame(width: thumbSize.width, height: thumbSize.height)
          .foregroundColor(Color.theme.buttonPrimaryColor)
        Image(systemName: "chevron.right.2").font(.system(size: 25)).foregroundColor(.black)
      }
      .offset(x: getDragOffsetX(), y: 0)
      .animation(Animation.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
      .gesture(
        DragGesture()
          .onChanged { value in self.handleDragChanged(value) }
          .onEnded { _ in self.handleDragEnded() }
      )
    }
  }
}

extension SwipeToRequestRideView {
  func onSwipeSuccess(_ action: @escaping() -> ()) -> Self {
    var this = self
    this.actionSuccess = action
    return this
  }
}

extension SwipeToRequestRideView {
  // MARK: - Haptics Feedback
  private func indicateCanLiftFinger() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
  }
  private func indicateSwipeWasSuccessful() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
  }
  
  // MARK: - Helpers
  private func getDragOffsetX() -> CGFloat {
    let clampedDragOffsetX = dragOffset.width.clamp(lower: 0, trackSize.width - thumbSize.width)
    return -( trackSize.width / 2 - thumbSize.width / 2 - (clampedDragOffsetX) )
  }
  
  // MARK: - Gestures handlers
  private func handleDragChanged(_ value: DragGesture.Value) -> () {
    self.dragOffset = value.translation
    
    let dragWidth = value.translation.width
    let targetDragWidth = self.trackSize.width - ( self.thumbSize.width * 2 )
    let wasInitiated = dragWidth > 2
    let didReachTarget = dragWidth > targetDragWidth
    
    self.thumbSize = wasInitiated ? CGSize.activeThumbSize : CGSize.inactiveThumbSize
    
    if didReachTarget {
      // only trigger once
      if !self.isEnough {
        self.indicateCanLiftFinger()
      }
      // we need to indicate something here
      self.isEnough = true
    } else {
      // reset, do not indicate here
      self.isEnough = false
    }
  }
  private func handleDragEnded() {
    if self.isEnough {
      self.dragOffset = CGSize(width: self.trackSize.width - self.thumbSize.width, height: 0)
      
      if self.actionSuccess != nil {
        self.indicateSwipeWasSuccessful()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
          self.actionSuccess!()
        }
      }
    } else {
      self.dragOffset = .zero
      self.thumbSize = CGSize.inactiveThumbSize
    }
  }
}


