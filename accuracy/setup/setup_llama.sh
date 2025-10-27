#!/bin/bash

# ========= InfiniGen ============
# generate skewing matrices for llama
python gen_llama_skewing_matrix.py \
--model "/data/ckpts/llama-2-13b" \
--output "${CKPTS}/skewing_matrix" 


# generate partial weight matrices for prediction
PARTIAL_RATIO=0.2
# llama
for size in 13b;do
  python gen_partial_weight.py \
    --skewing_matrix_path "${CKPTS}/skewing_matrix/llama-2-${size}.pt" \
    --model "/data/ckpts/llama-2-13b" \
    --model_type "llama" \
    --partial_weight_ratio $PARTIAL_RATIO \
    --output "${CKPTS}/weights"
done
