//
//  AKToneFilterAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AVFoundation

public class AKToneFilterAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: AKToneFilterParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    func setParameterImmediately(_ address: AKToneFilterParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    var halfPowerPoint: Double = 1_000.0 {
        didSet { setParameter(.halfPowerPoint, value: halfPowerPoint) }
    }

    var rampTime: Double = 0.0 {
        didSet { setParameter(.rampTime, value: rampTime) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> UnsafeMutableRawPointer! {
        return createToneFilterDSP(Int32(count), sampleRate)
    }

    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let flags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]

        let halfPowerPoint = AUParameterTree.createParameter(
            withIdentifier: "halfPowerPoint",
            name: "Half-Power Point (Hz)",
            address: AUParameterAddress(0),
            min: 12.0,
            max: 20_000.0,
            unit: .hertz,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )

        setParameterTree(AUParameterTree.createTree(withChildren: [halfPowerPoint]))
        halfPowerPoint.value = 1_000.0
    }

    public override var canProcessInPlace: Bool { get { return true; }}

}
