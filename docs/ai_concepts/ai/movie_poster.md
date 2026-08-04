
![movie_poster_arch_diag](movie_poster_arch_diag.png)

## lambda function: 

**Pre-requsites**

- Create a S3 bucket name
- Create a lambda function by providing roles for both Amazon Bedrock and S3 bucket.
- Ensure pre-signed S3 url would be provided back to API gateway

```python
import json
import boto3
import base64
import datetime


def lambda_handler(event, context):
    client_s3 = boto3.client('s3')
    client_bedrock = boto3.client('bedrock-runtime')
    
    input_prompt = event['prompt']
    print("input_prompt: ", input_prompt)
    
    response_bedrock = client_bedrock.invoke_model(
        contentType='application/json',
        accept='application/json',
        modelId='amazon.nova-canvas-v1:0',
        body=json.dumps({
            "textToImageParams":{"text":input_prompt},
                "taskType":"TEXT_IMAGE",
                "imageGenerationConfig":{
                    "cfgScale":6.5,
                    "seed":12,
                    "width":1280,
                    "height":720,
                    "numberOfImages":1
                }
        })
    )

    raw = response_bedrock["body"].read()
    payload = json.loads(raw.decode("utf-8"))

    # 3) Extract base64 from either schema
    imgs = payload.get("images") or []
    first = imgs[0]
    if isinstance(first, str):
        b64_data = first
        mime_hint = "image/png"
    elif isinstance(first, dict):
        b64_data = first.get("b64") or first.get("base64") or first.get("bytes") or first.get("image")
        mime_hint = (first.get("mimeType") or "image/png").lower()
    else:
        raise RuntimeError(f"Unrecognized image element type: {type(first)}")

    if not b64_data:
        raise RuntimeError(f"No base64 data found in image object: {first}")

    # 4) Decode and persist
    response_bedrock_finalimage = base64.b64decode(b64_data)
    poster_name = 'posterName'+ datetime.datetime.today().strftime('%Y-%M-%D-%M-%S')

    # upload image to S3
    response_s3=client_s3.put_object(
        Bucket='ai-create-image',
        Body=response_bedrock_finalimage,
        Key=poster_name)
        
    # generate pre-signed url - temporary, secure URL that gives time-limited access to a specific S3 object 
    # — without making that object public
    generate_presigned_url = client_s3.generate_presigned_url('get_object', Params={'Bucket':'ai-create-image','Key':poster_name}, ExpiresIn=3600)

    # make sure you return the url so it would respond to API Gateway
    return {
        'statusCode': 200,
        'body': generate_presigned_url
    }
```

## API Gateway

- Create a resource with method as GET. 
    - **Method request** - Validate query string parameters and headers
    - **URL query string parameters** - prompt set to True
    - **Integration request settings** -> integrate with lambda
        - Mapping templates -  ```{"prompt":"$input.params('prompt')"}```

- Deploy - always create a stage called "Dev" and re-deploy couple of times to work properly.

    - **Test method** - Query strings -> prompt=image of a cat

You would get a pre-signed url as response, click on that, image is downloaded from the s3 bucket.


