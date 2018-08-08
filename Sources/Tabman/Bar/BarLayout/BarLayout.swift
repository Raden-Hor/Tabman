//
//  BarLayout.swift
//  Tabman
//
//  Created by Merrick Sapsford on 30/05/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

/**
 `BarLayout` dictates the way that BarButtons are displayed within a bar, handling layout and population.
 
 Attention: You should not directly use `BarLayout`, but instead inherit from it or use an available Tabman subclass such as `ButtonBarLayout`.
 **/
open class BarLayout: LayoutPerformer, BarViewFocusProvider {
    
    // MARK: Types
    
    public enum ContentMode {
        case fill
        case fit
    }
    
    // MARK: Properties
    
    /// Container view which contains actual contents
    let container = UIView()
    /// Layout Guides that provide inset values.
    private weak var insetGuides: BarLayoutInsetGuides!
    /// The parent of the layout.
    private weak var parent: BarLayoutParent!
    
    /// Constraint that is active when constraining width to a `.fit` contentMode.
    private var widthConstraint: NSLayoutConstraint?
    
    /**
     The display mode in which to display the content in the layout.
     
     Options:
     - `.fill`: The layout and contents will be intrinsically sized, taking up as much space as required.
     - `.fit`: The layout and it's contents will be restricted to fitting within the bounds of the bar.
     
     By default this is set to `.fill`
    **/
    public var contentMode: ContentMode = .fill {
        didSet {
            guard oldValue != contentMode else {
                return
            }
            update(for: contentMode)
        }
    }
    
    // MARK: Init
    
    public required init() {}
    
    // MARK: LayoutPerformer
    
    public private(set) var hasPerformedLayout = false

    internal func performLayout(parent: BarLayoutParent,
                                insetGuides: BarLayoutInsetGuides) {
        self.parent = parent
        self.insetGuides = insetGuides
        performLayout(in: container)
    }
    
    open func performLayout(in view: UIView) {
        guard !hasPerformedLayout else {
            fatalError("performLayout() can only be called once.")
        }
        hasPerformedLayout = true
    }
    
    // MARK: Lifecycle
    
    /**
     Insert new bar buttons into the layout from a specified index.
     
     - Parameter buttons: The buttons to insert.
     - Parameter index: The index to start inserting the buttons at.
     **/
    open func insert(buttons: [BarButton], at index: Int) {
        
    }

    /**
     Remove existing bar buttons from the layout.
     
     - Parameter buttons: The buttons to remove.
     **/
    open func remove(buttons: [BarButton]) {
        
    }

    // MARK: BarViewFocusProvider
    
    /**
     Calculate the `focusRect` for the current position and capacity.
     
     This rect defines the area of the layout that should currently be highlighted for the selected bar button.

     - Parameter position: Current position to display.
     - Parameter capacity: Capacity of the bar (items).
     
     - Returns: Calculated focus rect.
     **/
    open func barFocusRect(for position: CGFloat, capacity: Int) -> CGRect {
        fatalError("Implement in subclass")
    }
}

// MARK: - Customization
public extension BarLayout {
    
    /// Inset to apply to the outside of the layout.
    public var contentInset: UIEdgeInsets {
        set {
            insetGuides.insets = newValue
            parent.contentInset = newValue
        } get {
            return parent.contentInset
        }
    }
}

private extension BarLayout {
    
    /// Update any constraints that are needed to satisfy a new ContentMode.
    ///
    /// - Parameter contentMode: New ContentMode to display.
    func update(for contentMode: ContentMode) {
        switch contentMode {
        case .fit:
            self.widthConstraint = container.widthAnchor.constraint(equalTo: insetGuides.content.widthAnchor)
            widthConstraint?.isActive = true
            
        default:
            widthConstraint?.isActive = false
        }
    }
}
