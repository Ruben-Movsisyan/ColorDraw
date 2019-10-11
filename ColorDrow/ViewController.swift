import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainView: MainPageView!
    
    @IBOutlet var LineColors: [UIButton]!
    @IBOutlet var backgroundColors: [UIButton]!
    
// Array of possible colors for paths and background
    var avaliableColors: [CGColor] = [#colorLiteral(red: 0, green: 0.1649639125, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    
    var paperColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
// Give the line color buttons all the CGCOlors from the avaliableColors path and setting the flags for erasing an dmoving to false
    @IBAction func lineColor(_ sender: UIButton) {
        if let lineColorNumber = LineColors.firstIndex(of: sender){
            mainView.lineColor = avaliableColors[lineColorNumber]
            mainView.erase = false
            mainView.isSelected = false
        } else{
            print("color index out of range")
        }
    }
    
// Same thing as in previous function but without chaging flags. This function is for background color
    @IBAction func backgroundColor(_ sender: UIButton) {
        if let backgroundColorNumber = backgroundColors.firstIndex(of: sender){
            paperColor = UIColor(cgColor: avaliableColors[backgroundColorNumber])
            mainView.backgroundColor! = paperColor
        } else{
            print("color index out of range")
        }
    }
    
// Set line thickness with slideer
    @IBAction func lineSize(_ sender: UISlider) {
        mainView.lineThickness = CGFloat(sender.value)
    }

// Function to draw line with the upper left pen and setting flags
    @IBAction func drawLine(_ sender: UIButton) {
        mainView.lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainView.erase = false
        mainView.isSelected = false
    }
// Same functionality as above but with different color
    @IBAction func erase(_ sender: UIButton) {
        mainView.lineColor = paperColor.cgColor
        mainView.erase = true
        mainView.isSelected = false
    }
// Set the flag for moving the paths to true
    @IBAction func MoveLine(_ sender: UIButton) {
        mainView.isSelected = true
    }
    
// Call functions for new page, undoing and redoing
    @IBAction func blankPage(_ sender: UIButton) {
        mainView.newPage()
    }
    @IBAction func previousMove(_ sender: UIButton) {
        mainView.undo()
    }
    @IBAction func nextMove(_ sender: UIButton) {
        mainView.redo()
    }
}
