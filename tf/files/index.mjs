// Import the entire AWS SDK package
import AWS from "@aws-sdk/client-dynamodb";

import { GetItemCommand, PutItemCommand, DeleteItemCommand, ScanCommand } from "@aws-sdk/client-dynamodb";

// Destructure the necessary components
const { DynamoDBClient } = AWS;

// Import marhsall
import { marshall } from "@aws-sdk/util-dynamodb";

// Create DynamoDB client
const dynamo = new DynamoDBClient();

// Export handler function
export const handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json"
  };

  try {
    switch (event.routeKey) {
      case "DELETE /items/{id}":
        await dynamo.send(new DeleteItemCommand({
          TableName: "api-workshop-items",
          Key: marshall({ id: event.pathParameters.id })
        }));
        body = `Deleted item ${event.pathParameters.id}`;
        break;
      case "GET /items/{id}":
        const getItemOutput = await dynamo.send(new GetItemCommand({
          TableName: "api-workshop-items",
          Key: marshall({ id: event.pathParameters.id })
        }));
        body = getItemOutput.Item;
        break;
      case "GET /items":
        const scanOutput = await dynamo.send(new ScanCommand({
          TableName: "api-workshop-items"
        }));
        body = scanOutput.Items;
        break;
      case "PUT /items":
        const requestJSON = JSON.parse(event.body);
        await dynamo.send(new PutItemCommand({
          TableName: "api-workshop-items",
          Item: marshall({
            id: requestJSON.id,
            price: requestJSON.price,
            name: requestJSON.name
          })
        }));
        body = `Put item ${requestJSON.id}`;
        break;
      default:
        throw new Error(`Unsupported route: "${event.routeKey}"`);
    }
  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode,
    body,
    headers
  };
};