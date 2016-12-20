package require textutil
namespace import ::textutil::splitx

proc wrapItem {wrapper item} { return "<$wrapper>$item</$wrapper>" }
interp alias {} wrapTH {} wrapItem th
interp alias {} wrapTR {} wrapItem tr
interp alias {} wrapTD {} wrapItem td

proc tdWrapper lst {
    if {[llength $lst] == 5} {
	set f [list [lindex $lst 0] [lindex $lst 1]]
	set l [list $f [lindex $lst 2] [lindex $lst 3] [lindex $lst 4]]
	return [map wrapTD $l]
    } elseif {[llength $lst] < 5} {
	return [map wrapTD $lst]
    }
}

interp alias {} makeEmailLine {} comp wrapTR tdWrapper

proc buildTable tup {
    set labels [map splitx [lindex $tup 0]]
    set header [wrapTR [map wrapTH $labels]]
    set blines [map makeEmailLine [map splitx [lindex $tup 1]]]
    set ebody [string cat {*}$blines]
    return [wrapItem table "$header$ebody"]
}

proc tableSplit lst { return [list [lindex $lst 0] [lrange $lst 2 end]] }

interp alias {} makeEmailBody {} comp buildTable tableSplit

proc emailBody {sm path} {
    set content [makeEmailBody [splitLines $path]]
    set bdy [string cat "<p>Hey $sm, here are the times:</p><hr>" $content]
    return [join [list "<html>" "<body>" $bdy "</body>" "</html>"] \n]
}

proc makeMailHeader cfg {
    set d [clock format [clock seconds] -format "%D"]
    set sub [string cat "Times: " [lindex $cfg 0] " - " $d]
    set subj [string cat "Subject: " $sub]
    set from "From: shatteredaesthetic@gmail.com"
    set to [string cat "To: " [lindex $cfg 2]]
    set ehead [list $from $to $subj "Mime-Version: 1.0" "Content-Type: text/html"]
    return [join $ehead \n]
}

proc makeEmail {cfg msg} {
    set header [makeMailHeader $cfg]
    set bdy [emailBody [lindex $cfg 1] $msg]
    return [string cat $header \n $bdy]
}

proc sendEmail {cfg msg} {
    set email [makeEmail $cfg $msg]
    exec echo $email | sendmail -t
    set tmp [open "_tmp.txt" w]
    puts $tmp $email
    close $tmp
}