import UIKit

class MainPageView: UIView {

    var path = UIBezierPath()
    var lineColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var lineThickness: CGFloat = 20
    
// Declaring "flag" variables for checking if the path must erase or it must change its location
    var erase = false
    var isSelected = false
    
// Declare variables that will be used for moving the drawn path
    var selectedLine: UIBezierPath?
    var selectedLineCoordinates: CGPoint?

// Create two arrays of pathCharacteristics struct first to collect drawn paths, second to keep paths that have been removed from the view
    lazy var existingLines = [pathCharacteristics]()
    lazy var oldExistingLines = [pathCharacteristics]()
    
// Giveing some base properties to the path which is of type UIBezierPath
    func setupPath() {
        path = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = lineThickness
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
// Call setupPath() to setup the path, append the path to the array ExistingLines
        setupPath()
        let touch = touches.first!
        path.move(to: touch.location(in: self))
        existingLines.append(pathCharacteristics(path: path, color: lineColor, mustErase: erase, selected: isSelected))
// Clear the changes that were made throughout the programme
        oldExistingLines.removeAll()
        selectedLine = nil
        selectedLineCoordinates = nil
// Write a loop that will chech each path of the array starting from the last and if I clicked the point that is contained inside the borders of the specific path
// I add that path to selectingLine variable, and add its loaction on the view to selectedLineCoordinates
        for i in (0..<existingLines.count).reversed(){
            let line = existingLines[i]
            if line.path.cgPath.copy(strokingWithWidth: line.path.lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 10.0).contains(touch.location(in: self)){
                selectedLine = line.path
                selectedLineCoordinates = touch.location(in: self)
                break
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
// Declare 2 variables responisble for keeping first touch and its location in the view
        for line in existingLines{
            let touch = touches.first!
            let touchLocation = touch.location(in: self)
            path.addLine(to: touch.location(in: self))
// Check if the programme is in the moving moda and there is some path that has already been selected
            if line.selected, selectedLine != nil{
                // Apply CGAffineTransform(translationx:y:) function on the selected path and change its coordinates to the new ones. Basically this is the part for moving the path
                selectedLine!.apply(CGAffineTransform(translationX: touchLocation.x - selectedLineCoordinates!.x, y: touchLocation.y - selectedLineCoordinates!.y))
                selectedLineCoordinates = touchLocation
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        path.addLine(to: touch.location(in: self))
// Remove the last element of the array if the line was moved, to avoid duplication of the same line in the array
        for line in existingLines{
            if line.selected{
               existingLines.removeLast()
            }
        }
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for line in existingLines {
// If it isn't in the path moving and erasing modes draw the line with specified color, if it is erasing mode draw the line with background color to give sence of eraser
            if !line.selected{
                if line.mustErase{
                    UIColor.init(cgColor: backgroundColor!.cgColor).setStroke()
                } else{
                    UIColor.init(cgColor: line.color).setStroke()
                }
                line.path.stroke()
            }
        }
    }
    
// Function that checks if struct array is not empty and if so append the last element of that array to the array for erased paths
    func undo(){
        if !existingLines.isEmpty {
            oldExistingLines.append(existingLines.removeLast())
            setNeedsDisplay()
        }
    }
    
// Does the opposite thing of the undo() function
    func redo() {
        if !oldExistingLines.isEmpty {
            existingLines.append(oldExistingLines.removeLast())
            setNeedsDisplay()
        }
    }
    
// Function that empties both arrays that may keep previously drawn paths and set white background color, i.e. give an oppportunity to blank the page
    func newPage(){
        existingLines = []
        oldExistingLines = []
        backgroundColor! = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setNeedsDisplay()
    }
}

// Structure containingt UIBezierPath, the specific color of each path and flags that check if the path is eraseing or is selected
struct pathCharacteristics{
    var path: UIBezierPath
    var color: CGColor
    var mustErase: Bool
    var selected: Bool
}
