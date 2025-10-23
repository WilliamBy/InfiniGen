for ALPHA in 1 2 3 4 5 6 7 8 9
do
  CMD="--model facebook/opt-6.7b --percent 100 0 0 100 100 0 --overlap false --gpu-batch-size 8 --num-gpu-batches 1 --prompt-len 1920 --gen-len 128 --warmup-input-path pg19_firstbook.txt --test-input-path pg19_firstbook.txt"
  CMD=$CMD" --alpha $ALPHA --partial-weight-ratio 0.2 --max-num-kv 409"
  python -m flexgen.infinigen.flex_opt $CMD
done
