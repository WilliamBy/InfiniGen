for SCHEME in "original" "int4" "h2o" "infinigen"
do
  if [ "$SCHEME" = "int4" ]
  then
    MODULE=flexgen.flex_opt
  else
    MODULE=flexgen.${SCHEME}.flex_opt
  fi

  for PROMPT_LEN in 384 896 1408 1920
  do
    CMD="--model facebook/opt-13b --percent 100 0 0 100 100 0 --overlap false --gpu-batch-size 8 --num-gpu-batches 1 --prompt-len $PROMPT_LEN --gen-len 128 --warmup-input-path pg19_firstbook.txt --test-input-path pg19_firstbook.txt"
    if [ "$SCHEME" = "int4" ]
    then
      CMD=$CMD" --compress-cache"
    elif [ "$SCHEME" = "h2o" ]
    then
      CMD=$CMD" --max-num-kv `expr \( $PROMPT_LEN + 128 \) / 5` --hh-ratio 0.1 --hh-all"
    elif [ "$SCHEME" = "infinigen" ]
    then
      CMD=$CMD" --alpha 4 --partial-weight-ratio 0.2 --max-num-kv `expr \( $PROMPT_LEN + 128 \) / 5`"
    fi
    python -m $MODULE $CMD
  done
done
