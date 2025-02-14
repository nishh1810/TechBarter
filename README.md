# tech_barter

## Remove CORS ERROR
1- Go to flutter\bin\cache and remove a file named: flutter_tools.stamp

2- Go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.

3- Find '--disable-extensions'

4- Add '--disable-web-security'

## Configuration in local flutter app
1- open edit configurations
2- Add --web-port="4002" in Additional run args