#/bin/bash
RESULT="'wget -qO- http://localhost:8090'"
wget -q localhost:8090
if [ $? -eq 0 ] 
then
    echo 'SUCESSO - Serviço no ar!'
elif [{ $RESULT == *"Number"* }] 
then
    echo 'SUCESSO - Numero de visitas'
    echo $RESULT
else
    echo 'FALHA - Numero de visistas'
    exit 1
fi