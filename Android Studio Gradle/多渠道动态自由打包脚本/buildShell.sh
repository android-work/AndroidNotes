

#首字母转大写
toFirstLetterUpper(){
  str=$1
  firstLetter=${str:0:1}
  otherLetter=${str:1}
  firstLetter=$(echo $firstLetter | tr '[a-z]' '[A-Z]')
  result=$firstLetter$otherLetter
  echo $result
  return $?
}


#获取输入渠道dimension
flavorStr=$1
buildModel=$2
buildEnv=$3
echo '输入的渠道参数是:['$flavorStr'],需要编译的model:['$buildModel'],编译环境:['$buildEnv']'
#解析渠道
array=(${flavorStr//,/})
echo '分割完需要合并的渠道名:'$array

#将渠道传递给gradle脚本
./gradlew clean

buildName=''

#配置需要编译的model
if [ ! -z "$buildModel" ]; then
  buildName=$buildModel':'
  echo '需要编译'$buildModel'模块包'
fi

buildName=$buildName'assemble'

#合并变体
for flavor in $array ; do
  flavor=$(toFirstLetterUpper $flavor)
  buildName=$buildName$flavor
done

#配置编译环境
if [ ! -z "$buildEnv" ]; then
    buildEnv=$(toFirstLetterUpper $buildEnv)
    buildName=$buildName$buildEnv
    echo '需要编译'$buildEnv'环境包'
fi

echo '合并变体：'$buildName

#执行gradle脚本
./gradlew $buildName -Pflavors=$flavorStr
