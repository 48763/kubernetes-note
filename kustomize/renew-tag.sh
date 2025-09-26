REG=""
TAG=""
 
REG_RE=$(echo "${REG}" | sed -e 's/[.\\/]/\\&/g')

sed -n -E "/${REG_RE}/{N; s/(newTag:).*/\1 ${TAG}/gp; }" kustomization.yml
