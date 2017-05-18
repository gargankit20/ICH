import Foundation
import UIKit

func validateEmail(_ email:String)->Bool
{
    let emailRegex="[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,7}"
    let emailTest=NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with:email)
}

func createAlert(_ message:String)->UIAlertController
{
    let alertController=UIAlertController(title:"Message", message:message, preferredStyle:.alert)
    alertController.addAction(UIAlertAction(title:"OK", style:.cancel, handler:nil))
    return alertController
}
