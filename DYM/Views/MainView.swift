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
    
    @State private var virtualPosition: Int? = nil
    private let virtualSlotsAmount = 10000
    private let recenterTriggerDistance = 1500

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
                ContentUnavailableView("Choose a category", systemImage: "square.grid.2x2")
            } else if posters.isEmpty {
                ContentUnavailableView("No posters", systemImage: "photo")
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<virtualSlotsAmount, id: \.self) { vIndex in
                            posters[wrappedIndex(for: vIndex, itemCount: posters.count)].image
                                .resizable()
                                  .scaledToFit()
                                  .containerRelativeFrame(.horizontal)
                                  .scrollTargetLayout()
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $virtualPosition)
                .onAppear {
                    if virtualPosition == nil { resetToCenter() }
                }
                .onChange(of: virtualPosition) { _, newValue in
                    guard let newValue, posters.count > 0 else { return }
                    recenterIfNeeded(currentVirtualIndex: newValue)
                }
            }
        }
        .onChange(of: category?.id) {
            resetToCenter()
        }
        .onChange(of: posters.count) {
            resetToCenter()
        }
    }

    // MARK: Для бесконечного скрола
    private func resetToCenter() {
        guard posters.count > 0 else {
            virtualPosition = nil
            return
        }
        let center = virtualSlotsAmount / 2
        //withTransaction(Transaction( чтобы с анимацией в центр не поехать
        withTransaction(Transaction(animation: nil)) {
            virtualPosition = center
        }
    }

    private func recenterIfNeeded(currentVirtualIndex: Int) {
        let center = virtualSlotsAmount / 2

        if currentVirtualIndex < recenterTriggerDistance || currentVirtualIndex > (virtualSlotsAmount - recenterTriggerDistance) {
            //какой реальный постер сейчас
            let real = wrappedIndex(for: currentVirtualIndex, itemCount: posters.count)
            //переносим в центр, сохранив реальный индекс
            let recentered = center + real

            if recentered != currentVirtualIndex {
                withTransaction(Transaction(animation: nil)) {
                    virtualPosition = recentered
                }
            }
        }
    }

    //получаем реальный индекс из виртуального
    private func wrappedIndex(for rawIndex: Int, itemCount: Int) -> Int {
        precondition(itemCount > 0, "itemCount must be > 0")

        let remainder = rawIndex % itemCount
        let nonNegativeIndex = remainder >= 0
            ? remainder
            : remainder + itemCount

        return nonNegativeIndex
    }
}

#Preview {
    let common = Category(
        name: "Common",
        categoryDescription: "Default category",
        color: .gray,
        icon: "♾️",
        isProtected: true
    )

    MainView(category: .constant(common))
}
