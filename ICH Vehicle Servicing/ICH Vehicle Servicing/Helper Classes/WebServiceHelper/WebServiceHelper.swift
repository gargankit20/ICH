import Foundation
import UIKit

let SERVER_URL="http://ich-auapp.com/ICH/ws/"

let session=URLSession.shared
let appDelegate=UIApplication.shared.delegate as! AppDelegate

func hasInternetConnect()->Bool
{
    return Reachability()!.isReachable
}

func sendRequest(_ endPoint:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let alert=UIAlertView()
    alert.title="Message"
    alert.addButton(withTitle:"OK")
    
    if(hasInternetConnect())
    {
        appDelegate.window?.isUserInteractionEnabled=false
        
        let url=URL(string:"\(SERVER_URL)\(endPoint)")!
        
        let request=URLRequest(url:url)
        
        let dataTask=session.dataTask(with:request, completionHandler:
            {(data, response, error) in
                
                DispatchQueue.main.async
                    {
                        let jsonData:NSDictionary?
                        
                        appDelegate.window?.isUserInteractionEnabled=true
                        
                        if(data==nil)
                        {
                            alert.message="Weak Internet Connection"
                            alert.show()
                            return
                        }
                        else
                        {
                            jsonData=try! JSONSerialization.jsonObject(with:data!, options:.mutableContainers) as? NSDictionary
                        }
                        
                        completionHandler(jsonData!)
                }
        })
        
        dataTask.resume()
    }
    else
    {
        alert.message="No Internet Connection"
        alert.show()
    }
}

func customerRegistration(_ email:String, _ password:String, _ username:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="email=\(email)&password=\(password)&username=\(username)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest("customerRegistration.php?\(endPoint)", {responseData in
        completionHandler(responseData)
    })
}

func customerLogin(_ email:String, _ password:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="email=\(email)&password=\(password)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest("customerLogin.php?\(endPoint)", {responseData in
        completionHandler(responseData)
    })
}

func supplierLogin(_ email:String, _ password:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="supplierLogin.php?email=\(email)&password=\(password)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func getPromotions(_ supplierID:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getPromotions.php?supplier_id=\(supplierID)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func addPromotion(_ productName:String, _ discount:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="product_name=\(productName)&discount=\(discount)&supplier_id=1".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest("addPromotion.php?\(endPoint)", {responseData in
        completionHandler(responseData)
    })
}

func deletePromotion(_ promotionID:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="deletePromotion.php?promotion_id=\(promotionID)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func editPromotion(_ productName:String, _ discount:String, _ promotionID:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="product_name=\(productName)&discount=\(discount)&promotion_id=\(promotionID)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest("editPromotion.php?\(endPoint)", {responseData in
        completionHandler(responseData)
    })
}

func addVehicle(_ registrationNo:String, _ driverName:String, _ purchasingLimit:String, _ customerID:Int, _ supplierID:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="registration_no=\(registrationNo)&driver_name=\(driverName)&purchasing_limit=\(purchasingLimit)&customer_id=\(customerID)&supplier_id=\(supplierID)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest("addVehicle.php?\(endPoint)", {responseData in
        completionHandler(responseData)
    })
}

func getVehicles(_ customerID:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getVehicles.php?customer_id=\(customerID)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func deleteVehicle(_ vehicleID:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="deleteVehicle.php?vehicle_id=\(vehicleID)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func editVehicle(_ registrationNo:String, _ driverName:String, _ purchasingLimit:String, _ vehicleID:Int, _ supplierID:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="registration_no=\(registrationNo)&driver_name=\(driverName)&purchasing_limit=\(purchasingLimit)&vehicle_id=\(vehicleID)&supplier_id=\(supplierID)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest("editVehicle.php?\(endPoint)", {responseData in
        completionHandler(responseData)
    })
}

func getApprovalHistory(_ userID:Int, _ identifier:Int, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getApprovalHistory.php?user_id=\(userID)&identifier=\(identifier)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func getSuppliers(_ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    sendRequest("getSuppliers.php", {responseData in
        completionHandler(responseData)
    })
}

func getPassword(_ email:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getPassword.php?email=\(email)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func searchVehicle(_ registrationNo:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="searchVehicle.php?registration_no=\(registrationNo)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}

func approveVehicleRegistration(_ supplierID:Int, _ customerID:Int, _ authorizationNo:String, _ completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="approveVehicleRegistration.php?customer_id=\(customerID)&authorization_no=\(authorizationNo)&supplier_id=\(supplierID)"
    
    sendRequest(endPoint, {responseData in
        completionHandler(responseData)
    })
}
