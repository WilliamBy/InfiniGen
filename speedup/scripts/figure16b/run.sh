for SCHEME in "original" "int4" "h2o" "infinigen"
do
  if [ "$SCHEME" = "int4" ]
  then
    MODULE=flexgen.flex_opt
  else
    MODULE=flexgen.${SCHEME}.flex_opt
  fi

  for MODEL in "opt-6.7b" "opt-13b"
  do
    CMD="--model facebook/$MODEL"
    if [ "$MODEL" = "opt-30b" ]
    then
      CMD=$CMD" --percent 70 30 0 100 100 0"
    else
      CMD=$CMD" --percent 100 0 0 100 100 0"
    fi
    CMD=$CMD" --overlap false --gpu-batch-size 4 --num-gpu-batches 1 --prompt-len 1920 --gen-len 128 --warmup-input-path pg19_firstbook.txt --test-input-path pg19_firstbook.txt"
    if [ "$SCHEME" = "int4" ]
    then
      CMD=$CMD" --compress-cache"
    elif [ "$SCHEME" = "h2o" ]
    then
      CMD=$CMD" --max-num-kv 409 --hh-ratio 0.1 --hh-all"
    elif [ "$SCHEME" = "infinigen" ]
    then
      CMD=$CMD" --alpha 4 --partial-weight-ratio 0.2 --max-num-kv 409"
    fi
    python -m $MODULE $CMD
  done
done
