# snowflake.tcl --
#
#       This file implements the Tcl code for working with IDs generated by the
#       Snowflake network service.
#
# Copyright (c) 2016, Yixin Zhang
#
# See the file "LICENSE" for information on usage and redistribution of this
# file.

# References:
# https://github.com/twitter/snowflake/tree/snowflake-2010
# http://i.imgur.com/UxWvdYD.png
#
# 64-bit ID format:
# Milliseconds since a custom epoch -   41 bits
# Configured machine ID:            -   10 bits
# Sequence number                   -   12 bits

namespace eval discord {
    variable Epoch 1420070400000
}

# getSnowflakeUnixTime --
#
#       Extract timestamp from a Snowflake ID.
#
# Arguments:
#       snowflake   Snowflake ID.
#       epoch       (optional) custom epoch. Defaults to 0.
#
# Results:
#       Returns a Unix timestamp in milliseconds.

proc getSnowflakeUnixTime { snowflake {epoch 0} } {
    if {![string is wideinteger -strict $snowflake]} {
        return -code error "Snowflake must be an integer: $snowflake"
    }
    if {![string is wideinteger -strict $epoch]} {
        return -code error "Epoch must be an integer: $epoch"
    }
    set TimeBits 41
    set MachineIdBits 10
    set SequenceNumberBits 12
    set snowflake [expr {$snowflake & 0xffffffffffffffff}]
    set time [expr {
        ($snowflake >> ($MachineIdBits + $SequenceNumberBits)) & 0x1ffffffffff}]
    return [expr {$epoch + $time}]
}
