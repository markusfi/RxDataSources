//
//  SectionedViewType.swift
//  RxDataSources
//
//  Created by Krunoslav Zaher on 6/27/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import UIKit

func indexSet(values: [Int]) -> NSIndexSet {
    let indexSet = NSMutableIndexSet()
    for i in values {
        indexSet.addIndex(i)
    }
    return indexSet
}

extension UITableView : SectionedViewType {
    public func insertItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation) {
        self.insertRowsAtIndexPaths(paths, withRowAnimation: animationStyle)
    }
    
    public func deleteItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation) {
        self.deleteRowsAtIndexPaths(paths, withRowAnimation: animationStyle)
    }
    
    public func moveItemAtIndexPath(from: NSIndexPath, to: NSIndexPath) {
        self.moveRowAtIndexPath(from, toIndexPath: to)
    }
    
    public func reloadItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation) {
        self.reloadRowsAtIndexPaths(paths, withRowAnimation: animationStyle)
    }
    
    public func insertSections(sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.insertSections(indexSet(sections), withRowAnimation: animationStyle)
    }
    
    public func deleteSections(sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.deleteSections(indexSet(sections), withRowAnimation: animationStyle)
    }
    
    public func moveSection(from: Int, to: Int) {
        self.moveSection(from, toSection: to)
    }
    
    public func reloadSections(sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.reloadSections(indexSet(sections), withRowAnimation: animationStyle)
    }

    public func performBatchUpdates<S: SectionModelType>(changes: Changeset<S>) {
        self.beginUpdates()
        _performBatchUpdates(self, changes: changes)
        self.endUpdates()
    }
}

extension UICollectionView : SectionedViewType {
    public func insertItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation) {
        self.insertItemsAtIndexPaths(paths)
    }
    
    public func deleteItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation) {
        self.deleteItemsAtIndexPaths(paths)
    }

    public func moveItemAtIndexPath(from: NSIndexPath, to: NSIndexPath) {
        self.moveItemAtIndexPath(from, toIndexPath: to)
    }
    
    public func reloadItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation) {
        self.reloadItemsAtIndexPaths(paths)
    }
    
    public func insertSections(sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.insertSections(indexSet(sections))
    }
    
    public func deleteSections(sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.deleteSections(indexSet(sections))
    }
    
    public func moveSection(from: Int, to: Int) {
        self.moveSection(from, toSection: to)
    }
    
    public func reloadSections(sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.reloadSections(indexSet(sections))
    }
    
    public func performBatchUpdates<S: SectionModelType>(changes: Changeset<S>) {
        self.performBatchUpdates({ () -> Void in
            _performBatchUpdates(self, changes: changes)
        }, completion: { (completed: Bool) -> Void in
        })
    }
}

public protocol SectionedViewType {
    func insertItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation)
    func deleteItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation)
    func moveItemAtIndexPath(from: NSIndexPath, to: NSIndexPath)
    func reloadItemsAtIndexPaths(paths: [NSIndexPath], animationStyle: UITableViewRowAnimation)
    
    func insertSections(sections: [Int], animationStyle: UITableViewRowAnimation)
    func deleteSections(sections: [Int], animationStyle: UITableViewRowAnimation)
    func moveSection(from: Int, to: Int)
    func reloadSections(sections: [Int], animationStyle: UITableViewRowAnimation)

    func performBatchUpdates<S>(changes: Changeset<S>)
}

func _performBatchUpdates<V: SectionedViewType, S: SectionModelType>(view: V, changes: Changeset<S>) {
    typealias I = S.Item
    let rowAnimation = UITableViewRowAnimation.Automatic
    
    view.deleteSections(changes.deletedSections, animationStyle: rowAnimation)
    view.reloadSections(changes.updatedSections, animationStyle: rowAnimation)
    view.insertSections(changes.insertedSections, animationStyle: rowAnimation)
    for (from, to) in changes.movedSections {
        view.moveSection(from, to: to)
    }
    
    view.deleteItemsAtIndexPaths(
        changes.deletedItems.map { NSIndexPath(forItem: $0.itemIndex, inSection: $0.sectionIndex) },
        animationStyle: rowAnimation
    )
    view.insertItemsAtIndexPaths(
        changes.insertedItems.map { NSIndexPath(forItem: $0.itemIndex, inSection: $0.sectionIndex) },
        animationStyle: rowAnimation
    )
    view.reloadItemsAtIndexPaths(
        changes.updatedItems.map { NSIndexPath(forItem: $0.itemIndex, inSection: $0.sectionIndex) },
        animationStyle: rowAnimation
    )
    
    for (from, to) in changes.movedItems {
        view.moveItemAtIndexPath(
            NSIndexPath(forItem: from.itemIndex, inSection: from.sectionIndex),
            to: NSIndexPath(forItem: to.itemIndex, inSection: to.sectionIndex)
        )
    }
}