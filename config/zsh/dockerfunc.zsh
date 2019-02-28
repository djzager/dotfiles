function vim(){
	# TODO: make this more robust
	podman run -it --rm --volume $PWD:/work:z --workdir /work vim -- "$@"
}

