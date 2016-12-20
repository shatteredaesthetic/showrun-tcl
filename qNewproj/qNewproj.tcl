#!/usr/bin/tclsh
#
#  QNEWPROJ
#

proc comp {f g x} { $f [$g $x] }

proc toRoman {i} {
    set res ""
    foreach {value roman} {
    1000 M 900 CM 500 D 400 CD 100 C 90 XC 50 L 40 XL 10 X 9 IX 5 V 4 IV 1 I} {
        while {$i>=$value} {
            append res $roman
	    incr i -$value
        }
    }
    set res
}

proc setFolders {} {
    file mkdir documentation sounds/pre-int-post sounds/show show_x32 times .script
    file mkdir sessions/previousSessions/<1.0.0 sessions/previousSessions/tech/3
    file mkdir sessions/previousSessions/tech/1 sessions/previousSessions/tech/2
    return 0
}

proc getUserSettings {} {
    set answers [list]
    foreach tag [list "Show Name" "Stage Manager (SM)" "SM Email" "Number of Acts"] {
        puts -nonewline "? $tag >"
        flush stdout
        gets stdin ans
        list append answers [list $ans]
    }
    return $answers
}

proc makeTagList n {
    set tags "Preshow|Curtain Speech|"
    if {[expr $n == 1]} {
	return [join [list $tags "Show|Eos"] ""]
    }
    if {[expr $n == 2]} {
	return [join [list $tags "Act I|Intermission|Act II|Eos"] ""]
    }
    for {set i 1} {$i <= $n} {incr i} {
	set rmn [toRoman $i]
	uplevel [string cat $tags "Act $rmn|Interval $rmn"]
    }
    lappend $tags "|Eos"
    return $tags
}

proc makeConfig lst {
    set fp [open .show_config a]
    set snd [list range start end-1]
    foreach tag $snd { puts $fp $tag }
    set num [lindex $lst end]
    puts $fp [makeTagList $num]
    close $fp
}

interp alias {} setShowConfig {} comp makeConfig getUserSettings