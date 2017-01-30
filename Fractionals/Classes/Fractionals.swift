//
//  Fractionals.swift
//  Pods
//
//  Created by Hesham Salman on 1/30/17.
//
//

import Foundation


/*
 Fractionals by Farey Chain: Fast Continued Fraction Algorithm
 Original Paper: https://www.maa.org/sites/default/files/pdf/upload_library/22/Allendoerfer/1982/0025570x.di021121.02p0002y.pdf

 Explanation:
 `X` = original decimal.
 Assumptions: `X` > 0, `X` is not an exact integer.

 Recursive sequences: `Z(i)`, `D(i)`.
 Non-recusive sequence: `N(i)`.

 The fraction `N(i) / D(i)` will approximate to the original decimal `X`.
 The sequence `Z(i)` is related to the continuous fraction approximation to X and is otherwise
 used only to help find the `D(i)`.

 For the values i = 0 and i = 1:
 `Z(0)` = undefined.
 `Z(1)` = `X`

 `D(0)` = 0
 `D(1)` = 1

 For i = 1,2,3... we calculate the following values in the order of Z, then D, and finally N.

 Z(i+1) = 1 / (Z(i) - Int(Z(i))
 D(i+1) = D(i) * Int(Z(i+1) + D(i-1)
 N(i+1) = Round(X * D(i+1))

 Where `Round()` rounds to the nearest integer.


 Limitations:
 - Acceptable error too high and you may stop one iteration short of the "true" answer
 - Value ceiling too high and you may start getting abnormal results
 - Because of how floats are stored, you may approximate on the tail data of the float:
 - When you, for example perform `2.0 * 1.5`, your answer may actually be stored as 3.0000...191
 - If you set your value ceiling too high and your acceptable error too low, you may end up with a very large numerator and denominator.
 - Input numbers must have at least 6 significant digits after the decimal. If you're using calculated values this is fine. Otherwise, 0.333 may read as 333/1000 instead of the intended 1/3.

 */

internal struct Fractional {
    let numerator: Int
    let denominator: Int
}

internal func fractify(decimalValue: Double) -> Fractional {
    return fractify(targetValue: decimalValue, z: decimalValue, n: round(decimalValue), d: 1)
}

private func fractify(targetValue: Double, z: Double, n: Double, d: Double, oldD: Double = 0) -> Fractional {
    let acceptableError: Double = 0.0000001
    let valueCeiling: Double = 10000
    // Sanity check
    guard targetValue >= 0.0 else { fatalError("Only supports positive numbers") }
    // Make sure it's not a whole number
    guard targetValue != floor(targetValue) else { return Fractional(numerator: Int(targetValue), denominator: 1) }
    // Make sure it's not zero being passed in
    guard targetValue != 0.0 else { return Fractional(numerator: 0, denominator: 1) }

    // Stop condition
    guard z - floor(z) > acceptableError else { return Fractional(numerator: Int(n), denominator: Int(d)) }
    let newZ = 1 / (z - floor(z)) ; print("newZ: \(newZ)")
    let newD = d * floor(newZ) + oldD ; print("newD: \(newD)")
    let newN = round(targetValue * newD); print("newN: \(newN)")
    guard newD < valueCeiling, newN < valueCeiling else { return Fractional(numerator: Int(n), denominator: Int(d)) }

    return fractify(targetValue: targetValue, z: newZ, n: newN, d: newD, oldD: d)
}
