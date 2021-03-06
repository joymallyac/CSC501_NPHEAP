# This is the script to run these programs, this script will accept 4 arguments, number_of_objects, max_size_of_objects, feature_combinations, number_of_processes
# feature_combination takes the value between 3 and 5.
number_of_objects=$1 
max_size_of_objects=$2 
feature_combinations=$3 
number_of_processes=$4
sudo insmod kernel_module/npheap.ko
sudo chmod 777 /dev/npheap
echo "Test: $number_of_objects $feature_combinations $number_of_processes"
./benchmark/benchmark_single $number_of_objects $max_size_of_objects $feature_combinations $number_of_processes
sleep 10
number_of_log_files=`ls *log | wc -l`
if [ $number_of_log_files -eq 0 ]
then
	echo "fail"
else
	cat *.log > trace
	sort -n -k 3 trace > sorted_trace
	./benchmark/validate $number_of_objects $max_size_of_objects < sorted_trace
rm -f *.log
fi
sudo rmmod npheap
