#!/bin/bash

# ----------------- validate_input (Roge) ------------------------ #
# ----------------- Purpose: Check if the input is a series of positive integers (3 or more) ---- #
# ----------------- Input: Some text/number... ------------------- #
# ----------------- Output:
# ----------------------- 1 if the input is a positive series of integers (3 or more)
# ----------------------- 0 otherwise 
# ---------------------------------------------------------------- #
validate_input () {
	# If the series length is less than 3, then it's invalid
	if [ "$#" -lt 3 ]
	then
		echo 0
		return
	fi

	local format="^[0-9]+$"	# The expected format for each argument
	for arg in "$@"		# Loop over all the arguments
	do
		# Check if the argument is equal to the format using regex
		if [[ ! $arg =~ $format ]] || [ $arg -eq 0 ]
		then
			echo 0
			return
		fi
	done
	echo 1
}

# ----------------- get_input (Roge) --------------------------------------- #
# ----------------- Purpose: Get input from user until Enter is pressed ---- #
# ----------------- Input: Series of values if the user input any ---------- #
# ----------------- Output:
# ----------------------- A series of positive integers -------------------- # 
get_input () {
	local args=("$@")
	# Check if the args passed are a valid series.
	local test=$(validate_input "${args[@]}")

	# Keep taking input until a valid series is entered
	while [ $test -eq 0 ]
	do
		read -p "Enter a series of values: " -a args
		test=$(validate_input "${args[@]}")
	done

	echo "${args[@]}"
}

#-----------SORTEDARRAY--------------
sort_series() {
    # Sort the input arguments
    local arr="$@"
    sorted_series=$(echo "$arr" | tr ' ' '\n' | sort -n | tr '\n' ' ')
    # Print the sorted series
    echo "$sorted_series"
}

#---------------MAX------------------
MAX() {
local max=0
for num in "$@"
do
	if [ $max -lt $num ]
	then
		max=$num
	fi
done
echo $max
}


#---------------MIN------------------
MIN() {
local min=$1
for num in "$@"
do
        if [ $min -gt $num ]
        then
                min=$num
        fi
done
echo $min
}


#-------------AVERAGE----------------
AVERAGE() {
local average=0
for num in "$@"
do
	average=$(( average+num ))
done
average=$( bc <<< "scale=2;$average/$#" )
echo $average
}


#---------NUM. OF ELEMENTS-----------
NUMOFELEMENTS() {
echo "$#"
}


#-------------SUM---------------- 
SUM() {
local sum=0
for num in "$@"
do
        sum=$(( sum+num ))
done
echo $sum
}


#------------------MENU--------------------
menu() {
	args=("$@")
	while [ 0 ]
	do
		args=($(get_input "${args[@]}"))
		echo -e "a. Input Series.\nb. Display the series in the order it was entered.\nc. Display the series in sorted order \(from low to high\).\nd. Display the Max value of the series.\ne. Display the Min value of the series.\nf. Display the Average of the series.\ng. Display the Number of elements in the series.\nh.  Display the Sum of the series.\ni. Exit."
	        read -p "Option? " option
       		echo "-----------------------"
		option=$(echo $option | awk '{print tolower($0)}')
	        case $option in
       		a)
                	args=($(get_input));;
        	b)
			echo "${args[@]}";;
	        c)
			echo $(sort_series "${args[@]}");;
	        d)
			echo $(MAX "${args[@]}");;
	        e)
			echo $(MIN "${args[@]}");;
        	f)
                	echo $(AVERAGE "${args[@]}");;
	        g)
       		        echo $(NUMOFELEMENTS "${args[@]}");;
	        h)
			echo $(SUM "${args[@]}");;
		i)
			exit;;
		*)
	                echo "Invalid option"
	                ;;
	        esac
		echo "-----------------------"
	done
}



#-------testing-------

menu "$@"


