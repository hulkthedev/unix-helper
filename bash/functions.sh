function print_error_and_exit
{
	echo "---------------------" 1>&2
	echo "---------------------" 1>&2
	echo "ERROR -> "$1 1>&2
	echo "---------------------" 1>&2
	echo "---------------------" 1>&2
	echo "" 1>&2

	exit 1
}


function print_warning
{
	echo "---------------------" 1>&2
	echo "WARNING -> "$1 1>&2
	echo "---------------------" 1>&2
	echo "" 1>&2
}


function print_info
{
	echo $1
	echo ""
}


function print_section_title
{
	echo "-----------------------------------------------------------"
	echo $1
	echo ""
}


function http_get
{
	write_out_param="--write-out ;%{http_code}"
	if [ "$2" == "no-write-out" ];then
    	write_out_param=""
	fi

	curl $write_out_param \
    	--silent \
    	--raw \
    	"$1"
}


function http_put
{
	data_param="--data"
	if [ "$3" == "data-binary" ];then
    	data_param="--data-binary"
	fi


	http_put_result=`curl \
    	-X PUT \
    	--silent \
    	--write-out ";%{http_code}" \
    	--header "Content-Type:application/json" \
    	$data_param "$2" \
    	-v \
    	"$1" `

	echo $http_put_result
}


function http_delete
{
	curl -X DELETE \
    	--write-out ";%{http_code}" \
    	--silent \
    	"$1"
}


function validate_string
{
	if [ -z "$1" ]; then
    	print_error_and_exit "$2"
	fi

	echo $1
}


function file_exists
{
	if [ ! -f "$1" ]; then
    	print_error_and_exit "$2"
	fi

	echo $1
}


function in_array
{
	local needle=$1
	shift
	local haystack=("${@}")
	local val_found=0

	for ((i=0; i < ${#haystack[*]}; i++)) {
    	if [[ ${haystack[i]} == "$needle" ]]; then
        	val_found=1
        	break
    	fi
	}

	echo $val_found
}


function check_file_for_errors
{
	if  grep -q -i 'ERROR:' "$1" ; then
    	print_error_and_exit "$2"
	fi
}


function init_git_repo
{
	local repo=$1

	git init
	git config user.email "bamboo@arvato-cp.com"
	git config user.name "${bamboo_DOCKER_DEPL_ARTIFACTS_REPO_USER}"
	git remote add origin  "https://${bamboo_DOCKER_DEPL_ARTIFACTS_REPO_USER}:${bamboo_DOCKER_DEPL_ARTIFACTS_REPO_PASSWORD}@${repo}"
}


function checkout_git_branch
{
	local br_name=$1

	if [[ $(git ls-remote --heads origin $br_name | wc -l) == 1 ]]; then
    	git fetch origin "${br_name}"
    	git checkout -b "$br_name" "origin/${br_name}"
	else
    	git checkout -b "$br_name"
	fi
}