import { PutObjectCommand, S3Client } from "@aws-sdk/client-s3"
import { SQS } from "@aws-sdk/client-sqs";
import { randomUUID } from "crypto";

//make handler to response an sqs trigger and put the message in a new file into the bucket, the bucket name is in the enviroment variable
export const handler = async (event) => {

    console.log("Iniciando proceso ....");

    const sqs = new SQS();
    const s3 = new S3Client();
    const message = event.Records.map(x => x.body).join('\n')

    console.log("Guardando en bucket ... " + process.env.BUCKET_NAME);
    const fileName = randomUUID({
        disableEntropyCache: true,
    }) + ".txt";

    await s3.send(new PutObjectCommand({
        Bucket: process.env.BUCKET_NAME,
        Key: fileName,
        Body: message
    }));

    event.Records.forEach(async (x) => {
        await sqs.deleteMessage({
            QueueUrl: process.env.QUEUE_URL,
            ReceiptHandle: x.receiptHandle
        })
    });

    console.log("Mensaje guardado en un archivo " + fileName);
}