#!/bin/bash

CWD=${PWD}
cd ../transformers/src/transformers/models

for model in llama opt;do
  if [ -f ${model}/modeling_${model}.py ] then
    mv ${model}/modeling_${model}.py ${model}/modeling_${model}_orig.py
  fi
done

cd ${CWD}

MODEL_DIR=/root/.cache/modelscope/hub/models

# ========= InfiniGen ============
# generate opt models w/skewing
for size in 6.7b 13b;do
  python gen_opt_model.py \
    --model "/root/.cache/modelscope/hub/models/facebook/opt-${size}" \
    --output "${CKPTS}/opt-model"
done

# generate skewing matrices for llama
python gen_llama_skewing_matrix.py \
--model "/model/ModelScope/shakechen/Llama-2-13b" \
--output "${CKPTS}/skewing_matrix" 


# generate partial weight matrices for prediction
PARTIAL_RATIO=0.2
# opt
for size in 6.7b 13b;do
  python gen_partial_weight.py \
    --our_model_path "${CKPTS}/opt-model/opt-${size}" \
    --model "/root/.cache/modelscope/hub/models/facebook/opt-${size}" \
    --model_type "opt" \
    --partial_weight_ratio $PARTIAL_RATIO \
    --output "${CKPTS}/weights"
done

# llama
for size in 13b;do
  python gen_partial_weight.py \
    --skewing_matrix_path "${CKPTS}/skewing_matrix/llama-2-${size}.pt" \
    --model "/model/ModelScope/shakechen/Llama-2-${size}" \
    --model_type "llama" \
    --partial_weight_ratio $PARTIAL_RATIO \
    --output "${CKPTS}/weights"
done


# ========= w/o skewing (figure 13)
PARTIAL_RATIO=0.1
python gen_partial_weight.py \
  --our_model_path "${CKPTS}/opt-model/opt-6.7b" \
  --model "/root/.cache/modelscope/hub/models/facebook/opt-6.7b" \
  --model_type "opt" \
  --partial_weight_ratio $PARTIAL_RATIO \
  --output "${CKPTS}/weights"

python gen_opt_model.py \
  --model "/root/.cache/modelscope/hub/models/facebook/opt-6.7b" \
  --output "${CKPTS}/opt-model-no-skew" \
  --no_skewing

python gen_partial_weight.py \
  --our_model_path "${CKPTS}/opt-model-no-skew/opt-6.7b" \
  --model "/root/.cache/modelscope/hub/models/facebook/opt-6.7b" \
  --model_type "opt" \
  --partial_weight_ratio $PARTIAL_RATIO \
  --output "${CKPTS}/weights-no-skew"

# ========= partial weight sweep (figure 17)
for PARTIAL_RATIO in 0.1 0.4 0.6 0.8 1.0;do
  python gen_partial_weight.py \
    --our_model_path "${CKPTS}/opt-model/opt-13b" \
    --model "/root/.cache/modelscope/hub/models/facebook/opt-13b" \
    --model_type "opt" \
    --partial_weight_ratio $PARTIAL_RATIO \
    --output "${CKPTS}/weights"
done
