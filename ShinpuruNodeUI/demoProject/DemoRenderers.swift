//
//  DemoRenderers.swift
//  ShinpuruNodeUI
//
//  Created by Simon Gladman on 04/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

import UIKit

let DemoWidgetWidth: CGFloat = 200

class DemoInputRowRenderer: SNInputRowRenderer
{
    let label = UILabel()
    let line = CAShapeLayer()
    
    override func didMoveToSuperview()
    {
        backgroundColor = UIColor.lightGrayColor()

        addSubview(label)
        layer.addSublayer(line)
  
        line.strokeColor = UIColor.whiteColor().CGColor
        line.lineWidth = 1
        
        reload()
    }
    
    override var inputNode: SNNode?
    {
        didSet
        {
            super.inputNode = inputNode
            
            updateLabel()
        }
    }
    
    override func reload()
    {
        updateLabel()
    }
    
    func updateLabel()
    {
        guard index < parentNode.demoNode?.type.inputSlots.count else
        {
            return
        }
        
        label.text = parentNode.demoNode?.type.inputSlots[index].label
        
        if let value = inputNode?.demoNode?.value
        {
            switch value
            {
            case DemoNodeValue.Number(let floatValue):
                label.text = label.text! + " \(floatValue!)"
                
            case DemoNodeValue.Color(let colorValue):
                label.text = label.text! + " " + colorValue!.getHex()
            }
            
        }
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: DemoWidgetWidth, height: SNNodeWidget.titleBarHeight)
    }
    
    override func layoutSubviews()
    {
        label.frame = bounds.insetBy(dx: 5, dy: 0)
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: 0, y: bounds.height))
        linePath.addLineToPoint(CGPoint(x: bounds.width, y: bounds.height))
        
        if index == 0
        {
            linePath.moveToPoint(CGPoint(x: 0, y: 1))
            linePath.addLineToPoint(CGPoint(x: bounds.width, y: 1))
        }
        
        line.path = linePath.CGPath
    }
}

// ----

class DemoOutputRowRenderer: SNOutputRowRenderer
{
    let label = UILabel()
    let line = CAShapeLayer()
    
    override func didMoveToSuperview()
    {
        backgroundColor = UIColor.darkGrayColor()
      
        addSubview(label)
        layer.addSublayer(line)
        
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Right
        
        line.strokeColor = UIColor.whiteColor().CGColor
        line.lineWidth = 1
        
        label.text = node?.demoNode?.outputType.typeName
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: DemoWidgetWidth, height: SNNodeWidget.titleBarHeight)
    }
    
    override func layoutSubviews()
    {
        label.frame = bounds.insetBy(dx: 5, dy: 0)
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: 0, y: 0))
        linePath.addLineToPoint(CGPoint(x: bounds.width, y: 0))
  
        line.path = linePath.CGPath
    }
}

// ----

class DemoRenderer: SNItemRenderer
{
    let label = UILabel()
    let line = CAShapeLayer()
    
    override func didMoveToSuperview()
    {
        addSubview(label)
        layer.addSublayer(line)
        
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.Center
        
        line.strokeColor = UIColor.whiteColor().CGColor
        line.lineWidth = 1
        
        updateLabel()
    }
    
    override var node: SNNode?
    {
        didSet
        {
            updateLabel()
        }
    }
    
    override func reload()
    {
        updateLabel()
    }
    
    func updateLabel()
    {
        if let value = node?.demoNode?.value, type = node?.demoNode?.type
        {
            switch value
            {
            case DemoNodeValue.Number(let floatValue):
                label.text = "\(type) \n\(floatValue)"
                backgroundColor = type.isOperator ? UIColor.blueColor() : UIColor.redColor()
                
            case DemoNodeValue.Color(let colorValue):
                label.text = colorValue?.getHex()
                backgroundColor = colorValue
            }
        }
    }
    
    override func layoutSubviews()
    {
        label.frame = bounds
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: 0, y: 0))
        linePath.addLineToPoint(CGPoint(x: bounds.width, y: 0))
        
        line.path = linePath.CGPath
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: DemoWidgetWidth, height: DemoWidgetWidth)
    }
}
