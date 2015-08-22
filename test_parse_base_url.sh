BASE_DIR=`dirname $0`

test() {

	export BASE_URL_SCHEME=unset
	export BASE_URL_HOST=unset
	export BASE_URL_PORT=unset


	$($BASE_DIR/parse_base_url.py $1)

	echo =====
	echo BASE_URL=$1
	echo BASE_URL_SCHEME=$BASE_URL_SCHEME
	echo BASE_URL_HOST=$BASE_URL_HOST
	echo BASE_URL_PORT=$BASE_URL_PORT

}

test 
test whatever
test http://host
test https://host/
test http://myhost:8000
test http://127.0.0.2:8000/
test http://some.hoist:8000/xx

