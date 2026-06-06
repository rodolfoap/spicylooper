case "$1" in
e)	vi -p .x
	;;
"")	magick -delay 30 next.jpg -delay 30 blck.jpg -loop 0 next.gif; eog next.gif &
	magick -delay 50 play.jpg -delay 10 blck.jpg -loop 0 play.gif; eog play.gif &
	magick           stop.jpg                            stop.gif; eog stop.gif &
	;;
esac
