//
//  StateViewController.swift
//  Covid Tracker
//
//  Created by Dev Manaktala on 02/07/20.
//  Copyright © 2020 BeSingular. All rights reserved.
//

import Foundation
import UIKit

import Charts

let days_selected = ["7","14","21","30"]
class StateViewController: UIViewController{
    
    @IBOutlet weak var Days_Selected: UIPickerView!
    var GraphSelected: String!
    var colorScheme: UIColor!
    var Dataset:LineChartDataSet!
    var Data:LineChartData!
    @IBOutlet weak var LastUpdate: UILabel!
    
    @IBOutlet weak var LineChart: LineChartView!
    
    var button_pressed: UIButton!
    
    @IBOutlet weak var StateSelected: UILabel!
    
    var states:States!
    
    var yValues:[ChartDataEntry] = []
    
    var dates:[String] = []
    
    @IBOutlet weak var ConfirmedButton: UIButton!
    @IBOutlet weak var RecoveredButton: UIButton!
    @IBOutlet weak var DeceasedButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHighlights(button: button_pressed)
        configureButtons()
        setUpLineChart(days:7)
        Days_Selected.delegate = self
        Days_Selected.dataSource = self
    }
    
    
    func setupHighlights(button: UIButton){
        colorScheme = button_pressed.tintColor
        StateSelected.backgroundColor = colorScheme
        StateSelected.layer.cornerRadius = 10.0
        StateSelected.textAlignment = .center
        LastUpdate.text = "Last Update: \(states.states_daily[states.states_daily.count-1].date)"
        LastUpdate.center = self.view.center
        LastUpdate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        switch(button_pressed.accessibilityLabel){
        case "Delhi":
        StateSelected.text = "\(button_pressed.accessibilityLabel!)\nConfirmed: \(states.states_daily[states.states_daily.count-3].dl) Recovered:\(states.states_daily[states.states_daily.count-2].dl) Deceased:\(states.states_daily[states.states_daily.count-1].dl)"

        case "Maharashtra":
        StateSelected.text = "\(button_pressed.accessibilityLabel!)\nConfirmed: \(states.states_daily[states.states_daily.count-3].mh) Recovered:\(states.states_daily[states.states_daily.count-2].mh) Deceased:\(states.states_daily[states.states_daily.count-1].mh)"
        
        case "Tamil Nadu":
        StateSelected.text = "\(button_pressed.accessibilityLabel!)\nConfirmed: \(states.states_daily[states.states_daily.count-3].tn) Recovered:\(states.states_daily[states.states_daily.count-2].tn) Deceased:\(states.states_daily[states.states_daily.count-1].tn)"
        
        case "West Bengal":
        StateSelected.text = "\(button_pressed.accessibilityLabel!)\nConfirmed: \(states.states_daily[states.states_daily.count-3].wb) Recovered:\(states.states_daily[states.states_daily.count-2].wb) Deceased:\(states.states_daily[states.states_daily.count-1].wb)"
        
        default:
        StateSelected.text = "Error"
        }
        
    }
    
    func setUpLineChart(days: Int){
        LineChart.backgroundColor = .systemGray2
        LineChart.rightAxis.enabled = false
        
        
        let YAxis = LineChart.leftAxis
        YAxis.labelFont = .boldSystemFont(ofSize: 12)
        YAxis.setLabelCount(6, force: false)
        YAxis.labelTextColor = .white
        YAxis.axisLineColor = colorScheme
        YAxis.labelPosition = .outsideChart
        
        LineChart.xAxis.labelPosition = .bottom
        LineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        LineChart.xAxis.setLabelCount(4, force: false)
        LineChart.xAxis.axisLineColor = colorScheme
        LineChart.xAxis.labelTextColor = .white
        
        DisplayData(days: days, type: 3)
        
    }
    
    
    
    func setData(days: Int, type: Int){
        yValues.removeAll()
        let length = states.states_daily.count
        switch(button_pressed.accessibilityLabel){
        case "Delhi":
            for i in (1...days){
                yValues.append(ChartDataEntry(x: Double(i), y: Double(states.states_daily[length-(type + 3*(days-i))].dl)!))
                dates.append(states.states_daily[length-(type + 3*(days-i))].date)
            }
            print(yValues)
            break
        
        case "Maharashtra":
            for i in (1...days){
                yValues.append(ChartDataEntry(x: Double(i), y: Double(states.states_daily[length-(type + 3*(days-i))].mh)!))
                dates.append(states.states_daily[length-(type + 3*(days-i))].date)
            }
            break
            
        case "Tamil Nadu":
            for i in (1...days){
                yValues.append(ChartDataEntry(x: Double(i), y: Double(states.states_daily[length-(type + 3*(days-i))].tn)!))
                dates.append(states.states_daily[length-(type + 3*(days-i))].date)
            }
            break
            
        case "West Bengal":
            for i in (1...days){
                yValues.append(ChartDataEntry(x: Double(i), y: Double(states.states_daily[length-(type + 3*(days-i))].wb)!))
                dates.append(states.states_daily[length-(type + 3*(days-i))].date)
            }
            print(yValues)
            break
            
        default:
            print("Error")
        
        }
        
    }
    
    func configureButtons(){
        RecoveredButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        RecoveredButton.layer.cornerRadius = 10.0
        ConfirmedButton.layer.cornerRadius = 10.0
        DeceasedButton.layer.cornerRadius = 10.0
    }
    
    

    @IBAction func SelectType(_ sender: UIButton) {
        switch(sender.accessibilityLabel){
        case "confirmed":
            GraphSelected = "confirmed"
            turnOnButton(sender: sender)
            turnOffButton(sender: RecoveredButton)
            turnOffButton(sender: DeceasedButton)
        case "recovered":
            GraphSelected = "recovered"
            turnOnButton(sender: sender)
            turnOffButton(sender: ConfirmedButton)
            turnOffButton(sender: DeceasedButton)
        case "deceased":
            GraphSelected = "deceased"
            turnOnButton(sender: sender)
            turnOffButton(sender: RecoveredButton)
            turnOffButton(sender: ConfirmedButton)
        default:
            print("Error")
        }
        DisplayData(days: Int(pickerView(Days_Selected, titleForRow: Days_Selected.selectedRow(inComponent: 0), forComponent: 0)!) ?? 7 , type: sender.tag)
        
    }
    
    func DisplayData(days: Int, type: Int){
        
        setData(days: days, type: type)
        Dataset = LineChartDataSet(entries: yValues, label: GraphSelected)
        Data = LineChartData(dataSet: Dataset)
        Dataset.mode = .cubicBezier
        Dataset.fill = Fill(color: colorScheme)
        Dataset.fillAlpha = 0.6
        Dataset.drawFilledEnabled = true
        Dataset.setColor(colorScheme)
        Dataset.setCircleColor(colorScheme)

        LineChart.data = Data
        LineChart.animate(xAxisDuration: 2.5)
        LineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
    }
    
    func turnOnButton(sender: UIButton){
        sender.backgroundColor = .darkGray
        sender.setTitleColor(.white, for: .normal)
    }
    
    func turnOffButton(sender: UIButton){
        sender.backgroundColor = .lightGray
        sender.setTitleColor(.black, for: .normal)
    }
    
}
extension StateViewController:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return days_selected.count
    }
}

extension StateViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
            return days_selected[row]
    
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 16)
            
            label.text = days_selected[row]
            
        label.textAlignment = .center
        return label
}
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setUpLineChart(days: Int(days_selected[row]) ?? 7)
        print(days_selected[row])
    }
}

