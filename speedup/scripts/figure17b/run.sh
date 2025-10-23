for PARTIAL_WEIGHT_RATIO in 0.1 0.2 0.4 0.6 0.8 1.0
do
  CMD="--model facebook/opt-13b --percent 100 0 0 100 100 0 --overlap false --gpu-batch-size 8 --num-gpu-batches 1 --prompt-len 1920 --gen-len 128 --warmup-input-path pg19_firstbook.txt --test-input-path pg19_firstbook.txt"
  CMD=$CMD" --alpha 4 --partial-weight-ratio $PARTIAL_WEIGHT_RATIO --max-num-kv 409"
  python -m flexgen.infinigen.flex_opt $CMD
done
