export WRKDIR=$(pwd)
export lambda_file="trading_lambda.py"
export dir_name="trading_lambda_package"

echo "Executing build.sh..."

echo "Deleting old zip directory"
rm -rf $dir_name

echo "Making new zip directory"
mkdir $dir_name

echo "Making temp directory"
mkdir temp

echo "Installing requirements into temp directory"
pip3 install --progress-bar off -r requirements.txt -t $WRKDIR/temp

echo "Copying alpaca api from temp directory into package"
cp -R $WRKDIR/temp/alpaca_trade_api $WRKDIR/$dir_name/
cp -R $WRKDIR/temp/alpaca_trade_api-0.53.0.dist-info $WRKDIR/$dir_name/

cp -R $WRKDIR/temp/requests $WRKDIR/$dir_name/
cp -R $WRKDIR/temp/requests-2.25.1.dist-info $WRKDIR/$dir_name/

cp -R $WRKDIR/temp/websockets $WRKDIR/$dir_name/
cp -R $WRKDIR/temp/websockets-8.1.dist-info $WRKDIR/$dir_name/ 

echo "Copying python file into package"
cp $WRKDIR/$lambda_file $WRKDIR/$dir_name/

echo "Removing temp directory"
rm -rf $WRKDIR/temp

echo "Finished script execution!"
