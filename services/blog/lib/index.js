const blog = require('./blog');
const Contentful = require('contentful');
const { SecretsManager } = require('aws-sdk');

const secretsManager = new SecretsManager({ region: 'eu-west-1' });

const setup = async () => {
    try {
        await new Promise((resolve, reject) => {   
            secretsManager.getSecretValue({ SecretId: 'contentful-api-key'}, (err, data) => {
                if(err) {
                    console.error(err)
                    return reject(new Error("Could not get Secret"));
                }

                resolve(blog({ contentful: Contentful.createClient({
                    space: 'c85g7urd11yl',
                    accessToken: data.SecretString
                })})); 
            });
        });
    } catch (err) {
        console.error(err.message);
    }
};

module.exports.handler = setup();