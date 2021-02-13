const AWSXRay = require('aws-xray-sdk-core');
const { SecretsManager } = AWSXRay.captureAWS(require('aws-sdk'));

AWSXRay.captureHTTPsGlobal(require('http'));
AWSXRay.captureHTTPsGlobal(require('https'));
AWSXRay.capturePromise();

const Contentful = require('contentful');

const getSecret = () => new Promise((resolve, reject) => {   
    console.log("getting secret");
    secretsManager.getSecretValue({ SecretId: 'contentful-api-key'}, (err, data) => {
        if(err) {
            console.error(err)
            return reject(new Error("Could not get Secret"));
        }

        resolve(data.SecretString);
    })
});

const setup = async () => {
    try {
        return blog({ contentful: Contentful.createClient({
            space: 'c85g7urd11yl',
            accessToken: await getSecret()
        })})
        
    } catch (err) {
        console.error(err.message);
        throw err;
    }
};

module.exports.handler = async (event, context) => {
    return Object.assign({}, {event}, {context});
 }