//
//  DummyJson.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 19.02.2023.
//

import Foundation

class DummyJson {
    static let jsonData = """
{
  "l": [
    {
        "tke": "XU100.I.BIST",
        "clo": "18:10:12",
        "ddi": "18,26",
        "las": "5.026,83",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XU050.I.BIST",
        "clo": "18:10:12",
        "ddi": "20,17",
        "las": "4.533,37",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XU030.I.BIST",
        "clo": "18:10:10",
        "ddi": "24,70",
        "las": "5.635,18",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "USD/TRL",
        "ddi": "0,0148",
        "las": "18,8621",
        "clo": "23:59:44",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "EUR/TRL",
        "ddi": "0,0248",
        "las": "20,1738",
        "clo": "23:59:56",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "EUR/USD",
        "ddi": "0,00209",
        "las": "1,06944",
        "clo": "23:59:58",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XAU/USD",
        "ddi": "5,88",
        "las": "1.841,86",
        "clo": "23:59:57",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "XGLD",
        "clo": "23:59:57",
        "ddi": "3,992",
        "las": "1.117,060",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    },
    {
        "tke": "BRENT",
        "ddi": "-1,99",
        "las": "83,15",
        "clo": "01:59:00",
        "pdd": "-0.02",
        "hig": "34.567",
        "low": "21.435"
    }
  ],
  "z": "0"
}
""".data(using: .utf8)!
}


