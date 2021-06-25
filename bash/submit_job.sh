#!/bin/sh

submit_job ()
 {
     if [ "$#" -ne 4 ]; then
         echo "Illegal number of parameters";
         return;
     fi;
     printf "#!/bin/sh\ncd $PWD; source ~/.bashrc; \
     ${1}" | sbatch --job-name=$2 --ntasks=1 \
     --cpus-per-task=$3 --mem-per-cpu=$4 --time=10:00:00 \
     --error=$PWD/${2}.error --output=$PWD/${2}.output \
}
