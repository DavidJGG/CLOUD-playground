# Set-up
Note: you can install it globaly or localy, in this case is local instalation: cdk-local-install/**
- configure credentials
    - sso
    - cli 
    - etc
- install cdk
- npm install aws-cdk
    - .\node_modules\.bin\cdk --version
    - .\node_modules\.bin\cdk bootstrap aws://ACCOUNT-NUMBER/REGION
    - to uninstall: npm uninstall aws-cdk
# Creating the app
- create an empty folder
- **init app** ..\cdk-local-install\node_modules\.bin\cdk init app --language javascript
- **list stacks** ..\cdk-local-install\node_modules\.bin\cdk ls
- **main app** hello-cdk\lib\hello-cdk-stack.js
- **Generate cloud formation** ..\cdk-local-install\node_modules\.bin\cdk synth
- **Deploy** ..\cdk-local-install\node_modules\.bin\cdk deploy