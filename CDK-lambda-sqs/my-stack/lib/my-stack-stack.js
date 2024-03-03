const { Stack, Duration } = require('aws-cdk-lib');
const lambda = require('aws-cdk-lib/aws-lambda');
const sqs = require('aws-cdk-lib/aws-sqs');
const s3 = require('aws-cdk-lib/aws-s3');
const { SqsEventSource } = require('aws-cdk-lib/aws-lambda-event-sources');

class MyStackStack extends Stack {
  /**
   *
   * @param {Construct} scope
   * @param {string} id
   * @param {StackProps=} props
   */
  constructor(scope, id, props) {
    super(scope, id, props);
    const sufixName = "my-stack-02032024";

    let sqsQueue = new sqs.Queue(this, "sqs-" + sufixName, {
      queueName: "sqs-handler-" + sufixName,
      visibilityTimeout: Duration.seconds(30),
      retentionPeriod: Duration.days(1),
      receiveMessageWaitTime: 0,
      encryption: sqs.QueueEncryption.SQS_MANAGED
    });

    let bucketS3 = new s3.Bucket(this, "my-bucket-" + sufixName, {
      bucketName: "my-bucekt-" + sufixName,
      encryption: s3.BucketEncryption.S3_MANAGED,
      versioned: false,
    });

    let lambdaHandler = new lambda.Function(this, "lamda-" + sufixName, {
      runtime: lambda.Runtime.NODEJS_LATEST,
      code: lambda.Code.fromAsset('resources/'),
      timeout: Duration.seconds(30),
      functionName: "lambda-" + sufixName,
      handler: 'lambda_code.handler',
      environment: {
        "BUCKET_NAME": bucketS3.bucketName,
        "QUEUE_URL": sqsQueue.queueUrl
      },
      //reservedConcurrentExecutions: 5,
    }
    );

    lambda.conc

    let eventSourceSQS = new SqsEventSource(sqsQueue, {
      batchSize : 2,
      maxBatchingWindow : Duration.seconds(0),
      retryAttempts : 0,
      maxConcurrency : 2,
    });
    lambdaHandler.addEventSource(eventSourceSQS);

    sqsQueue.grantConsumeMessages(lambdaHandler);
    bucketS3.grantWrite(lambdaHandler);


  }
}

module.exports = { MyStackStack }
