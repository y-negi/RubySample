//
//  ViewController.swift
//  ruby_sample
//
//  Created by 根岸裕太 on 2018/12/08.
//  Copyright © 2018年 根岸裕太. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let dataSource = ["デーモン｜小暮閣下《こぐれかっか》",
                              "エース｜清水長官《しみずちょうかん》",
                              "｜怪人松崎様《かいじんまつざきさま》"]
    
    @IBOutlet private weak var rubyTableView: UITableView! {
        didSet {
            self.rubyTableView.register(UINib(nibName: "RubyTableViewCell", bundle: nil),
                                        forCellReuseIdentifier: "RubyTableViewCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RubyTableViewCell", for: indexPath) as! RubyTableViewCell
        
        cell.rubyLabel.text = self.dataSource[indexPath.row]
        cell.rubyLabel.isUseRuby = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.cellForRow(at: indexPath) as? RubyTableViewCell {
            let attributed = cell.rubyLabel.text!.rubyAttributedString(font: cell.rubyLabel.font, textColor: cell.rubyLabel.textColor)
            // cellのラベルの上下マージンとして24を足す
            return attributed.boundingRect(with: CGSize(width: cell.rubyLabel.frame.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height + 24
        } else {
            return 44
        }
    }
    
}

