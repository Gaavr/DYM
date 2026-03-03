//
//  ContentView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.01.2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @Binding var category: Category?
    
    @Query private var posters: [Poster]
    
    @AppStorage(SettingsKeys.isRandomOrder) private var isRandomOrder: Bool = false
    @AppStorage(SettingsKeys.motivationIntensity) private var toneRaw: String = MotivationIntensity.any.rawValue
    
    @State private var orderedPosters: [Poster] = []
    @State private var virtualPosition: Int? = nil
    
    private let virtualSlotsAmount = 10000
    private let recenterTriggerDistance = 1500
    
    private var displayedPosters: [Poster] {
        isRandomOrder ? orderedPosters : filteredPosters
    }
    
    private var tone: MotivationIntensity {
        MotivationIntensity(rawValue: toneRaw) ?? .any
    }
    
    private var filteredPosters: [Poster] {
        switch tone {
        case .any:
            return posters
        case .positive:
            return posters.filter { $0.motivationIntensity == .positive }
        case .negative:
            return posters.filter { $0.motivationIntensity == .negative }
        }
    }
    
    init(category: Binding<Category?>) {
        self._category = category
        let selectedID = category.wrappedValue?.id
        
        _posters = Query(
            filter: #Predicate<Poster> { poster in
                selectedID != nil && poster.category.id == selectedID!
            }
        )
    }
    
    var body: some View {
        Group {
            if category == nil {
                ContentUnavailableView("category.choose", systemImage: "square.grid.2x2")
            } else if displayedPosters.isEmpty {
                ContentUnavailableView("poster.noPosters", systemImage: "photo")
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<virtualSlotsAmount, id: \.self) { vIndex in
                            displayedPosters[wrappedIndex(for: vIndex, itemCount: displayedPosters.count)].image
                                .resizable()
                                .scaledToFit() //TODO: дать выбор пользователю
                                .containerRelativeFrame(.horizontal)
                                .scrollTargetLayout()
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $virtualPosition)
                .onChange(of: virtualPosition) { _, newValue in
                    guard let newValue, displayedPosters.count > 0 else { return }
                    recenterIfNeeded(currentVirtualIndex: newValue)
                }
            }
        }
        .onAppear {
            rebuildOrderIfNeeded()
            if virtualPosition == nil { resetToCenter() }
        }
        .onChange(of: category?.id) {
            rebuildOrderIfNeeded()
            resetToCenter()
        }
        .onChange(of: posters.count) {
            rebuildOrderIfNeeded()
            resetToCenter()
        }
        .onChange(of: isRandomOrder) {
            rebuildOrderIfNeeded()
            resetToCenter()
        }
        .onChange(of: toneRaw) {
            rebuildOrderIfNeeded()
            resetToCenter()
        }
    }
    
    // MARK: - infinity scroll
    private func resetToCenter() {
        guard displayedPosters.count > 0 else {
            virtualPosition = nil
            return
        }
        let center = virtualSlotsAmount / 2
        //withTransaction(Transaction - чтобы с анимацией в центр не поехать
        withTransaction(Transaction(animation: nil)) {
            virtualPosition = center
        }
    }
    
    private func recenterIfNeeded(currentVirtualIndex: Int) {
        let center = virtualSlotsAmount / 2
        
        if currentVirtualIndex < recenterTriggerDistance || currentVirtualIndex > (virtualSlotsAmount - recenterTriggerDistance) {
            let real = wrappedIndex(for: currentVirtualIndex, itemCount: displayedPosters.count)
            let recentered = center + real
            if recentered != currentVirtualIndex {
                withTransaction(Transaction(animation: nil)) {
                    virtualPosition = recentered
                }
            }
        }
    }
    
    private func wrappedIndex(for rawIndex: Int, itemCount: Int) -> Int {
        precondition(itemCount > 0, "itemCount must be > 0")
        
        let remainder = rawIndex % itemCount
        let nonNegativeIndex = remainder >= 0
        ? remainder
        : remainder + itemCount
        
        return nonNegativeIndex
    }
    
    private func rebuildOrderIfNeeded() {
        orderedPosters = isRandomOrder ? filteredPosters.shuffled() : []
    }
}

#Preview {
    MainView(category: .constant(.example))
}
