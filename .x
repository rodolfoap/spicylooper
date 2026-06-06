case "$1" in
e)	vi -p .x
	;;
p)	adb push output/SpicyLooper-debug.apk /storage/self/primary/SpicyLooper/
	adb push /home/rap/muv/spcy/*.spl /storage/self/primary/SpicyLooper/
	;;
f)	./fader.bash $2;
	;;
b)	docker image inspect spicylooper-builder:latest &>/dev/null || ./build-builder.sh
	./build-apk.sh
	;;
"")	true
	;;
esac
