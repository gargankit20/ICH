import Foundation
import UIKit

let SERVER_URL="http://ich-auapp.com/ICH/ws/"

let session=URLSession.shared

func hasInternetConnect()->Bool
{
    return Reachability()!.isReachable
}

func sendRequest(endPoint:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let alert=UIAlertView()
    alert.title="Message"
    alert.addButton(withTitle:"OK")
    
    if(hasInternetConnect())
    {
        let url=URL(string:"\(SERVER_URL)\(endPoint)")!
        
        let request=URLRequest(url:url)
        
        let dataTask=session.dataTask(with:request, completionHandler:
            {(data, response, error) in
                
                DispatchQueue.main.async
                    {
                        let jsonData:NSDictionary?
                        
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

func customerRegistration(_ email:String, _ password:String, _ username:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="email=\(email)&password=\(password)&username=\(username)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest(endPoint:"customerRegistration.php?\(endPoint)", completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func customerLogin(_ email:String, _ password:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="customerLogin.php?email=\(email)&password=\(password)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func supplierLogin(_ email:String, _ password:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="supplierLogin.php?email=\(email)&password=\(password)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func getPromotions(completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getPromotions.php?supplier_id=1"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func addPromotion(_ productName:String, _ discount:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="product_name=\(productName)&discount=\(discount)&supplier_id=1".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest(endPoint:"addPromotion.php?\(endPoint)", completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func deletePromotion(_ promotionID:Int, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="deletePromotion.php?promotion_id=\(promotionID)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func editPromotion(_ productName:String, _ discount:String, _ promotionID:Int, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="product_name=\(productName)&discount=\(discount)&promotion_id=\(promotionID)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest(endPoint:"editPromotion.php?\(endPoint)", completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func addVehicle(_ registrationNo:String, _ driverName:String, _ purchasingLimit:String, _ customerID:Int, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="registration_no=\(registrationNo)&driver_name=\(driverName)&purchasing_limit=\(purchasingLimit)&customer_id=\(customerID)&supplier_id=1".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest(endPoint:"addVehicle.php?\(endPoint)", completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func getVehicles(_ customerID:Int, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getVehicles.php?customer_id=\(customerID)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func deleteVehicle(_ vehicleID:Int, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="deleteVehicle.php?vehicle_id=\(vehicleID)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func editVehicle(_ registrationNo:String, _ driverName:String, _ purchasingLimit:String, _ vehicleID:Int, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="registration_no=\(registrationNo)&driver_name=\(driverName)&purchasing_limit=\(purchasingLimit)&vehicle_id=\(vehicleID)&supplier_id=1".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest(endPoint:"editVehicle.php?\(endPoint)", completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func getApprovalHistory(_ userID:Int, _ identifier:Int, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getApprovalHistory.php?user_id=\(userID)&identifier=\(identifier)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func getPassword(_ email:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="getPassword.php?email=\(email)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func searchVehicle(_ registrationNo:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="registration_no=\(registrationNo)".addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    
    sendRequest(endPoint:"searchVehicle.php?\(endPoint)", completionHandler:{responseData in
        completionHandler(responseData)
    })
}

func approveVehicleRegistration(_ vehicleID:Int, _ authorizationNo:String, completionHandler:@escaping(_ responseData:NSDictionary)->())
{
    let endPoint="approveVehicleRegistration.php?vehicle_id=\(vehicleID)&authorization_no=\(authorizationNo)"
    
    sendRequest(endPoint:endPoint, completionHandler:{responseData in
        completionHandler(responseData)
    })
}
