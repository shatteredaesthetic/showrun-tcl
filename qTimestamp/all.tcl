# all.tcl

package require tcltest
namespace import ::tcltest::*
 
configure -verbose {skip start}
eval ::tcltest::configure $::argv
 
runAllTests

# Recursive
#
# package require tcltest
# tcltest::configure -testdir [file dirname [file normalize [info script]]]
# eval tcltest::configure $argv
# tcltest::runAllTests