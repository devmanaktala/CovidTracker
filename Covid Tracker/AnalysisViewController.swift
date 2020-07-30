//
//  AnalysisViewController.swift
//  Covid Tracker
//
//  Created by Dev Manaktala on 05/07/20.
//  Copyright © 2020 BeSingular. All rights reserved.
//

import Foundation
import Charts
import UIKit



class AnalysisViewController: UIViewController{
    @IBOutlet weak var Options: UIPickerView!
    @IBOutlet weak var AnalysisChart: BarChartView!
    
    @IBOutlet weak var AnalyseButton: UIButton!
    
    
    var states:States!
    
    var yValues1:[BarChartDataEntry] = []
    var yValues2:[BarChartDataEntry] = []
    var dates:[String] = []
    
    let groupSpace = 0.4
    let barSpace = 0.2
    let barWidth = 1.0
    
    let states_used = ["Delhi", "Maharashtra", "Tamil Nadu", "West Bengal"]
    let data_type = ["Confirmed", "Recovered", "Deceased"]
    
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        AnalyseButton.layer.cornerRadius = 10.0
        Options.delegate = self
        Options.dataSource = self
    }
    @IBAction func AnalysePressed(_ sender: Any) {
        print("Pressed")
        let State1 = pickerView(Options, titleForRow: Options.selectedRow(inComponent: 0), forComponent: 0) ?? "Error1"
        let State2 = pickerView(Options, titleForRow: Options.selectedRow(inComponent: 1), forComponent: 1) ?? "Error2"
        let type = Options.selectedRow(inComponent: 2)
        
        print(State1)
        print(State2)
        print(type)
        
        if State1 == State2{
            return
        }
        
        AnalysisChart.backgroundColor = .systemGray2
        AnalysisChart.rightAxis.enabled = false
        
        let YAxis = AnalysisChart.leftAxis
        YAxis.labelFont = .boldSystemFont(ofSize: 12)
        //YAxis.setLabelCount(6, force: false)
        YAxis.labelTextColor = .white
        YAxis.axisLineColor = .blue
        YAxis.labelPosition = .outsideChart
        
        AnalysisChart.xAxis.labelPosition = .bottom
        AnalysisChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        //AnalysisChart.xAxis.setLabelCount(4, force: false)
        AnalysisChart.xAxis.axisLineColor = .blue
        AnalysisChart.xAxis.labelTextColor = .white
        
        
        setData(statename: State1, days: 14, type: (3-type), yVals: &yValues1)
        setData(statename: State2, days: 14, type: (3-type), yVals: &yValues2)
       
        let set1 = BarChartDataSet(entries: yValues1, label: State1)
        let set2 = BarChartDataSet(entries: yValues2, label: State2)
        
        set1.setColor(.systemOrange)
        set2.setColor(.systemIndigo)
        
        let data = BarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        data.barWidth = barWidth
        
        data.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)

        AnalysisChart.data = data
    }
    
    
    
    func setData(statename: String, days: Int, type: Int, yVals: inout [BarChartDataEntry]){
        yVals.removeAll()
        switch(statename){
            case "Delhi":
                for i in (1...days){
                    yVals.append(BarChartDataEntry(x: Double(i), y: Double(states.states_daily[states.states_daily.count-(type + 3*(days-i))].dl)!))
                    dates.append(states.states_daily[states.states_daily.count-(type + 3*(days-i))].date)
                }
                print(yVals)
                break
            
            case "Maharashtra":
                for i in (1...days){
                    yVals.append(BarChartDataEntry(x: Double(i), y: Double(states.states_daily[states.states_daily.count-(type + 3*(days-i))].mh)!))
                    dates.append(states.states_daily[states.states_daily.count-(type + 3*(days-i))].date)
                }
                break
                
            case "Tamil Nadu":
                for i in (1...days){
                    yVals.append(BarChartDataEntry(x: Double(i), y: Double(states.states_daily[states.states_daily.count-(type + 3*(days-i))].tn)!))
                    dates.append(states.states_daily[states.states_daily.count-(type + 3*(days-i))].date)
                }
                break
                
            case "West Bengal":
                for i in (1...days){
                    yVals.append(BarChartDataEntry(x: Double(i), y: Double(states.states_daily[states.states_daily.count-(type + 3*(days-i))].wb)!))
                    dates.append(states.states_daily[states.states_daily.count-(type + 3*(days-i))].date)
                }
                print(yVals)
                break
                
            default:
                print("Error")
            
        }
            
    }
        
}
    

extension AnalysisViewController:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == Options{
            return 3
        }
        else{
            return 1
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == Options{
            if component == 0 || component == 1{
                return states_used.count
            }
            else {
                return data_type.count
            }
        }
        else{
            return days_selected.count
        }
    }
}

extension AnalysisViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == Options{
            if component == 0 || component == 1{
                return states_used[row]
            }
            else {
                return data_type[row]
            }
        }
        else {
            return days_selected[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 16)
            if pickerView == Options{
                if component == 0 || component == 1{
                    label.text =  states_used[row]
                }
                else{
                    label.text =  data_type[row]
                }
            }
            else{
                label.text = days_selected[row]
            }
        label.textAlignment = .center
        return label
}
    
}
