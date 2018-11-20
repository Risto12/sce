#!/bin/bash

for i in {1..500}
do
   v=test$i
   cp -r test $v
   ( cd $v ; vagrant up )
done


