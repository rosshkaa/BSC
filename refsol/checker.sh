#!/bin/bash
EspressoTest.kt
solution_dir_name="android_solution"
test_path="../EspressoTest.kt"
test_name="EspressoTest.kt"
local_properties="local.properties"
main_activity_path=""
test_dir_path=""
user_package=""

mv solution.c solution.zip
unzip solution.zip -d $solution_dir_name

cd $solution_dir_name
rm -rf build
rm -rf app/build
rm $local_properties
echo -e "sdk.dir=${ANDROID_HOME}" >> $local_properties

bash "gradlew"
gradlew_return_code=$?            

	if [ $gradlew_return_code -eq "0" ] ; then
		echo "Build successful with code ${gradlew_return_code}"
	else
		echo "Build failed with code ${gradlew_return_code}"
		#exit 1
	fi

# connecting to emulator
adb connect 172.17.0.1:5555

# find MainActivity path
main_activity_path=$(find . -name "MainActivity.*")
# locate package
user_package=$(grep 'package' $main_activity_path)
# locate path for tests
test_dir_path=$main_activity_path
test_dir_path=$(echo $test_dir_path | sed -e 's/main/androidTest/g')
test_dir_path=$(echo $test_dir_path | sed -e 's/MainActivity.kt//g')
echo $test_dir_path

cp $test_path $test_dir_path$test_name

tmp_package=$(grep -E "(package)" $test_dir_path$test_name)
echo $test_dir_path$test_name | sed -e 's/${tmp_package}/${user_package}/g'

# run tests
bash "gradlew connectedAndroidTest --info"
# install apk
# adb push full/apk/path.apk 
# adb shell pm install -r "/data/local/tmp/com.x"

# adb push full/apk/debug-androidTest.apk /data/local/tmp/com.x.test
# adb shell pm install -r "/data/local/tmp/com.x.test"

# run test
# adb shell am instrument -w -r -e debug false -e class /full/TestPath com.android.samples.tests/android.test.InstrumentationTestRunner
echo "=== checker loaded successfully === "
