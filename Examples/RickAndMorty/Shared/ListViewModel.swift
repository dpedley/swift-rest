//
//  ListViewModel.swift
//  RickAndMorty
//
//  Created by Douglas Pedley on 6/30/21.
//

import SwiftUI
import SwiftRest

class ListViewModel: ObservableObject {
    enum PagingState {
        case empty
        case loading
        case nextPage(page: Int)
        case complete
    }
    @Published var characters: [RickAndMorty.Character] = []
    @Published var responseError: AsyncRestError?
    @Published var pagination = PagingState.loading
    @Published var listResult: AsyncResult<RickAndMorty.ListResponse>? {
        didSet {
            guard let result = listResult else {
                return
            }
            switch result {
            case .failure(let error):
                responseError = error
            case .success(let response):
                characters.append(contentsOf: response.results)
                if characters.count > 0 {
                   if case let .nextPage(page) = pagination {
                       if page < response.info.pages {
                           pagination = .nextPage(page: page + 1)
                       } else {
                           pagination = .complete
                       }
                   } else {
                       pagination = .nextPage(page: 2)
                   }
               } else {
                   pagination = .empty
               }
            }
        }
    }
}
