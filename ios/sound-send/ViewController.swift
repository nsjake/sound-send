//
//  ViewController.swift
//  Sound-Send3.0
//
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet
    var tableView: UITableView!
    var arr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view, typically from a nib.
        let myURL: String = "http://localhost:5000/channelmanager/create/apple200/12345"
        let myURL2: String = "http://localhost:5000/channelmanager/create/apple400/12345"
        let myURL3: String = "http://localhost:5000/channelmanager/active"
        makeHTTPCall(requestURL: myURL)
        makeHTTPCall(requestURL: myURL2)
        makeHTTPCall(requestURL: myURL3)
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeHTTPCall(requestURL: String) {
        let myURL: URL = URL(string: requestURL)!
        let urlRequest = URLRequest(url: myURL)
        var responseString: String = ""
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            
            responseString = String(data: data!, encoding: String.Encoding.utf8)!
            print ("responseString=\(responseString)")
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print ("It worked!")
                responseString = responseString.replacingOccurrences(of: "\"", with: "")
                responseString = responseString.replacingOccurrences(of: "[", with: "")
                responseString = responseString.replacingOccurrences(of: "]", with: "")
                self.arr = responseString.components(separatedBy: ", ")
                for i in 0...self.arr.count-1 {
                    self.tableView.reloadData()
                    print(self.arr[i])
                }
                print("LENGTH: \(self.arr.count)")
                
            }
            else {
                print ("error=\(error)")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.arr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected cell #\(indexPath.row)!\n")
        // Add implementation for next screen here.
    }
}
