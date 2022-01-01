

require("LifeBoatAPILocal.Utils.LBCopy")


---@section LBInstruments LBINSTRUMENTSCLASS
LifeBoatAPI.LBInstruments = {

    ---Converts a compass value into the range [0 North => 2pi radians, clockwise]
    ---@param compass number compass value from the sensor
    ---@section LBInstruments_compassToAzimuth
    LBInstruments_compassToAzimuth = function(compass)
        return -compass % 1 * math.pi * 2
    end;
    ---@endsection


    ---Converts a tilt sensor value into the range [-pi/2 radians vertically down => 0 horizontal => +pi/2 radians vertically up ]
    ---@param tiltSensor number tilt value from the tilt sensor
    ---@return number elevation tilt as an angle in radians
    ---@section LBInstruments_tiltSensorToElevation
    LBInstruments_tiltSensorToElevation = function (tiltSensor)
        return tiltSensor * math.pi * 2
    end
    ---@endsection
};
---@endsection